import 'package:my_activity_tracker/features/register_feature/domain/entities/register_entity.dart';

class RegisterModel extends RegisterEntity {
  const RegisterModel({
    required String token,
   required String id,
  }) : super(token, id );

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      token: json['token'],
      id: json['id'] ?? '',
    );
  }
 
}