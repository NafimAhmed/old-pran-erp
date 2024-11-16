import 'package:pran_rfl_erp/app_data/models/apps_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_close_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/employee_response.dart';
import 'package:pran_rfl_erp/app_data/models/generic_response.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/models/lot_trn_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/sys_menu_parent_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/system_module_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_machine_response.dart';
import 'package:pran_rfl_erp/app_data/models/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';

import '../../models/rcv_inv_org_trn_data_response.dart';
import '../../models/user_menu_item_response.dart';

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
  Future<void> transferBatch({
    required String pTrnid,
    required String userid,
    required String rackId,
    required String rqty,
    required String split,
  });
  Future<TransferBatchDataResponse> getTransferBatchData(
      {required String userId});
  Future<UserMachineResponse> getUserMachine({required String userId});

  Future<void> rackTransfer({
    required int transactId,
    required String userId,
  });
  Future<JobHistoryResponse> getJobHistory();
  Future<void> tranferDelete({
    required int trnsfid,
    required String userId,
  });
  Future<AuthenticationResponse> authenticate(
      {required String userid, required String passw});
  Future<UserMenuItemResponse> getUserMenu({
    required String userid,
  });
  Future<UserOrgsResponse> getUserOrg({
    required String userid,
  });
  Future<UserBasicDataResponse> getUserBasicData({
    required String userid,
    required String orgid,
  });

  Future<void> interOrgTransfer({
    required String userid,
    required String itemlotno,
    required String torackid,
    required String tqty,
    required String trnid,
  });
  Future<BatchQrDataResponse> userQrSave({
    required String userid,
    required String itemid,
    required String machine,
    required String batchid,
    required String orgid,
    required String goodQty,
    required String badQty,
    required String qty,
  });
  Future<UserQrPrintResponse> getUserQrPrintData({
    required String userid,
    required String orgid,
  });
  Future<GenericResponse> updateProdQrPrintStatus({
    required String trnlotno,
  });

  Future<SystemModuleResponse> getSystemModule({
    required String userId,
  });
  Future<SystemMenuParentDataResponse> getSystemMenuParent({
    required String userId,
    required String moduleName,
  });
  Future<GenericResponse> sysCreateMenu({
    required String userId,
    required String pMenuName,
    required String pMenuType,
    required String pModule,
    required String? pParent,
  });
  Future<AppsUserResponse> getAppsUser();
  Future<GenericResponse> createUser({
    required String newUserId,
    required String newUserName,
    required String userId,
    required String passw,
    required String appUser,
    required String mobileNo,
    required String desigName,
    required String deptName,
  });
  Future<QrUserResponse> getQrUsers();
  Future<QrUserMenuResponse> getQrUserMenu(
      {required String newUserId, required String creatorId});
  Future<QrUserMenuResponse> getQrUserChildMenu({
    required String newUserId,
    required String creatorId,
    required String routeName,
  });
  Future<GenericResponse> giveUserMenuPermission({
    required String userId,
    required String newUserId,
    required String menuId,
  });

  Future<LotTrnResponse> getLotTrnData({
    required String userId,
    required String racklocator,
  });
  Future<BatchCloseDataResponse> getBatchCloseData({
    required String userId,
  });
  Future<BatchCompDataResponse> getBatchCompData({
    required String userId,
  });
  Future<RcvInvOrgTrnDataResponse> getRcvInvOrgTrnData({
    required String userId,
  });
}
