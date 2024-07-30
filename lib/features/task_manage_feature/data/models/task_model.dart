import 'package:my_activity_tracker/core/utils/utils.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_entities.dart';
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_response_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required String? id,
    required String? title,
    required String? description,
    required DateTime? dueDate,
    required String? priority,
    required String? status,
    required String? assignedUser,
    required bool? isReminded,
    required String? assignedUserImgUrl,
  }) : super(
          id: id,
          title: title,
          description: description,
          dueDate: dueDate,
          priority: priority,
          status: status,
          assignedUser: assignedUser,
          isReminded: isReminded,
          assignedUserImgUrl: assignedUserImgUrl,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      assignedUser: json['assigned_user'] ?? '',
      description: json['description'] ?? '',
      dueDate: DateTime.parse(json['due_date'] ?? DateTime.now()),
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      isReminded: json['is_reminded'] ?? '',
      assignedUserImgUrl: json['assigned_user_img_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'assigned_user': assignedUser,
      'description': description,
      'due_date': Utils.encodeDateTime(dueDate!),
      'priority': priority,
      'status': status,
      'is_reminded': isReminded,
      'assigned_user_img_url': assignedUserImgUrl,
    };
  }

  static TaskModel fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      priority: entity.priority,
      status: entity.status,
      assignedUser: entity.assignedUser,
      isReminded: entity.isReminded,
      assignedUserImgUrl: entity.assignedUserImgUrl,
    );
  }
}

class TaskResponseModel extends TaskResponseEntity {
  const TaskResponseModel({
    required int id,
    required String title,
    required bool completed,
    required int userId,
  }) : super(id: id, title: title, completed: completed, userId: userId);

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskResponseModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      completed: json['completed'] ?? '',
      userId: json['userId'] ?? '',
    );
  }
}
