enum UserRole {
  user,
  admin;

  factory UserRole.fromString(String name) {
    return UserRole.values.firstWhere((role) => role.name == name);
  }

  String toJson() => name;
}