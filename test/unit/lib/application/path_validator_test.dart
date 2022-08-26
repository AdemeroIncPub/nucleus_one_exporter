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
        for (final td in _IsValidWindowsTestData.testData) {
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

      test('Windows absoluteFilepath tests', () {
        final pt = PathType.absoluteFilepath;
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');

        // General tests
        for (final td in _IsValidWindowsTestData.testData) {
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

      test('Windows foldername tests', () {
        final pt = PathType.foldername;
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');

        // General tests
        for (final td in _IsValidWindowsTestData.testData) {
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

      test('Windows filename tests', () {
        final pt = PathType.filename;
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');

        // General tests
        for (final td in _IsValidWindowsTestData.testData) {
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

            for (final td in _IsValidPosixTestData.testData) {
              expect(sut.isValid(td.toTest, pt), td.absoluteFolderpathMacOS,
                  reason: td.toTest);
            }
          });

          test('MacOS absoluteFilepath tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'macos');
            final pt = PathType.absoluteFilepath;

            for (final td in _IsValidPosixTestData.testData) {
              expect(sut.isValid(td.toTest, pt), td.absoluteFilepathMacOS,
                  reason: td.toTest);
            }
          });

          test('MacOS foldername tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'macos');
            final pt = PathType.filename;

            for (final td in _IsValidPosixTestData.testData) {
              expect(sut.isValid(td.toTest, pt), td.foldernameMacOS,
                  reason: td.toTest);
            }
          });

          test('MacOS filename tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'macos');
            final pt = PathType.filename;

            for (final td in _IsValidPosixTestData.testData) {
              expect(sut.isValid(td.toTest, pt), td.filenameMacOS,
                  reason: td.toTest);
            }
          });
        });

        group('Linux tests', () {
          test('Linux absoluteFolderpath tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.absoluteFolderpath;

            for (final td in _IsValidPosixTestData.testData) {
              expect(sut.isValid(td.toTest, pt), td.absoluteFolderpathLinux,
                  reason: td.toTest);
            }
          });

          test('Linux absoluteFilepath tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.absoluteFilepath;

            for (final td in _IsValidPosixTestData.testData) {
              expect(sut.isValid(td.toTest, pt), td.absoluteFilepathLinux,
                  reason: td.toTest);
            }
          });

          test('Linux foldername tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.filename;

            for (final td in _IsValidPosixTestData.testData) {
              expect(sut.isValid(td.toTest, pt), td.foldernameLinux,
                  reason: td.toTest);
            }
          });

          test('Linux filename tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.filename;

            for (final td in _IsValidPosixTestData.testData) {
              expect(sut.isValid(td.toTest, pt), td.filenameLinux,
                  reason: td.toTest);
            }
          });
        });
      });
    });

    group('makeSafeFoldername tests', () {
      test('Windows tests', () {
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');
        for (final td in _MakeSafeNameTestData.foldernameTestData) {
          expect(sut.makeSafeFoldername(td.toTest), td.windows,
              reason: td.toTest);
        }
      });
      group('POSIX tests', () {
        test('MacOS tests', () {
          final sut = PathValidator(pathContext: path_.posix, os: 'macos');
          for (final td in _MakeSafeNameTestData.foldernameTestData) {
            expect(sut.makeSafeFoldername(td.toTest), td.macOS,
                reason: td.toTest);
          }
        });
        test('Linux tests', () {
          final sut = PathValidator(pathContext: path_.posix, os: 'linux');
          for (final td in _MakeSafeNameTestData.foldernameTestData) {
            expect(sut.makeSafeFoldername(td.toTest), td.linux,
                reason: td.toTest);
          }
        });
      });
    });
    group('makeSafeFilename tests', () {
      test('Windows tests', () {
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');
        for (final td in _MakeSafeNameTestData.filenameTestData) {
          expect(sut.makeSafeFilename(td.toTest), td.windows,
              reason: td.toTest);
        }
      });
      group('POSIX tests', () {
        test('MacOS tests', () {
          final sut = PathValidator(pathContext: path_.posix, os: 'macos');
          for (final td in _MakeSafeNameTestData.filenameTestData) {
            expect(sut.makeSafeFilename(td.toTest), td.macOS,
                reason: td.toTest);
          }
        });
        test('Linux tests', () {
          final sut = PathValidator(pathContext: path_.posix, os: 'linux');
          for (final td in _MakeSafeNameTestData.filenameTestData) {
            expect(sut.makeSafeFilename(td.toTest), td.linux,
                reason: td.toTest);
          }
        });
      });
    });
  });
}

class _IsValidWindowsTestData {
  const _IsValidWindowsTestData(
    this.toTest,
    this.absoluteFolderpathWindows,
    this.absoluteFilepathWindows,
    this.foldernameWindows,
    this.filenameWindows,
  );

  final String toTest;
  final bool absoluteFolderpathWindows;
  final bool absoluteFilepathWindows;
  final bool foldernameWindows;
  final bool filenameWindows;

  static const _t = true;
  static const _f = false;
  static const List<_IsValidWindowsTestData> testData = [
    _IsValidWindowsTestData(r'.', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'..', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'..\', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'\', _t, _f, _f, _f),
    _IsValidWindowsTestData(r'\..', _t, _f, _f, _f),
    _IsValidWindowsTestData(r'.\a', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'..\a', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'..\\a', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'\a', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'\..\a', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'\a.ext', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'\a\b.ext', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'C:', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'C:a', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'C:a\', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'C:a.ext', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'C:a\b.ext', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'C:\', _t, _f, _f, _f),
    _IsValidWindowsTestData(r'C:\a', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'C:\a\', _t, _f, _f, _f),
    _IsValidWindowsTestData(r'C:\a.ext', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'C:\a\b.ext', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'\\server\share', _t, _f, _f, _f),
    _IsValidWindowsTestData(r'\\server\share\', _t, _f, _f, _f),
    _IsValidWindowsTestData(r'\\server\share\a', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'\\server\share\a\', _t, _f, _f, _f),
    _IsValidWindowsTestData(r'\\server\share\a.ext', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'\\server\share\a\b.ext', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'CA:\', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'C:A\', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'C:\A:\', _f, _f, _f, _f),
    _IsValidWindowsTestData(r':C\', _f, _f, _f, _f),
    _IsValidWindowsTestData(r'C:\🙂', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'🙂', _f, _f, _t, _t),
    _IsValidWindowsTestData(r'a', _f, _f, _t, _t),
    _IsValidWindowsTestData(r'a.ext', _f, _f, _t, _t),
    _IsValidWindowsTestData(r'a.ext.ext', _f, _f, _t, _t),
    _IsValidWindowsTestData(r'/', _t, _f, _f, _f),
    _IsValidWindowsTestData(r'/..', _t, _f, _f, _f),
    _IsValidWindowsTestData(r'/a', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'/a.ext', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'/a/b.ext', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'C:/', _t, _f, _f, _f),
    _IsValidWindowsTestData(r'C:/a', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'C:/a.ext', _t, _t, _f, _f),
    _IsValidWindowsTestData(r'C:/a/b.ext', _t, _t, _f, _f),
  ];
}

class _IsValidPosixTestData {
  const _IsValidPosixTestData(
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

  final String toTest;
  final bool absoluteFolderpathMacOS;
  final bool absoluteFilepathMacOS;
  final bool foldernameMacOS;
  final bool filenameMacOS;
  final bool absoluteFolderpathLinux;
  final bool absoluteFilepathLinux;
  final bool foldernameLinux;
  final bool filenameLinux;

  static const _t = true;
  static const _f = false;
  static const List<_IsValidPosixTestData> testData = [
    _IsValidPosixTestData(r'/', _t, _f, _f, _f, _t, _f, _f, _f),
    _IsValidPosixTestData(r'/a', _t, _t, _f, _f, _t, _t, _f, _f),
    _IsValidPosixTestData(r'/../a', _t, _t, _f, _f, _t, _t, _f, _f),
    _IsValidPosixTestData(r'/a/../b', _t, _t, _f, _f, _t, _t, _f, _f),
    _IsValidPosixTestData(r'a', _f, _f, _t, _t, _f, _f, _t, _t),
    _IsValidPosixTestData(r'a.ext', _f, _f, _t, _t, _f, _f, _t, _t),
    _IsValidPosixTestData(r'a.ext.ext', _f, _f, _t, _t, _f, _f, _t, _t),
    _IsValidPosixTestData(r'/', _t, _f, _f, _f, _t, _f, _f, _f),
    _IsValidPosixTestData(r'/..', _t, _f, _f, _f, _t, _f, _f, _f),
    _IsValidPosixTestData(r'/a', _t, _t, _f, _f, _t, _t, _f, _f),
    _IsValidPosixTestData(r'/a.ext', _t, _t, _f, _f, _t, _t, _f, _f),
    _IsValidPosixTestData(r'/a/b.ext', _t, _t, _f, _f, _t, _t, _f, _f),
    _IsValidPosixTestData(r'\', _f, _f, _t, _t, _f, _f, _t, _t),
    _IsValidPosixTestData(r'\a', _f, _f, _t, _t, _f, _f, _t, _t),
    _IsValidPosixTestData(r'C:', _f, _f, _f, _f, _f, _f, _t, _t),
    _IsValidPosixTestData(r'C:a', _f, _f, _f, _f, _f, _f, _t, _t),
    _IsValidPosixTestData(r'C:\', _f, _f, _f, _f, _f, _f, _t, _t),
    _IsValidPosixTestData(r'C:\a', _f, _f, _f, _f, _f, _f, _t, _t),
    _IsValidPosixTestData(r'C:/', _f, _f, _f, _f, _f, _f, _f, _f),
    _IsValidPosixTestData(r'C:/a', _f, _f, _f, _f, _f, _f, _f, _f),
    _IsValidPosixTestData(r'C:/a.ext', _f, _f, _f, _f, _f, _f, _f, _f),
    _IsValidPosixTestData(r'C:/a/b.ext', _f, _f, _f, _f, _f, _f, _f, _f),
  ];
}

class _MakeSafeNameTestData {
  const _MakeSafeNameTestData(
      this.toTest, this.windows, this.macOS, this.linux);

  final String toTest;
  final String windows;
  final String macOS;
  final String linux;

  static const List<_MakeSafeNameTestData> _common = [
    _MakeSafeNameTestData(r'.', '_', '_', '_'),
    _MakeSafeNameTestData(r'..', '._', '._', '._'),
    _MakeSafeNameTestData(r'\', '_', r'\', r'\'),
    _MakeSafeNameTestData(r'/', '_', '_', '_'),
    _MakeSafeNameTestData(r'.a', '.a', '.a', '.a'),
    _MakeSafeNameTestData(r'a.', 'a_', 'a.', 'a.'),
    _MakeSafeNameTestData(r'a', 'a', 'a', 'a'),
    _MakeSafeNameTestData(r'a ', 'a_', 'a ', 'a '),
    _MakeSafeNameTestData(r'a.ext', 'a.ext', 'a.ext', 'a.ext'),
    _MakeSafeNameTestData(r'a .ext', 'a .ext', 'a .ext', 'a .ext'),
    _MakeSafeNameTestData(r'a\b', 'a_b', r'a\b', r'a\b'),
    _MakeSafeNameTestData(r'a:b', 'a_b', 'a_b', 'a:b'),
    _MakeSafeNameTestData(
        r'c:\a\b<c.ext', 'c__a_b_c.ext', r'c_\a\b<c.ext', r'c:\a\b<c.ext'),
    _MakeSafeNameTestData(
        r'c:/a/b<c.ext', 'c__a_b_c.ext', r'c__a_b<c.ext', r'c:_a_b<c.ext'),
  ];

  static const List<_MakeSafeNameTestData> foldernameTestData = [
    ..._common,
    _MakeSafeNameTestData(r'CON', 'CON', 'CON', 'CON'),
    _MakeSafeNameTestData(r'CON.ext', 'CON.ext', 'CON.ext', 'CON.ext'),
    _MakeSafeNameTestData(r'aCON', 'aCON', 'aCON', 'aCON'),
    _MakeSafeNameTestData(r'COM2', 'COM2', 'COM2', 'COM2'),
    _MakeSafeNameTestData(r'COM2.ext', 'COM2.ext', 'COM2.ext', 'COM2.ext'),
    _MakeSafeNameTestData(r'aCOM2', 'aCOM2', 'aCOM2', 'aCOM2'),
    _MakeSafeNameTestData(r'LPT2', 'LPT2', 'LPT2', 'LPT2'),
    _MakeSafeNameTestData(r'LPT2.ext', 'LPT2.ext', 'LPT2.ext', 'LPT2.ext'),
    _MakeSafeNameTestData(r'aLPT2', 'aLPT2', 'aLPT2', 'aLPT2'),
    _MakeSafeNameTestData(r'con', 'con', 'con', 'con'),
    _MakeSafeNameTestData(r'con.ext', 'con.ext', 'con.ext', 'con.ext'),
    _MakeSafeNameTestData(r'acon', 'acon', 'acon', 'acon'),
    _MakeSafeNameTestData(r'com2', 'com2', 'com2', 'com2'),
    _MakeSafeNameTestData(r'com2.ext', 'com2.ext', 'com2.ext', 'com2.ext'),
    _MakeSafeNameTestData(r'acom2', 'acom2', 'acom2', 'acom2'),
    _MakeSafeNameTestData(r'lpt2', 'lpt2', 'lpt2', 'lpt2'),
    _MakeSafeNameTestData(r'lpt2.ext', 'lpt2.ext', 'lpt2.ext', 'lpt2.ext'),
    _MakeSafeNameTestData(r'alpt2', 'alpt2', 'alpt2', 'alpt2'),
  ];

  static const List<_MakeSafeNameTestData> filenameTestData = [
    ..._common,
    _MakeSafeNameTestData(r'CON', 'CON_', 'CON', 'CON'),
    _MakeSafeNameTestData(r'CON.ext', 'CON_.ext', 'CON.ext', 'CON.ext'),
    _MakeSafeNameTestData(r'aCON', 'aCON', 'aCON', 'aCON'),
    _MakeSafeNameTestData(r'COM2', 'COM2_', 'COM2', 'COM2'),
    _MakeSafeNameTestData(r'COM2.ext', 'COM2_.ext', 'COM2.ext', 'COM2.ext'),
    _MakeSafeNameTestData(r'aCOM2', 'aCOM2', 'aCOM2', 'aCOM2'),
    _MakeSafeNameTestData(r'LPT2', 'LPT2_', 'LPT2', 'LPT2'),
    _MakeSafeNameTestData(r'LPT2.ext', 'LPT2_.ext', 'LPT2.ext', 'LPT2.ext'),
    _MakeSafeNameTestData(r'aLPT2', 'aLPT2', 'aLPT2', 'aLPT2'),
    _MakeSafeNameTestData(r'con', 'con_', 'con', 'con'),
    _MakeSafeNameTestData(r'con.ext', 'con_.ext', 'con.ext', 'con.ext'),
    _MakeSafeNameTestData(r'acon', 'acon', 'acon', 'acon'),
    _MakeSafeNameTestData(r'com2', 'com2_', 'com2', 'com2'),
    _MakeSafeNameTestData(r'com2.ext', 'com2_.ext', 'com2.ext', 'com2.ext'),
    _MakeSafeNameTestData(r'acom2', 'acom2', 'acom2', 'acom2'),
    _MakeSafeNameTestData(r'lpt2', 'lpt2_', 'lpt2', 'lpt2'),
    _MakeSafeNameTestData(r'lpt2.ext', 'lpt2_.ext', 'lpt2.ext', 'lpt2.ext'),
    _MakeSafeNameTestData(r'alpt2', 'alpt2', 'alpt2', 'alpt2'),
  ];
}
