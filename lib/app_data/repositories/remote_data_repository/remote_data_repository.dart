import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';

abstract class RemoteDataRepository {
  Future<EmployeResponse> getEmplist();
}
