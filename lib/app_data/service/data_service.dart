import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';

abstract class DataService {
  Future<List<Employee>> getEmplist();
}
