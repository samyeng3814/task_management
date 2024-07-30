import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_activity_tracker/core/env/base_config.dart';
import 'package:my_activity_tracker/features/user/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUserList();
  Future<UserModel> getUserDetail(String email);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<List<UserModel>> getUserList() async {
    List<dynamic> pageOneList = [];
    List<dynamic> pageTwoList = [];
    final responsePageOne =
        await http.get(Uri.parse('${DevConfig().users}?page=1'));
    final responsePageTwo =
        await http.get(Uri.parse('${DevConfig().users}?page=2'));
    if (responsePageOne.statusCode == 200 &&
        responsePageTwo.statusCode == 200) {
      pageOneList = jsonDecode(responsePageOne.body)['data'];
      pageTwoList = jsonDecode(responsePageTwo.body)['data'];
      List<dynamic> combinedList = [];
      combinedList.addAll(pageOneList);
      combinedList.addAll(pageTwoList);
      return combinedList
          .map((userJson) => UserModel.fromJson(userJson))
          .toList();
    } else {
      throw 'Failed to load users';
    }
  }

  @override
  Future<UserModel> getUserDetail(id) async {
    final response = await http.get(Uri.parse('${DevConfig().users}/$id'));
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body)['data']);
    } else {
      throw 'Failed to load user';
    }
  }
}
