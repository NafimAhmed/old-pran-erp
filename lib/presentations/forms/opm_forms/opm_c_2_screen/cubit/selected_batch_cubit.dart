import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/user_basic_data_response.dart';

class SelectedBatchCubit extends Cubit<UserBatch?> {
  SelectedBatchCubit() : super(null);
  void setBatch({required UserBatch selectedBatch}) {
    emit(selectedBatch);
  }
}
