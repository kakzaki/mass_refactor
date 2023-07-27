import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;
import '../bin/mass_refactor.dart' as mass_refactor;

void main() {
  group('Mass Refactor Tests', () {
    // Define a temporary directory to use for testing
    Directory? tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync();
    });

    tearDown(() {
      tempDir?.deleteSync(recursive: true);
    });

    test('File renaming with single replacement', () {
      final sampleFile = File(path.join(tempDir!.path, 'sample_file.txt'));
      sampleFile.writeAsStringSync('This is a Brand example.');

      final keywordReplacements = {'Brand': 'Category'};
      mass_refactor.main(
          ['-d', tempDir!.path, '-r', (_mapToString(keywordReplacements))]);

      expect(sampleFile.readAsStringSync(), 'This is a Category example.');
      expect(sampleFile.existsSync(), isTrue);
    });

    test('File renaming with multiple replacements', () {
      final sampleFile = File(path.join(tempDir!.path, 'sample_file.txt'));
      sampleFile.writeAsStringSync('This is a Brand and Color example.');

      final keywordReplacements = {'Brand': 'Category', 'Color': 'Colour'};
      mass_refactor.main(
          ['-d', tempDir!.path, '-r', (_mapToString(keywordReplacements))]);

      expect(sampleFile.readAsStringSync(),
          'This is a Category and Colour example.');
      expect(sampleFile.existsSync(), isTrue);
    });

    test('Folder renaming with single replacement', () {
      final sampleFolder = Directory(path.join(tempDir!.path, 'Brand_Folder'));
      sampleFolder.createSync();

      final keywordReplacements = {'Brand': 'Category'};
      mass_refactor.main(
          ['-d', tempDir!.path, '-r', (_mapToString(keywordReplacements))]);

      final updatedFolder =
          Directory(path.join(tempDir!.path, 'Category_Folder'));
      expect(sampleFolder.existsSync(), isFalse);
      expect(updatedFolder.existsSync(), isTrue);
    });

    test('Folder renaming with multiple replacements', () {
      final sampleFolder =
          Directory(path.join(tempDir!.path, 'Brand_Color_Folder'));
      sampleFolder.createSync();

      final keywordReplacements = {'Brand': 'Category', 'Color': 'Colour'};
      mass_refactor.main(
          ['-d', tempDir!.path, '-r', (_mapToString(keywordReplacements))]);

      final updatedFolder =
          Directory(path.join(tempDir!.path, 'Category_Colour_Folder'));
      expect(sampleFolder.existsSync(), isFalse);
      expect(updatedFolder.existsSync(), isTrue);
    });
  });
}

String _mapToString(Map<String, String> map) {
  return map.entries.map((entry) => '${entry.key}:${entry.value}').join(',');
}
