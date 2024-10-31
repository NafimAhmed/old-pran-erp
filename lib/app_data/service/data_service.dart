import 'package:pran_rfl_erp/app_data/entities/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/entities/machine_list_response.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';

import '../entities/user_menu_item_response.dart';
import '../models/user_info_model.dart';

abstract class DataService {
  Future<void> saveUserToLocal({
    required UserInfoModel userInfoModel,
  });
  Future<void> clearUserFrmLocal();
  Future<UserInfoModel?> getLoggedUser();

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
  Future<List<Machine>> getLov();
  Future<void> rackTransfer(
    int transactId,
  );
  Future<List<JobHistory>> getJobHistory();
  Future<void> tranferDelete({required int trnsfid});
  Future<UserInfo> authenticate(
      {required String userid, required String passw});

  Future<List<UserMenuItem>> getUserMenu({
    required String userid,
  });
}
