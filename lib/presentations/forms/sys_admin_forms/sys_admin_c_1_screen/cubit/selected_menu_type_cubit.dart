import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/presentations/forms/sys_admin_forms/sys_admin_c_1_screen/sys_admin_c_1_screen.dart';

class SelectedMenuTypeCubit extends Cubit<MenuType?> {
  SelectedMenuTypeCubit() : super(null);
  void setSelectedMenuType({required MenuType menuType}) {
    emit(menuType);
  }

  void resetMenuType() {
    emit(null);
  }
}
