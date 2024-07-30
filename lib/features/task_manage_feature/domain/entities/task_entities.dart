import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String? id;
  final String? title;
  final String? description;
  final DateTime? dueDate;
  final String? priority;
  final String? status;
  final String? assignedUser;
  final String? assignedUserImgUrl;
  final bool? isReminded;

  const TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.assignedUser,
    required this.assignedUserImgUrl,
    required this.isReminded,
  });

  @override
  List<Object?> get props => [];
}
