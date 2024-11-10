import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/system_module_response.dart';

class SelectedModuleCubit extends Cubit<SysModuleData?> {
  SelectedModuleCubit() : super(null);
  void setSelectedModule({required SysModuleData sysModuleData}) {
    emit(sysModuleData);
  }

  void resetModule() {
    emit(null);
  }
}
