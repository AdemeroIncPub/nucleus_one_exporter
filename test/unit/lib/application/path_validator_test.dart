import 'package:glados/glados.dart';
import 'package:nucleus_one_exporter/application/path_validator.dart';
import 'package:path/path.dart' as path_;

void main() {
  group('PathValidator tests', () {
    group('isValid tests', () {
      test('Windows absoluteFolderpath tests', () {
        final pt = PathType.absoluteFolderpath;
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');
        expect(sut.isValid(r'.', pt), false);
        expect(sut.isValid(r'..', pt), false);
        expect(sut.isValid(r'..\', pt), false);
        expect(sut.isValid(r'\', pt), true);
        expect(sut.isValid(r'\', pt), true);
        expect(sut.isValid(r'\..', pt), true);
        expect(sut.isValid(r'.\a', pt), false);
        expect(sut.isValid(r'..\a', pt), false);
        expect(sut.isValid(r'..\\a', pt), false);
        expect(sut.isValid(r'\a', pt), true);
        expect(sut.isValid(r'\..\a', pt), true);
        expect(sut.isValid(r'\a.ext', pt), true);
        expect(sut.isValid(r'\a\b.ext', pt), true);
        expect(sut.isValid(r'C:', pt), false);
        expect(sut.isValid(r'C:a', pt), false);
        expect(sut.isValid(r'C:a\', pt), false);
        expect(sut.isValid(r'C:a.ext', pt), false);
        expect(sut.isValid(r'C:a\b.ext', pt), false);
        expect(sut.isValid(r'C:\', pt), true);
        expect(sut.isValid(r'C:\a', pt), true);
        expect(sut.isValid(r'C:\a\', pt), true);
        expect(sut.isValid(r'C:\a.ext', pt), true);
        expect(sut.isValid(r'C:\a\b.ext', pt), true);
        expect(sut.isValid(r'\\server\share', pt), true);
        expect(sut.isValid(r'\\server\share\', pt), true);
        expect(sut.isValid(r'\\server\share\a', pt), true);
        expect(sut.isValid(r'\\server\share\a\', pt), true);
        expect(sut.isValid(r'\\server\share\a.ext', pt), true);
        expect(sut.isValid(r'\\server\share\a\b.ext', pt), true);
        expect(sut.isValid(r'CA:\', pt), false);
        expect(sut.isValid(r'C:A\', pt), false);
        expect(sut.isValid(r'C:\A:\', pt), false);
        expect(sut.isValid(r':C\', pt), false);
        expect(sut.isValid(r'C:\🙂', pt), true);
        expect(sut.isValid(r'🙂', pt), false);
        expect(sut.isValid(r'a', pt), false);
        expect(sut.isValid(r'a.ext', pt), false);
        expect(sut.isValid(r'a.ext.ext', pt), false);

        expect(sut.isValid(r'/', pt), true);
        expect(sut.isValid(r'/..', pt), true);
        expect(sut.isValid(r'/a', pt), true);
        expect(sut.isValid(r'/a.ext', pt), true);
        expect(sut.isValid(r'/a/b.ext', pt), true);
        expect(sut.isValid(r'C:/', pt), true);
        expect(sut.isValid(r'C:/a', pt), true);
        expect(sut.isValid(r'C:/a.ext', pt), true);
        expect(sut.isValid(r'C:/a/b.ext', pt), true);

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
        expect(sut.isValid(r'.', pt), false);
        expect(sut.isValid(r'..', pt), false);
        expect(sut.isValid(r'..\', pt), false);
        expect(sut.isValid(r'\', pt), false);
        expect(sut.isValid(r'\..', pt), false);
        expect(sut.isValid(r'.\a', pt), false);
        expect(sut.isValid(r'..\a', pt), false);
        expect(sut.isValid(r'..\\a', pt), false);
        expect(sut.isValid(r'\a', pt), true);
        expect(sut.isValid(r'\..\a', pt), true);
        expect(sut.isValid(r'\a.ext', pt), true);
        expect(sut.isValid(r'\a\b.ext', pt), true);
        expect(sut.isValid(r'C:', pt), false);
        expect(sut.isValid(r'C:a', pt), false);
        expect(sut.isValid(r'C:a\', pt), false);
        expect(sut.isValid(r'C:a.ext', pt), false);
        expect(sut.isValid(r'C:a\b.ext', pt), false);
        expect(sut.isValid(r'C:\', pt), false);
        expect(sut.isValid(r'C:\a', pt), true);
        expect(sut.isValid(r'C:\a\', pt), false);
        expect(sut.isValid(r'C:\a.ext', pt), true);
        expect(sut.isValid(r'C:\a\b.ext', pt), true);
        expect(sut.isValid(r'\\server\share', pt), false);
        expect(sut.isValid(r'\\server\share\', pt), false);
        expect(sut.isValid(r'\\server\share\a', pt), true);
        expect(sut.isValid(r'\\server\share\a\', pt), false);
        expect(sut.isValid(r'\\server\share\a.ext', pt), true);
        expect(sut.isValid(r'\\server\share\a\b.ext', pt), true);
        expect(sut.isValid(r'CA:\', pt), false);
        expect(sut.isValid(r'C:A\', pt), false);
        expect(sut.isValid(r'C:\A:\', pt), false);
        expect(sut.isValid(r':C\', pt), false);
        expect(sut.isValid(r'C:\🙂', pt), true);
        expect(sut.isValid(r'🙂', pt), false);
        expect(sut.isValid(r'a', pt), false);
        expect(sut.isValid(r'a.ext', pt), false);
        expect(sut.isValid(r'a.ext.ext', pt), false);

        expect(sut.isValid(r'/', pt), false);
        expect(sut.isValid(r'/..', pt), false);
        expect(sut.isValid(r'/a', pt), true);
        expect(sut.isValid(r'/a.ext', pt), true);
        expect(sut.isValid(r'/a/b.ext', pt), true);
        expect(sut.isValid(r'C:/', pt), false);
        expect(sut.isValid(r'C:/a', pt), true);
        expect(sut.isValid(r'C:/a.ext', pt), true);
        expect(sut.isValid(r'C:/a/b.ext', pt), true);

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

      test(skip: true, 'Windows filename tests', () {
        final pt = PathType.filename;
        final sut = PathValidator(pathContext: path_.windows, os: 'windows');
        expect(sut.isValid(r'.', pt), false);
        expect(sut.isValid(r'..', pt), false);
        expect(sut.isValid(r'..\', pt), false);
        expect(sut.isValid(r'\', pt), false);
        expect(sut.isValid(r'\..', pt), false);
        expect(sut.isValid(r'.\a', pt), false);
        expect(sut.isValid(r'..\a', pt), false);
        expect(sut.isValid(r'..\\a', pt), false);
        expect(sut.isValid(r'\a', pt), false);
        expect(sut.isValid(r'\..\a', pt), false);
        expect(sut.isValid(r'\a.ext', pt), false);
        expect(sut.isValid(r'\a\b.ext', pt), false);
        expect(sut.isValid(r'C:', pt), false);
        expect(sut.isValid(r'C:a', pt), false);
        expect(sut.isValid(r'C:a\', pt), false);
        expect(sut.isValid(r'C:a.ext', pt), false);
        expect(sut.isValid(r'C:a\b.ext', pt), false);
        expect(sut.isValid(r'C:\', pt), false);
        expect(sut.isValid(r'C:\a', pt), false);
        expect(sut.isValid(r'C:\a\', pt), false);
        expect(sut.isValid(r'C:\a.ext', pt), false);
        expect(sut.isValid(r'C:\a\b.ext', pt), false);
        expect(sut.isValid(r'\\server\share', pt), false);
        expect(sut.isValid(r'\\server\share\', pt), false);
        expect(sut.isValid(r'\\server\share\a', pt), false);
        expect(sut.isValid(r'\\server\share\a\', pt), false);
        expect(sut.isValid(r'\\server\share\a.ext', pt), false);
        expect(sut.isValid(r'\\server\share\a\b.ext', pt), false);
        expect(sut.isValid(r'CA:\', pt), false);
        expect(sut.isValid(r'C:A\', pt), false);
        expect(sut.isValid(r'C:\A:\', pt), false);
        expect(sut.isValid(r':C\', pt), false);
        expect(sut.isValid(r'C:\🙂', pt), false);
        expect(sut.isValid(r'🙂', pt), true);
        expect(sut.isValid(r'a', pt), true);
        expect(sut.isValid(r'a.ext', pt), true);
        expect(sut.isValid(r'a.ext.ext', pt), true);

        expect(sut.isValid(r'/', pt), false);
        expect(sut.isValid(r'/..', pt), false);
        expect(sut.isValid(r'/a', pt), false);
        expect(sut.isValid(r'/a.ext', pt), false);
        expect(sut.isValid(r'/a/b.ext', pt), false);
        expect(sut.isValid(r'C:/', pt), false);
        expect(sut.isValid(r'C:/a', pt), false);
        expect(sut.isValid(r'C:/a.ext', pt), false);
        expect(sut.isValid(r'C:/a/b.ext', pt), false);

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

            expect(sut.isValid(r'/', pt), true);
            expect(sut.isValid(r'/a', pt), true);
            expect(sut.isValid(r'/../a', pt), true);
            expect(sut.isValid(r'/a/../b', pt), true);
            expect(sut.isValid(r'a', pt), false);
            expect(sut.isValid(r'a.ext', pt), false);
            expect(sut.isValid(r'a.ext.ext', pt), false);
            expect(sut.isValid(r'/', pt), true);
            expect(sut.isValid(r'/..', pt), true);
            expect(sut.isValid(r'/a', pt), true);
            expect(sut.isValid(r'/a.ext', pt), true);
            expect(sut.isValid(r'/a/b.ext', pt), true);

            expect(sut.isValid(r'\', pt), false);
            expect(sut.isValid(r'\a', pt), false);
            expect(sut.isValid(r'C:', pt), false);
            expect(sut.isValid(r'C:a', pt), false);
            expect(sut.isValid(r'C:\', pt), false);
            expect(sut.isValid(r'C:\a', pt), false);
            expect(sut.isValid(r'C:/', pt), false);
            expect(sut.isValid(r'C:/a', pt), false);
            expect(sut.isValid(r'C:/a.ext', pt), false);
            expect(sut.isValid(r'C:/a/b.ext', pt), false);
          });

          test('MacOS absoluteFilepath tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'macos');
            final pt = PathType.absoluteFilepath;

            expect(sut.isValid(r'/', pt), false);
            expect(sut.isValid(r'/a', pt), true);
            expect(sut.isValid(r'/../a', pt), true);
            expect(sut.isValid(r'/a/../b', pt), true);
            expect(sut.isValid(r'a', pt), false);
            expect(sut.isValid(r'a.ext', pt), false);
            expect(sut.isValid(r'a.ext.ext', pt), false);
            expect(sut.isValid(r'/', pt), false);
            expect(sut.isValid(r'/..', pt), false);
            expect(sut.isValid(r'/a', pt), true);
            expect(sut.isValid(r'/a.ext', pt), true);
            expect(sut.isValid(r'/a/b.ext', pt), true);

            expect(sut.isValid(r'\', pt), false);
            expect(sut.isValid(r'\a', pt), false);
            expect(sut.isValid(r'C:', pt), false);
            expect(sut.isValid(r'C:a', pt), false);
            expect(sut.isValid(r'C:\', pt), false);
            expect(sut.isValid(r'C:\a', pt), false);
            expect(sut.isValid(r'C:/', pt), false);
            expect(sut.isValid(r'C:/a', pt), false);
            expect(sut.isValid(r'C:/a.ext', pt), false);
            expect(sut.isValid(r'C:/a/b.ext', pt), false);
          });

          test('MacOS filename tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'macos');
            final pt = PathType.filename;

            expect(sut.isValid(r'/', pt), false);
            expect(sut.isValid(r'/a', pt), false);
            expect(sut.isValid(r'/../a', pt), false);
            expect(sut.isValid(r'/a/../b', pt), false);
            expect(sut.isValid(r'a', pt), true);
            expect(sut.isValid(r'a.ext', pt), true);
            expect(sut.isValid(r'a.ext.ext', pt), true);
            expect(sut.isValid(r'/', pt), false);
            expect(sut.isValid(r'/..', pt), false);
            expect(sut.isValid(r'/a', pt), false);
            expect(sut.isValid(r'/a.ext', pt), false);
            expect(sut.isValid(r'/a/b.ext', pt), false);

            expect(sut.isValid(r'\', pt), true);
            expect(sut.isValid(r'\a', pt), true);
            expect(sut.isValid(r'C:', pt), false);
            expect(sut.isValid(r'C:a', pt), false);
            expect(sut.isValid(r'C:\', pt), false);
            expect(sut.isValid(r'C:\a', pt), false);
            expect(sut.isValid(r'C:/', pt), false);
            expect(sut.isValid(r'C:/a', pt), false);
            expect(sut.isValid(r'C:/a.ext', pt), false);
            expect(sut.isValid(r'C:/a/b.ext', pt), false);
          });
        });

        group('Linux tests', () {
          test('Linux absoluteFolderpath tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.absoluteFolderpath;

            expect(sut.isValid(r'/', pt), true);
            expect(sut.isValid(r'/a', pt), true);
            expect(sut.isValid(r'/../a', pt), true);
            expect(sut.isValid(r'/a/../b', pt), true);
            expect(sut.isValid(r'a', pt), false);
            expect(sut.isValid(r'a.ext', pt), false);
            expect(sut.isValid(r'a.ext.ext', pt), false);
            expect(sut.isValid(r'/', pt), true);
            expect(sut.isValid(r'/..', pt), true);
            expect(sut.isValid(r'/a', pt), true);
            expect(sut.isValid(r'/a.ext', pt), true);
            expect(sut.isValid(r'/a/b.ext', pt), true);

            expect(sut.isValid(r'\', pt), false);
            expect(sut.isValid(r'\a', pt), false);
            expect(sut.isValid(r'C:', pt), false);
            expect(sut.isValid(r'C:a', pt), false);
            expect(sut.isValid(r'C:\', pt), false);
            expect(sut.isValid(r'C:\a', pt), false);
            expect(sut.isValid(r'C:/', pt), false);
            expect(sut.isValid(r'C:/a', pt), false);
            expect(sut.isValid(r'C:/a.ext', pt), false);
            expect(sut.isValid(r'C:/a/b.ext', pt), false);
          });

          test('Linux absoluteFilepath tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.absoluteFilepath;

            expect(sut.isValid(r'/', pt), false);
            expect(sut.isValid(r'/a', pt), true);
            expect(sut.isValid(r'/../a', pt), true);
            expect(sut.isValid(r'/a/../b', pt), true);
            expect(sut.isValid(r'a', pt), false);
            expect(sut.isValid(r'a.ext', pt), false);
            expect(sut.isValid(r'a.ext.ext', pt), false);
            expect(sut.isValid(r'/', pt), false);
            expect(sut.isValid(r'/..', pt), false);
            expect(sut.isValid(r'/a', pt), true);
            expect(sut.isValid(r'/a.ext', pt), true);
            expect(sut.isValid(r'/a/b.ext', pt), true);

            expect(sut.isValid(r'\', pt), false);
            expect(sut.isValid(r'\a', pt), false);
            expect(sut.isValid(r'C:', pt), false);
            expect(sut.isValid(r'C:a', pt), false);
            expect(sut.isValid(r'C:\', pt), false);
            expect(sut.isValid(r'C:\a', pt), false);
            expect(sut.isValid(r'C:/', pt), false);
            expect(sut.isValid(r'C:/a', pt), false);
            expect(sut.isValid(r'C:/a.ext', pt), false);
            expect(sut.isValid(r'C:/a/b.ext', pt), false);
          });

          test('Linux filename tests', () {
            final sut = PathValidator(pathContext: path_.posix, os: 'linux');
            final pt = PathType.filename;

            expect(sut.isValid(r'/', pt), false);
            expect(sut.isValid(r'/a', pt), false);
            expect(sut.isValid(r'/../a', pt), false);
            expect(sut.isValid(r'/a/../b', pt), false);
            expect(sut.isValid(r'a', pt), true);
            expect(sut.isValid(r'a.ext', pt), true);
            expect(sut.isValid(r'a.ext.ext', pt), true);
            expect(sut.isValid(r'/', pt), false);
            expect(sut.isValid(r'/..', pt), false);
            expect(sut.isValid(r'/a', pt), false);
            expect(sut.isValid(r'/a.ext', pt), false);
            expect(sut.isValid(r'/a/b.ext', pt), false);

            expect(sut.isValid(r'\', pt), true);
            expect(sut.isValid(r'\a', pt), true);
            expect(sut.isValid(r'C:', pt), true);
            expect(sut.isValid(r'C:a', pt), true);
            expect(sut.isValid(r'C:\', pt), true);
            expect(sut.isValid(r'C:\a', pt), true);
            expect(sut.isValid(r'C:/', pt), false);
            expect(sut.isValid(r'C:/a', pt), false);
            expect(sut.isValid(r'C:/a.ext', pt), false);
            expect(sut.isValid(r'C:/a/b.ext', pt), false);
          });
        });
      });
    });
  });
}
