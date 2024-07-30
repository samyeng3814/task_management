import 'package:hive/hive.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';
import 'package:my_activity_tracker/features/user/data/models/user_hive_model.dart';

class TaskHiveModelAdapter extends TypeAdapter<TaskHiveModel> {
  @override
  final typeId = 0;

  @override
  TaskHiveModel read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final description = reader.readString();
    final priority = reader.readString();
    final status = reader.readString();
    final dueDate = DateTime.parse(reader.readString());
    final assignedUser = reader.readString();
    final isRemined = reader.readBool();
    final assignedUserImgUrl = reader.readString();
    return TaskHiveModel(
      id: id,
      title: title,
      description: description,
      priority: priority,
      status: status,
      dueDate: dueDate,
      assignedUser: assignedUser,
      isReminded: isRemined,
      assignedUserImgUrl: assignedUserImgUrl,
    );
  }

  @override
  void write(BinaryWriter writer, TaskHiveModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeString(obj.priority);
    writer.writeString(obj.status);
    writer.writeString(obj.dueDate.toIso8601String());
    writer.writeString(obj.assignedUser);
    writer.writeBool(obj.isReminded);
    writer.writeString(obj.assignedUserImgUrl);
  }
}

class UserHiveModelAdapter extends TypeAdapter<UserHiveModel> {
  @override
  final int typeId = 1;

  @override
  UserHiveModel read(BinaryReader reader) {
     final id= reader.readString();
     final email= reader.readString();
     final avatarUrl= reader.readString();
     final  token= reader.readString();
     final username= reader.readString();
    return UserHiveModel(
      id: id,
      email: email,
      avatarUrl: avatarUrl,
      token: token,
      username: username,
    );
  }

  @override
  void write(BinaryWriter writer, UserHiveModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.email);
    writer.writeString(obj.avatarUrl);
    writer.writeString(obj.token);
    writer.writeString(obj.username);
  }
}
