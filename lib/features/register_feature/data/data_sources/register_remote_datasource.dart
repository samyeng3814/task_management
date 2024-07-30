import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_activity_tracker/core/env/base_config.dart';
import 'package:my_activity_tracker/features/register_feature/data/models/register_model.dart';
import 'package:my_activity_tracker/features/register_feature/domain/entities/register_entity.dart';

abstract class RegisterRemoteDataSource {
  Future<RegisterModel> userRegister(RegisterCredentialEntity credentials);
}

class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  @override
  Future<RegisterModel> userRegister(credentials) async {
    final response = await http.post(
      Uri.parse(DevConfig().login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': credentials.email,
        'password': credentials.password,
      }),
    );

    if (response.statusCode == 200) {
      return RegisterModel.fromJson(jsonDecode(response.body));
    } else {
      throw 'Failed to register';
    }
  }
}
