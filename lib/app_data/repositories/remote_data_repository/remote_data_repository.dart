import 'package:pran_rfl_erp/app_data/entities/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/entities/lov_response.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';

import '../../entities/user_menu_item_response.dart';

abstract class RemoteDataRepository {
  Future<EmployeResponse> getEmplist();
  Future<void> sendProdQrInfo(
    String itemId,
    String batchId,
    String qty,
    String goodQty,
    String badQty,
    String machine,
  );
  Future<TempBatchDataResponse> getTempBatchData();
  Future<void> transferBatch(
      {required String batchId,
      required String itemId,
      required String rackId,
      required String rqty,
      required String split});
  Future<TransferBatchDataResponse> getTransferBatchData();
  Future<LovResponse> getLov();

  Future<void> rackTransfer(
    int transactId,
  );
  Future<JobHistoryResponse> getJobHistory();
  Future<void> tranferDelete({required int trnsfid});
  Future<AuthenticationResponse> authenticate(
      {required String userid, required String passw});
  Future<UserMenuItemResponse> getUserMenu(
      {required String userid,});
}
