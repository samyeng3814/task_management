import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  const UserEntity(
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  );

  @override
  List<Object> get props => [
        email,
        firstName,
        lastName,
        avatar,
      ];
}
