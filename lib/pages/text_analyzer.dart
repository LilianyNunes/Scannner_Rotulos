import 'package:string_similarity/string_similarity.dart';
import 'package:diacritic/diacritic.dart';

class TextAnalyzer {
  static final List<List<String>> _target = [
    ["GORDURA", "SATURADA"],
    ["SÓDIO"],
    ["AÇÚCAR", "ADICIONADO"],
  ];

  static String normalizeText(String input) {
    // Remove acentos usando o pacote 'diacritic'
    String noDiacritics = removeDiacritics(input);

    // Remove múltiplos espaços e trim
    String noExtraSpaces = noDiacritics.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Converte para maiúsculas
    return noExtraSpaces.toUpperCase();
  }

  static List<String> checkFuzzyMatches(String text, {double threshold = 0.7}) {
    final List<String> matches = [];
    final normalizedText = normalizeText(text);
    final lines = normalizedText.split(RegExp(r'\s+'));

    bool containsWordFuzzy(String word) {
      final normalizedWord = normalizeText(word);
      for (var line in lines) {
        if (StringSimilarity.compareTwoStrings(normalizedWord, line) > threshold) {
          return true;
        }
      }
      return false;
    }

    for (var group in _target) {
      bool allPresent = true;
      for (var word in group) {
        if (!containsWordFuzzy(word)) {
          allPresent = false;
          break;
        }
      }
      if (allPresent) {
        matches.add("ALTO EM ${group.join(' ')}");
      }
    }

    return matches;
  }
}
