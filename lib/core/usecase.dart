import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// abstract class RemoveDataUseCase<Type, Params>{
//   Future<void> call();
// }

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
