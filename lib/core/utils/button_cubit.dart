
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonCubit extends Cubit<bool> {
  ButtonCubit() : super(false);

  void setLoading(bool isLoading) => emit(isLoading);
}