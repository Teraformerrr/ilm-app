class UserProfile {
  const UserProfile({
    required this.name,
    required this.age,
    this.gender,
  });

  final String name;
  final int age;
  final String? gender;

  String get firstName {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return '';
    }

    return trimmedName
        .split(
          RegExp(r'\s+'),
        )
        .first;
  }
}