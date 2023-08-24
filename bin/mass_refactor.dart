import 'dart:io';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final argParser = ArgParser();
  argParser.addOption('directory',
      abbr: 'd', help: 'Target directory for mass refactoring (optional)');
  argParser.addMultiOption('replace',
      abbr: 'r', help: 'Keyword replacements (e.g., Brand:Category)');

  final args = argParser.parse(arguments);

  final targetDirectoryPath = args['directory'] ?? Directory.current.path;
  final targetDirectory = Directory(targetDirectoryPath);
  final keywordReplacements = _parseKeywordReplacements(args['replace'] ?? []);

  if (targetDirectory.path.isEmpty || keywordReplacements.isEmpty) {
    print(
        'Usage: mass_refactor -d <directory> -r <keyword replacements>');
    print(
        ' ');
    print(
        'Example 1: mass_refactor -d lib/feature/brand -r Brand:Category');
    print(
        'this will change all folder, file, content inside directory lib/feature/brand with keyword Brand to Category');
    print(
        ' ');
    print(
        'Example 2: mass_refactor -r Brand:Category');
    print(
        'this will change all folder, file, content inside current directory with keyword Brand to Category');    
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


/// Utility function to capitalize the first letter of a string
String capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

/// Utility function to replace keywords in file content
String replaceKeywordsInContent(
    String content, Map<String, String> keywordReplacements) {
  for (final entry in keywordReplacements.entries) {
    final keywordToReplace = entry.key;
    final replacementKeyword = entry.value;
    final regex = RegExp(keywordToReplace, caseSensitive: true);
    content = content.replaceAll(regex, replacementKeyword);
  }
  return content;
}
