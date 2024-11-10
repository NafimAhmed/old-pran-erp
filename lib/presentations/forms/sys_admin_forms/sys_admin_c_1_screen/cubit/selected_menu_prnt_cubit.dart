import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/sys_menu_parent_data_response.dart';

class SelectedMenuPrntCubit extends Cubit<SysMenuparentData?> {
  SelectedMenuPrntCubit() : super(null);
  void setSelectedMenuPrnt({required SysMenuparentData sysMenuparentData}) {
    emit(sysMenuparentData);
  }

  void resetMenuPrnt() {
    emit(null);
  }
}
