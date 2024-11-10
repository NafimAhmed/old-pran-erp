import 'package:flutter_bloc/flutter_bloc.dart';

class VariableStateHandlerCubit<T> extends Cubit<T?> {
  VariableStateHandlerCubit() : super(null);
  void update(T updatedValue) {
    emit(updatedValue);
  }

  void reset() {
    emit(null);
  }
}
