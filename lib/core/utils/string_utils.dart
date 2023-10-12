extension StringExtension on String {
  String get capitalize => isEmpty ? '' : '${this[0].toUpperCase()}${substring(1).toLowerCase()}';

  String get capitalizeAllWords => split(' ').map((e) => e.capitalize).join(' ');
}
