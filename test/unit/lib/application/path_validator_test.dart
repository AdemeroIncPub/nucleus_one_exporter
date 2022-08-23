import 'package:glados/glados.dart';
import 'package:nucleus_one_exporter/application/path_validator.dart';
import 'package:path/path.dart' as path_;

void main() {
  group('PathValidator tests', () {
    group('isValid tests', () {
      test('Windows absoluteFolderpath tests', () {
        final pt = PathType.absoluteFolderpath;
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');

        // General tests
        for (final td in _testDataWindows) {
          expect(sut.isValid(td.toTest, pt), td.absoluteFolderpathWindows,
              reason: td.toTest);
        }

        // Test non-printable characters
        for (var i = 0; i < 32; i++) {
          final String char = String.fromCharCode(i);
          expect(sut.isValid('C:\\test${char}ing\\a', pt), false, reason: char);
          expect(sut.isValid('test${char}ing', pt), false, reason: char);
        }

        // Test printable invalid characters. Filter slashes since they will be
        // treated as directory separators and will not fail the test.
        for (final char
            in sut.invalidCharsWindows.where((c) => c != r'\' && c != '/')) {
          expect(sut.isValid('C:\\test${char}ing\\a', pt), false, reason: char);
          expect(sut.isValid('test${char}ing', pt), false, reason: char);
        }

        for (final foldername in sut.invalidFilenamesWindows) {
          expect(sut.isValid('C:\\${foldername.toUpperCase()}', pt), true,
              reason: foldername);
          expect(sut.isValid('C:\\${foldername.toLowerCase()}', pt), true,
              reason: foldername);
          expect(sut.isValid('C:\\${foldername.toUpperCase()}.ext', pt), true,
              reason: foldername);
          expect(sut.isValid('C:\\${foldername.toLowerCase()}.ext', pt), true,
              reason: foldername);
          expect(sut.isValid(foldername.toUpperCase(), pt), false,
              reason: foldername);
          expect(sut.isValid(foldername.toLowerCase(), pt), false,
              reason: foldername);
          expect(sut.isValid('${foldername.toUpperCase()}.ext', pt), false,
              reason: foldername);
          expect(sut.isValid('${foldername.toLowerCase()}.ext', pt), false,
              reason: foldername);
        }
      });

      test(skip: true, 'Windows absoluteFilepath tests', () {
        final pt = PathType.absoluteFilepath;
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');

        // General tests
        for (final td in _testDataWindows) {
          expect(sut.isValid(td.toTest, pt), td.absoluteFilepathWindows,
              reason: td.toTest);
        }

        // Test non-printable characters
        for (var i = 0; i < 32; i++) {
          final String char = String.fromCharCode(i);
          expect(sut.isValid('C:\\test${char}ing\\a', pt), false, reason: char);
          expect(sut.isValid('test${char}ing', pt), false, reason: char);
        }

        // Test printable invalid characters. Filter slashes since they will be
        // treated as directory separators and will not fail the test.
        for (final char
            in sut.invalidCharsWindows.where((c) => c != r'\' && c != '/')) {
          expect(sut.isValid('C:\\test${char}ing\\a', pt), false, reason: char);
          expect(sut.isValid('test${char}ing', pt), false, reason: char);
        }

        for (final filename in sut.invalidFilenamesWindows) {
          expect(sut.isValid('C:\\${filename.toUpperCase()}', pt), false,
              reason: filename);
          expect(sut.isValid('C:\\${filename.toLowerCase()}', pt), false,
              reason: filename);
          expect(sut.isValid('C:\\${filename.toUpperCase()}.ext', pt), false,
              reason: filename);
          expect(sut.isValid('C:\\${filename.toLowerCase()}.ext', pt), false,
              reason: filename);
          expect(sut.isValid(filename.toUpperCase(), pt), false,
              reason: filename);
          expect(sut.isValid(filename.toLowerCase(), pt), false,
              reason: filename);
          expect(sut.isValid('${filename.toUpperCase()}.ext', pt), false,
              reason: filename);
          expect(sut.isValid('${filename.toLowerCase()}.ext', pt), false,
              reason: filename);
        }
      });

      test(skip: true, 'Windows foldername tests', () {
        final pt = PathType.foldername;
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');

        // General tests
        for (final td in _testDataWindows) {
          expect(sut.isValid(td.toTest, pt), td.foldernameWindows,
              reason: td.toTest);
        }

        // Test non-printable characters
        for (var i = 0; i < 32; i++) {
          final String char = String.fromCharCode(i);
          expect(sut.isValid('C:\\test${char}ing\\a', pt), false, reason: char);
          expect(sut.isValid('test${char}ing', pt), false, reason: char);
        }

        // Test printable invalid characters. Filter slashes since they will be
        // treated as directory separators and will not fail the test.
        for (final char
            in sut.invalidCharsWindows.where((c) => c != r'\' && c != '/')) {
          expect(sut.isValid('C:\\test${char}ing\\a', pt), false, reason: char);
          expect(sut.isValid('test${char}ing', pt), false, reason: char);
        }

        for (final filename in sut.invalidFilenamesWindows) {
          expect(sut.isValid('C:\\${filename.toUpperCase()}', pt), false,
              reason: filename);
          expect(sut.isValid('C:\\${filename.toLowerCase()}', pt), false,
              reason: filename);
          expect(sut.isValid('C:\\${filename.toUpperCase()}.ext', pt), false,
              reason: filename);
          expect(sut.isValid('C:\\${filename.toLowerCase()}.ext', pt), false,
              reason: filename);
          expect(sut.isValid(filename.toUpperCase(), pt), true,
              reason: filename);
          expect(sut.isValid(filename.toLowerCase(), pt), true,
              reason: filename);
          expect(sut.isValid('${filename.toUpperCase()}.ext', pt), true,
              reason: filename);
          expect(sut.isValid('${filename.toLowerCase()}.ext', pt), true,
              reason: filename);
        }
      });

      test(skip: true, 'Windows filename tests', () {
        final pt = PathType.filename;
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');

        // General tests
        for (final td in _testDataWindows) {
          expect(sut.isValid(td.toTest, pt), td.filenameWindows,
              reason: td.toTest);
        }

        // Test non-printable characters
        for (var i = 0; i < 32; i++) {
          final String char = String.fromCharCode(i);
          expect(sut.isValid('C:\\test${char}ing\\a', pt), false, reason: char);
          expect(sut.isValid('test${char}ing', pt), false, reason: char);
        }

        // Test printable invalid characters. Filter slashes since they will be
        // treated as directory separators and will not fail the test.
        for (final char
            in sut.invalidCharsWindows.where((c) => c != r'\' && c != '/')) {
          expect(sut.isValid('C:\\test${char}ing\\a', pt), false, reason: char);
          expect(sut.isValid('test${char}ing', pt), false, reason: char);
        }

        for (final filename in sut.invalidFilenamesWindows) {
          expect(sut.isValid('C:\\${filename.toUpperCase()}', pt), false,
              reason: filename);
          expect(sut.isValid('C:\\${filename.toLowerCase()}', pt), false,
              reason: filename);
          expect(sut.isValid('C:\\${filename.toUpperCase()}.ext', pt), false,
              reason: filename);
          expect(sut.isValid('C:\\${filename.toLowerCase()}.ext', pt), false,
              reason: filename);
          expect(sut.isValid(filename.toUpperCase(), pt), false,
              reason: filename);
          expect(sut.isValid(filename.toLowerCase(), pt), false,
              reason: filename);
          expect(sut.isValid('${filename.toUpperCase()}.ext', pt), false,
              reason: filename);
          expect(sut.isValid('${filename.toLowerCase()}.ext', pt), false,
              reason: filename);
        }
      });

      group('POSIX tests', () {
        group('MacOS tests', () {
          test('MacOS absoluteFolderpath tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'macos');
            final pt = PathType.absoluteFolderpath;

            for (final td in _testDataPosix) {
              expect(sut.isValid(td.toTest, pt), td.absoluteFolderpathMacOS,
                  reason: td.toTest);
            }
          });

          test('MacOS absoluteFilepath tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'macos');
            final pt = PathType.absoluteFilepath;

            for (final td in _testDataPosix) {
              expect(sut.isValid(td.toTest, pt), td.absoluteFilepathMacOS,
                  reason: td.toTest);
            }
          });

          test('MacOS foldername tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'macos');
            final pt = PathType.filename;

            for (final td in _testDataPosix) {
              expect(sut.isValid(td.toTest, pt), td.foldernameMacOS,
                  reason: td.toTest);
            }
          });

          test('MacOS filename tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'macos');
            final pt = PathType.filename;

            for (final td in _testDataPosix) {
              expect(sut.isValid(td.toTest, pt), td.filenameMacOS,
                  reason: td.toTest);
            }
          });
        });

        group('Linux tests', () {
          test('Linux absoluteFolderpath tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.absoluteFolderpath;

            for (final td in _testDataPosix) {
              expect(sut.isValid(td.toTest, pt), td.absoluteFolderpathLinux,
                  reason: td.toTest);
            }
          });

          test('Linux absoluteFilepath tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.absoluteFilepath;

            for (final td in _testDataPosix) {
              expect(sut.isValid(td.toTest, pt), td.absoluteFilepathLinux,
                  reason: td.toTest);
            }
          });

          test('Linux foldername tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.filename;

            for (final td in _testDataPosix) {
              expect(sut.isValid(td.toTest, pt), td.foldernameLinux,
                  reason: td.toTest);
            }
          });

          test('Linux filename tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.filename;

            for (final td in _testDataPosix) {
              expect(sut.isValid(td.toTest, pt), td.filenameLinux,
                  reason: td.toTest);
            }
          });
        });
      });
    });
  });
}

class _TestDataWindows {
  _TestDataWindows(
    this.toTest,
    this.absoluteFolderpathWindows,
    this.absoluteFilepathWindows,
    this.foldernameWindows,
    this.filenameWindows,
  );

  String toTest;
  bool absoluteFolderpathWindows;
  bool absoluteFilepathWindows;
  bool foldernameWindows;
  bool filenameWindows;
}

const _t = true;
const _f = false;
List<_TestDataWindows> _testDataWindows = [
  _TestDataWindows(r'.', _f, _f, _f, _f),
  _TestDataWindows(r'..', _f, _f, _f, _f),
  _TestDataWindows(r'..\', _f, _f, _f, _f),
  _TestDataWindows(r'\', _t, _f, _f, _f),
  _TestDataWindows(r'\..', _t, _f, _f, _f),
  _TestDataWindows(r'.\a', _f, _f, _f, _f),
  _TestDataWindows(r'..\a', _f, _f, _f, _f),
  _TestDataWindows(r'..\\a', _f, _f, _f, _f),
  _TestDataWindows(r'\a', _t, _t, _f, _f),
  _TestDataWindows(r'\..\a', _t, _t, _f, _f),
  _TestDataWindows(r'\a.ext', _t, _t, _f, _f),
  _TestDataWindows(r'\a\b.ext', _t, _t, _f, _f),
  _TestDataWindows(r'C:', _f, _f, _f, _f),
  _TestDataWindows(r'C:a', _f, _f, _f, _f),
  _TestDataWindows(r'C:a\', _f, _f, _f, _f),
  _TestDataWindows(r'C:a.ext', _f, _f, _f, _f),
  _TestDataWindows(r'C:a\b.ext', _f, _f, _f, _f),
  _TestDataWindows(r'C:\', _t, _f, _f, _f),
  _TestDataWindows(r'C:\a', _t, _t, _f, _f),
  _TestDataWindows(r'C:\a\', _t, _f, _f, _f),
  _TestDataWindows(r'C:\a.ext', _t, _t, _f, _f),
  _TestDataWindows(r'C:\a\b.ext', _t, _t, _f, _f),
  _TestDataWindows(r'\\server\share', _t, _f, _f, _f),
  _TestDataWindows(r'\\server\share\', _t, _f, _f, _f),
  _TestDataWindows(r'\\server\share\a', _t, _t, _f, _f),
  _TestDataWindows(r'\\server\share\a\', _t, _f, _f, _f),
  _TestDataWindows(r'\\server\share\a.ext', _t, _t, _f, _f),
  _TestDataWindows(r'\\server\share\a\b.ext', _t, _t, _f, _f),
  _TestDataWindows(r'CA:\', _f, _f, _f, _f),
  _TestDataWindows(r'C:A\', _f, _f, _f, _f),
  _TestDataWindows(r'C:\A:\', _f, _f, _f, _f),
  _TestDataWindows(r':C\', _f, _f, _f, _f),
  _TestDataWindows(r'C:\🙂', _t, _t, _f, _f),
  _TestDataWindows(r'🙂', _f, _f, _t, _t),
  _TestDataWindows(r'a', _f, _f, _t, _t),
  _TestDataWindows(r'a.ext', _f, _f, _t, _t),
  _TestDataWindows(r'a.ext.ext', _f, _f, _t, _t),
  _TestDataWindows(r'/', _t, _f, _f, _f),
  _TestDataWindows(r'/..', _t, _f, _f, _f),
  _TestDataWindows(r'/a', _t, _t, _f, _f),
  _TestDataWindows(r'/a.ext', _t, _t, _f, _f),
  _TestDataWindows(r'/a/b.ext', _t, _t, _f, _f),
  _TestDataWindows(r'C:/', _t, _f, _f, _f),
  _TestDataWindows(r'C:/a', _t, _t, _f, _f),
  _TestDataWindows(r'C:/a.ext', _t, _t, _f, _f),
  _TestDataWindows(r'C:/a/b.ext', _t, _t, _f, _f),
];

class _TestDataPosix {
  _TestDataPosix(
    this.toTest,
    this.absoluteFolderpathMacOS,
    this.absoluteFilepathMacOS,
    this.foldernameMacOS,
    this.filenameMacOS,
    this.absoluteFolderpathLinux,
    this.absoluteFilepathLinux,
    this.foldernameLinux,
    this.filenameLinux,
  );

  String toTest;
  bool absoluteFolderpathMacOS;
  bool absoluteFilepathMacOS;
  bool foldernameMacOS;
  bool filenameMacOS;
  bool absoluteFolderpathLinux;
  bool absoluteFilepathLinux;
  bool foldernameLinux;
  bool filenameLinux;
}

List<_TestDataPosix> _testDataPosix = [
  _TestDataPosix(r'/', _t, _f, _f, _f, _t, _f, _f, _f),
  _TestDataPosix(r'/a', _t, _t, _f, _f, _t, _t, _f, _f),
  _TestDataPosix(r'/../a', _t, _t, _f, _f, _t, _t, _f, _f),
  _TestDataPosix(r'/a/../b', _t, _t, _f, _f, _t, _t, _f, _f),
  _TestDataPosix(r'a', _f, _f, _t, _t, _f, _f, _t, _t),
  _TestDataPosix(r'a.ext', _f, _f, _t, _t, _f, _f, _t, _t),
  _TestDataPosix(r'a.ext.ext', _f, _f, _t, _t, _f, _f, _t, _t),
  _TestDataPosix(r'/', _t, _f, _f, _f, _t, _f, _f, _f),
  _TestDataPosix(r'/..', _t, _f, _f, _f, _t, _f, _f, _f),
  _TestDataPosix(r'/a', _t, _t, _f, _f, _t, _t, _f, _f),
  _TestDataPosix(r'/a.ext', _t, _t, _f, _f, _t, _t, _f, _f),
  _TestDataPosix(r'/a/b.ext', _t, _t, _f, _f, _t, _t, _f, _f),
  _TestDataPosix(r'\', _f, _f, _t, _t, _f, _f, _t, _t),
  _TestDataPosix(r'\a', _f, _f, _t, _t, _f, _f, _t, _t),
  _TestDataPosix(r'C:', _f, _f, _f, _f, _f, _f, _t, _t),
  _TestDataPosix(r'C:a', _f, _f, _f, _f, _f, _f, _t, _t),
  _TestDataPosix(r'C:\', _f, _f, _f, _f, _f, _f, _t, _t),
  _TestDataPosix(r'C:\a', _f, _f, _f, _f, _f, _f, _t, _t),
  _TestDataPosix(r'C:/', _f, _f, _f, _f, _f, _f, _f, _f),
  _TestDataPosix(r'C:/a', _f, _f, _f, _f, _f, _f, _f, _f),
  _TestDataPosix(r'C:/a.ext', _f, _f, _f, _f, _f, _f, _f, _f),
  _TestDataPosix(r'C:/a/b.ext', _f, _f, _f, _f, _f, _f, _f, _f),
];
