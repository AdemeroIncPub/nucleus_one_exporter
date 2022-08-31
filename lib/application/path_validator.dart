import 'dart:io';

import 'package:characters/characters.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path_ show context, Context;
import 'package:quiver/strings.dart' as quiver;

enum PathType {
  absoluteFolderpath,
  absoluteFilepath,
  foldername,
  filename,
}

/// Use [PathValidator] to validate absolute paths and filenames. The paths may
/// or may not exist and are not checked. The validation is performed using
/// knowledge of invalid characters, reserved files names, etc.
class PathValidator {
  PathValidator({path_.Context? pathContext, String? os})
      : _pathContext = pathContext ?? path_.context,
        _os = os ?? Platform.operatingSystem;

  static const _replacementChar = '_';

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
        if (_os == 'windows' && path.endsWith(r'\')) {
          return false;
        }
        if (path.endsWith('/')) {
          return false;
        }
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

      case PathType.foldername:
        pathComponents = [path];
        break;

      case PathType.filename:
        pathComponents = const Iterable.empty();
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

  /// Pass a single foldername component. The passed string will not be split on
  /// slashes, instead the slashes will be replaced.
  String makeSafeFoldername(String foldername) {
    return _makeSafeName(foldername);
  }

  String makeSafeFilename(String filename) {
    final safeName = _makeSafeName(filename);
    if (_isFilenameReserved(safeName)) {
      return _pathContext.basenameWithoutExtension(safeName) +
          _replacementChar +
          _pathContext.extension(safeName);
    }
    return safeName;
  }

  String _makeSafeName(String name) {
    if (_isComponentRelative(name)) {
      return name.characters.skipLast(1).toString() + _replacementChar;
    }

    final resultBuffer = StringBuffer();

    // Replace invalid characters
    for (final c in name.characters) {
      if (!_isCharValid(c.characters)) {
        resultBuffer.write(_replacementChar);
      } else {
        resultBuffer.write(c);
      }
    }

    // Check and replace final character if needed.
    String result = resultBuffer.toString();
    if (!_isFinalCharValid(result)) {
      result = result.characters.skipLast(1).string + _replacementChar;
    }

    return result;
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
    for (final c in component.characters) {
      if (!_isCharValid(c.characters)) {
        return false;
      }
    }

    if (!_isFinalCharValid(component)) {
      return false;
    }

    return true;
  }

  bool _isCharValid(Characters singleCharacter) {
    assert(singleCharacter.length == 1);
    final c = singleCharacter.string;

    // Check non-printable ASCII (0 - 31)
    if (c.codeUnits.length == 1 && c.codeUnits[0] < 32) {
      return false;
    }

    // Check for invalid characters.
    if (_os == 'windows') {
      if (invalidCharsWindows.contains(c)) {
        return false;
      }
    } else if (_os == 'macos') {
      if (invalidCharsMacOS.contains(c)) {
        return false;
      }
    } else {
      if (c == '/') {
        return false;
      }
    }

    return true;
  }

  bool _isFinalCharValid(String component) {
    // Windows components cannot end with a space or a period.
    if (_os == 'windows') {
      if (component.endsWith(' ')) {
        return false;
      }

      if (component.endsWith('.')) {
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
    return pathComponent == '.' || pathComponent == '..';
  }
}
