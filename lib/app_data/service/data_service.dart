import 'package:pran_rfl_erp/app_data/entities/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/entities/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_qr_print_response.dart';

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
  Future<void> transferBatch({
    required String pTrnid,
    required String userid,
    required String rackId,
    required String rqty,
    required String split,
  });
  Future<List<TransferBatchData>> getTransferBatchData(
      {required String userId});
  Future<List<UserMachine>> getUserMachine({required String userId});
  Future<void> rackTransfer({
    required int transactId,
    required String userId,
  });
  Future<List<JobHistory>> getJobHistory();
  Future<void> tranferDelete({
    required int trnsfid,
    required String userId,
  });
  Future<UserInfo> authenticate(
      {required String userid, required String passw});

  Future<List<UserMenuItem>> getUserMenu({
    required String userid,
  });
  Future<List<UserOrg>> getUserOrg({
    required String userid,
  });
  Future<UserBasicDataResponse> getUserBasicData({
    required String userid,
    required String orgid,
  });

  Future<void> interOrgTransfer({
    required String userid,
    required String trackid,
    required String itemid,
    required String rqty,
    required String batchid,
  });

  Future<List<BatchQrData>> userQrSave({
    required String userid,
    required String itemid,
    required String machine,
    required String batchid,
    required String orgid,
    required String goodQty,
    required String badQty,
    required String qty,
  });

  Future<List<UserBatchQrData>> getUserQrPrintData({
    required String userid,
    required String orgid,
  });

  Future<void> updateProdQrPrintStatus({
    required String trnlotno,
  });
}
