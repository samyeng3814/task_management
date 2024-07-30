import 'package:equatable/equatable.dart';

class TaskResponseEntity extends Equatable {
  final int userId;
  final int id;
  final String title;
  final bool completed;
  const TaskResponseEntity({
    required this.id,
    required this.title,
    required this.userId,
    required this.completed,
  });

  @override
  List<Object?> get props => [];
}
