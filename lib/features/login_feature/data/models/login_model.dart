import 'package:my_activity_tracker/features/login_feature/domain/entities/login_auth_entity.dart';

class LoginAuthModel extends LoginAuthEntity {
  const LoginAuthModel({
    required String token,
   required String id,
  }) : super(token, id );

  factory LoginAuthModel.fromJson(Map<String, dynamic> json) {
    return LoginAuthModel(
      token: json['token'],
      id: json['id'] ?? '',
    );
  }
 
}