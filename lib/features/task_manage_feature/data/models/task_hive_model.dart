import 'package:hive/hive.dart';
import 'package:my_activity_tracker/core/utils/utils.dart';

@HiveType(typeId: 0)
class TaskHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final String priority;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final String assignedUser;

  @HiveField(7)
  final bool isReminded;

  @HiveField(8)
  final String assignedUserImgUrl;

  TaskHiveModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.assignedUser,
    required this.isReminded,
    required this.assignedUserImgUrl,
  });

  factory TaskHiveModel.fromJson(Map<String, dynamic> json) {
    return TaskHiveModel(
      id: json['id'],
      title: json['title'],
      assignedUser: json['assigned_user'],
      description: json['description'],
      dueDate: Utils.decodeDateTime(json['due_date']),
      priority: json['priority'],
      status: json['status'],
      isReminded: json['is_reminded'],
      assignedUserImgUrl: json['assigned_user_img_url'],
    );
  }
}
