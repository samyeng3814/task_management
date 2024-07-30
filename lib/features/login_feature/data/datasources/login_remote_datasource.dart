import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_activity_tracker/core/env/base_config.dart';
import 'package:my_activity_tracker/features/login_feature/data/models/login_model.dart';
import 'package:my_activity_tracker/features/login_feature/domain/entities/login_auth_entity.dart';

abstract class LoginRemoteDataSource {
  Future<LoginAuthModel> userLogin(LoginCredentialEntity credentials);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  @override
  Future<LoginAuthModel> userLogin(credentials) async {
    final response = await http.post(
      Uri.parse(DevConfig().login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'email': credentials.email, 'password': credentials.password}),
    );

    if (response.statusCode == 200) {
      return LoginAuthModel.fromJson(jsonDecode(response.body));
    } else {
      throw 'Failed to login';
    }
  }
}
