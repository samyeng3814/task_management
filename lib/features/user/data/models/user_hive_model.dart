import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String avatarUrl;

  @HiveField(4)
  final String token;

  UserHiveModel({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
    required this.token,
  });
}
