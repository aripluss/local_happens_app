import 'package:equatable/equatable.dart';
import 'package:local_happens/features/auth/domain/entities/user_role.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String avatarUrl;
  final UserRole role;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.avatarUrl,
    required this.role,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, name, avatarUrl, role, createdAt];
}
