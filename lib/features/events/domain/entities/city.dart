import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String id;
  final String name;
  final String normalizedName;

  const City({
    required this.id,
    required this.name,
    required this.normalizedName,
  });

  @override
  List<Object?> get props => [id, name, normalizedName];
}
