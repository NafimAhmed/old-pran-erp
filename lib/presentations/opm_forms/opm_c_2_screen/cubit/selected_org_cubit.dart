import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pran_rfl_erp/app_data/entities/user_org_response.dart';

class SelectedOrgCubit extends Cubit<UserOrg?> {
  SelectedOrgCubit() : super(null);
  void setOrg({required UserOrg userOrg}) {
    emit(userOrg);
  }
}
