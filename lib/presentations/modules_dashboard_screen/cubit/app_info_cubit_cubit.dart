import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/core/utils/app_info_helper.dart';

class AppInfoCubitCubit extends Cubit<String?> {
  AppInfoCubitCubit() : super(null);
  Future<void> getInfo() async {
    var response = await AppInfoHelper.getAppInfo();
    emit(response);
  }
}
// Map<String, dynamic>?