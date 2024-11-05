import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/user_basic_data_response.dart';

class SelectedMachineCubit extends Cubit<UserMachine?> {
  SelectedMachineCubit() : super(null);
  void setMachine({required UserMachine selectedMachine}) {
    emit(selectedMachine);
  }
}
