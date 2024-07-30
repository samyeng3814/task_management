import 'package:my_activity_tracker/features/user/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String avatar,
  }) : super(id, email, firstName, lastName, avatar);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
  static List<UserModel> userListFromJson(List data) => data
      .map(
        (e) => UserModel.fromJson(e),
      )
      .toList();
}
