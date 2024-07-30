import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_activity_tracker/core/env/base_config.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_hive_model.dart';
import 'package:my_activity_tracker/features/task_manage_feature/data/models/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:my_activity_tracker/features/task_manage_feature/domain/entities/task_entities.dart';

abstract class TaskDataSource {
  Future<List<TaskResponseModel>> getRemoteTasks();
  Future<String> addTask(TaskEntity task);
  Future<String> updateTask(TaskEntity task);
  Future<String> deleteTask(String id);
  Future<List<TaskHiveModel>> getLocalTasks();
}

class TaskDataSourceImpl implements TaskDataSource {
  @override
  Future<List<TaskResponseModel>> getRemoteTasks() async {
    final response = await http.get(
        Uri.parse(DevConfig().taskService)); // Fetch from remote data source
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final tasks =
          data.map((json) => TaskResponseModel.fromJson(json)).toList();
      return tasks;
    } else {
      throw 'Failed to load tasks';
    }
  }

  @override
  Future<String> addTask(task) async {
    final response = await http.post(
      Uri.parse(DevConfig().taskService),
      body: json.encode(TaskModel.fromEntity(task).toJson()),
    );
    if (response.statusCode == 201) {
      Box<TaskHiveModel> taskBox = await Hive.openBox<TaskHiveModel>('taskBox');
      final taskModel =
          TaskHiveModel.fromJson(TaskModel.fromEntity(task).toJson());
      await taskBox.put(taskModel.id, taskModel);
      return 'Task successfully added';
    } else {
      throw 'Failed to add task';
    }
  }

  @override
  Future<String> updateTask(task) async {
    final response = await http.put(
      Uri.parse('${DevConfig().taskService}200'),
      body: json.encode(TaskModel.fromEntity(task).toJson()),
    );
    if (response.statusCode == 200) {
      Box<TaskHiveModel> taskBox = await Hive.openBox<TaskHiveModel>('taskBox');
      final taskModel =
          TaskHiveModel.fromJson(TaskModel.fromEntity(task).toJson());
      await taskBox.delete(task.id);
      await taskBox.put(taskModel.id, taskModel);
      return 'Task successfully updated';
    } else {
      throw 'Failed to update task';
    }
  }

  @override
  Future<String> deleteTask(String id) async {
    final response = await http.delete(
      Uri.parse('${DevConfig().taskService}$id'),
    );
    if (response.statusCode == 200) {
      Box<TaskHiveModel> taskBox = await Hive.openBox<TaskHiveModel>('taskBox');
      await taskBox.delete(id);
      return 'Task successfully deleted';
    } else {
      throw 'Failed to delete task';
    }
  }

  @override
  Future<List<TaskHiveModel>> getLocalTasks() async {
    Box<TaskHiveModel> taskBox = await Hive.openBox<TaskHiveModel>('taskBox');
    final taskModels = taskBox.values.toList();
    return taskModels;
  }
}
