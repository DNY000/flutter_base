extension StringExt on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalizeFirst()).join(' ');
  }

  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  bool get isValidPhone {
    return RegExp(r'^(0|\+84)[3|5|7|8|9][0-9]{8}$').hasMatch(this);
  }
}

extension NullableStringExt on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  String orEmpty([String fallback = '']) => this ?? fallback;
}
