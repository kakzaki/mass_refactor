import 'dart:io';
import 'package:args/args.dart';
import 'package:mass_refactor/mass_refactor.dart';

void main(List<String> arguments) {
  final argParser = ArgParser();
  argParser.addOption('directory',
      abbr: 'd', help: 'Target directory for mass refactoring');
  argParser.addMultiOption('replace',
      abbr: 'r', help: 'Keyword replacements (e.g., Brand:Category)');

  final args = argParser.parse(arguments);

  final targetDirectory = Directory(args['directory'] ?? '');
  final keywordReplacements = _parseKeywordReplacements(args['replace'] ?? []);

  if (targetDirectory.path.isEmpty || keywordReplacements.isEmpty) {
    print(
        'Usage: dart mass_refactor.dart -d <directory> -r <keyword replacements>');
    return;
  }

  try {
    if (targetDirectory.existsSync()) {
      _renameFilesAndFolders(targetDirectory, keywordReplacements);

      print('Mass refactor completed successfully.');
    } else {
      print('Error: Target directory not found.');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Map<String, String> _parseKeywordReplacements(List<String> replacements) {
  final keywordReplacements = <String, String>{};
  for (final replacement in replacements) {
    final parts = replacement.split(':');
    if (parts.length == 2) {
      keywordReplacements[parts[0]] = parts[1];
    }
  }
  return keywordReplacements;
}

void _renameFilesAndFolders(
    Directory directory, Map<String, String> keywordReplacements) {
  for (final entity in directory.listSync()) {
    if (entity is File) {
      _renameFileContent(entity, keywordReplacements);
      _renameFile(entity, keywordReplacements);
    } else if (entity is Directory) {
      _renameFilesAndFolders(entity, keywordReplacements);
      _renameFolder(entity, keywordReplacements);
    }
  }
}

void _renameFileContent(File file, Map<String, String> keywordReplacements) {
  try {
    String content = file.readAsStringSync();
    content = replaceKeywordsInContent(content, keywordReplacements);
    file.writeAsStringSync(content);
  } catch (e) {
    print('Error while renaming file content: $e');
  }
}

void _renameFile(File file, Map<String, String> keywordReplacements) {
  try {
    final fileName = file.path.split(Platform.pathSeparator).last;
    String newFileName = fileName;
    for (final entry in keywordReplacements.entries) {
      final keywordToReplace = entry.key;
      final replacementKeyword = entry.value;
      final regex = RegExp(keywordToReplace, caseSensitive: true);
      newFileName = newFileName.replaceAll(regex, replacementKeyword);
    }
    if (fileName != newFileName) {
      final newPath = file.parent.path + Platform.pathSeparator + newFileName;
      file.renameSync(newPath);
    }
  } catch (e) {
    print('Error while renaming file: $e');
  }
}

void _renameFolder(
    Directory directory, Map<String, String> keywordReplacements) {
  try {
    final folderName = directory.path.split(Platform.pathSeparator).last;
    String newFolderName = folderName;
    for (final entry in keywordReplacements.entries) {
      final keywordToReplace = entry.key;
      final replacementKeyword = entry.value;
      final regex = RegExp(keywordToReplace, caseSensitive: true);
      newFolderName = newFolderName.replaceAll(regex, replacementKeyword);
    }
    if (folderName != newFolderName) {
      final newPath =
          directory.parent.path + Platform.pathSeparator + newFolderName;
      directory.renameSync(newPath);
    }
  } catch (e) {
    print('Error while renaming folder: $e');
  }
}
