/// The official command line interface for mass_refactor
///
/// ```sh
/// # 🎯 Activate mass_refactor
/// dart pub global activate mass_refactor
///
/// # 👀 See usage
/// mass_refactor --help
/// ```
library mass_refactor;


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
