import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
import 'package:pran_rfl_erp/app_data/entities/lov_response.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';

abstract class DataService {
  Future<List<Employee>> getEmplist();
  Future<bool> sendProdQrInfo(
    String itemId,
    String batchId,
    String qty,
    String goodQty,
    String badQty,
    String machine,
  );
  Future<List<TempBatchData>> getTempBatchData();
  Future<void> transferBatch(String batchId, String itemId, String rackId);
  Future<List<TransferBatchData>> getTransferBatchData();
  Future<List<Lov>> getLov();
  Future<void> rackTransfer(int transactId);
}
