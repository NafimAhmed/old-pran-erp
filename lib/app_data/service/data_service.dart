import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/entities/lov_response.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';

abstract class DataService {
  Future<List<Employee>> getEmplist();
  Future<void> sendProdQrInfo(
    String itemId,
    String batchId,
    String qty,
    String goodQty,
    String badQty,
    String machine,
  );
  Future<List<TempBatchData>> getTempBatchData();
  Future<void> transferBatch(
      {required String batchId,
      required String itemId,
      required String rackId,
      required String rqty,
      required String split});
  Future<List<TransferBatchData>> getTransferBatchData();
  Future<List<Lov>> getLov();
  Future<void> rackTransfer(
    int transactId,
  );
  Future<List<JobHistory>> getJobHistory();
}
