import 'dart:io';

import 'package:characters/characters.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path_ show context, Context;
import 'package:quiver/strings.dart' as quiver;

enum PathType {
  absoluteFolderpath,
  absoluteFilepath,
  filename,
}

/// Use [PathValidator] to validate absolute paths and filenames. The paths may
/// or may not exist and are not checked. The validation is performed using
/// knowledge of invalid characters, reserved files names, etc.
class PathValidator {
  @visibleForTesting
  PathValidator({path_.Context? pathContext, String? os})
      : _pathContext = pathContext ?? path_.context,
        _os = os ?? Platform.operatingSystem;

  final path_.Context _pathContext;
  final String _os;

  @visibleForTesting
  final Characters invalidCharsMacOS = Characters(r':/');

  @visibleForTesting
  final Characters invalidCharsWindows = Characters(r'<>:"/\|?*');

  @visibleForTesting
  final List<String> invalidFilenamesWindows = [
    'CON',
    'PRN',
    'AUX',
    'NUL',
    'COM1',
    'COM2',
    'COM3',
    'COM4',
    'COM5',
    'COM6',
    'COM7',
    'COM8',
    'COM9',
    'LPT1',
    'LPT2',
    'LPT3',
    'LPT4',
    'LPT5',
    'LPT6',
    'LPT7',
    'LPT8',
    'LPT9',
  ];

  /// [validateAs] is required since without a specific purpose there are
  /// ambiguities in determining if a path string is valid or not.
  bool isValid(String path, PathType validateAs) {
    if (quiver.isBlank(path)) {
      return false;
    }

    final components = _pathContext.split(_pathContext.normalize(path));
    final rootComponent = components.first;

    Iterable<String> pathComponents;
    String? filenameComponent;
    switch (validateAs) {
      case PathType.absoluteFolderpath:
        if (!_pathContext.isAbsolute(path)) {
          return false;
        }
        pathComponents = components.skip(1);
        break;
      case PathType.absoluteFilepath:
        if (!_pathContext.isAbsolute(path)) {
          return false;
        }
        // An absolute filepath must have at least a root and a filename.
        if (components.length < 2) {
          return false;
        }
        pathComponents = components.take(components.length - 1).skip(1);
        filenameComponent = components.last;
        break;
      case PathType.filename:
        pathComponents = Iterable.empty();
        filenameComponent = path;
        break;
      default:
        throw UnsupportedError('Unsupported PathType: ${validateAs.name}');
    }

    // Validate root compoment.
    if (validateAs == PathType.absoluteFolderpath ||
        validateAs == PathType.absoluteFilepath) {
      if (!_isRootValid(rootComponent)) {
        return false;
      }
    }

    // Validate folder components.
    for (final pathComponent in pathComponents) {
      if (!_areAllCharactersValid(pathComponent)) {
        return false;
      }
    }

    // Validate filename component.
    if (filenameComponent != null && !_isFilenameValid(filenameComponent)) {
      return false;
    }

    return true;
  }

  bool _isRootValid(String rootOnly) {
    if (_os == 'windows') {
      // UNC root
      if (rootOnly.startsWith(r'\\') &&
          _areAllCharactersValid(rootOnly.replaceAll(r'\', ''))) {
        return true;
      }

      // Current drive root
      if (rootOnly == r'\') {
        return true;
      }

      // Drive letter root
      if (rootOnly.contains(':')) {
        if (rootOnly.contains(RegExp(r'^[a-zA-Z]:\\$'))) {
          return true;
        }
      }

      return false;
    } else {
      return rootOnly == '/';
    }
  }

  bool _isFilenameValid(String filename) {
    if (!_areAllCharactersValid(filename)) {
      return false;
    }
    if (_isComponentRelative(filename)) {
      return false;
    }
    return !_isFilenameReserved(filename);
  }

  bool _areAllCharactersValid(String component) {
    // Check non-printable ASCII (0 - 31)
    for (final rune in component.runes) {
      if (rune < 32) {
        return false;
      }
    }

    if (_os == 'windows') {
      // Check for invalid characters.
      if (invalidCharsWindows.any((e) => component.contains(e))) {
        return false;
      }

      // Cannot end with space
      if (component.endsWith(' ')) {
        return false;
      }

      // Cannot end with period
      // A path of '.' or './' will normalize to just '.'
      if (component.endsWith('.')) {
        return false;
      }
    } else if (_os == 'macos') {
      // Check for invalid characters.
      if (invalidCharsMacOS.any((e) => component.contains(e))) {
        return false;
      }
    } else {
      if (component.contains('/')) {
        return false;
      }
    }

    return true;
  }

  bool _isFilenameReserved(String path) {
    if (_os == 'windows') {
      final basenameWithoutExtension =
          _pathContext.basenameWithoutExtension(path);
      if (invalidFilenamesWindows.any((invalid) =>
          invalid.toLowerCase() == basenameWithoutExtension.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  bool _isComponentRelative(String pathComponent) {
    return pathComponent == '.' && pathComponent == '..';
  }
}
