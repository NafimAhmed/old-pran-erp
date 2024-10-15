import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';

abstract class DataService {
  Future<List<Employee>> getEmplist();
  Future<bool> sendProdQrInfo(
    String itemId,
    String batchId,
    String qty,
    String goodQty,
    String badQty,
  );
}
