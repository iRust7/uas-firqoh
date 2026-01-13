enum NoteFilter {
  pinned,        // Pinned first (default)
  alphabetical,  // A-Z by title
  newestFirst,   // Recently updated first
  oldestFirst,   // Oldest updated first
}

extension NoteFilterExtension on NoteFilter {
  String get displayName {
    switch (this) {
      case NoteFilter.pinned:
        return 'Pinned First';
      case NoteFilter.alphabetical:
        return 'Alphabetical (A-Z)';
      case NoteFilter.newestFirst:
        return 'Newest First';
      case NoteFilter.oldestFirst:
        return 'Oldest First';
    }
  }

  String get value {
    return toString().split('.').last;
  }

  static NoteFilter fromValue(String value) {
    return NoteFilter.values.firstWhere(
      (filter) => filter.value == value,
      orElse: () => NoteFilter.pinned,
    );
  }
}
