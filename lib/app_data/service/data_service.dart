import 'package:pran_rfl_erp/app_data/models/Job_order_sum_history_response.dart';
import 'package:pran_rfl_erp/app_data/models/apps_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_close_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/employee_response.dart';
import 'package:pran_rfl_erp/app_data/models/iot_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_dtl_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/models/lot_trn_response.dart';
import 'package:pran_rfl_erp/app_data/models/machine_assign_response.dart';
import 'package:pran_rfl_erp/app_data/models/machine_create_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/rcv_inv_org_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/re_print_qr_response.dart';
import 'package:pran_rfl_erp/app_data/models/sub_inv_response.dart';
import 'package:pran_rfl_erp/app_data/models/sys_menu_parent_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/system_module_response.dart';
import 'package:pran_rfl_erp/app_data/models/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_create_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';

import '../models/user_menu_item_response.dart';
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
  Future<List<JobHistory>> getJobHistory({required String userId});
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
    required String itemlotno,
    required String torackid,
    required String tqty,
    required String trnid,
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
  Future<List<SysModuleData>> getSystemModule({
    required String userId,
  });
  Future<List<SysMenuparentData>> getSystemMenuParent({
    required String userId,
    required String moduleName,
  });

  Future<void> sysCreateMenu({
    required String userId,
    required String pMenuName,
    required String pMenuType,
    required String pModule,
    required String? pParent,
  });

  Future<List<AppsUserData>> getAppsUser();
  Future<List<NewUserInfo>> createUser({
    required String newUserId,
    required String newUserName,
    required String userId,
    required String passw,
    required String appUser,
    required String mobileNo,
    required String desigName,
    required String deptName,
  });
  Future<List<QrUserData>> getQrUsers();
  Future<List<QrModuleData>> getQrUserMenu({
    required String newUserId,
    required String creatorId,
  });
  Future<List<QrUserChildMenu>> getQrUserChildMenu({
    required String newUserId,
    required String creatorId,
    required String routeName,
  });
  Future<void> giveUserMenuPermission({
    required String userId,
    required String newUserId,
    required String menuId,
  });
  Future<List<LotTrnData>> getLotTrnData({
    required String userId,
    required String racklocator,
  });
  Future<List<BatchCloseData>> getBatchCloseData({
    required String userId,
  });
  Future<List<BatchCompData>> getBatchCompData({
    required String userId,
  });
  Future<List<RcvIotData>> getRcvInvOrgTrnData({
    required String userId,
  });
  Future<List<IotTrnData>> getIotTrnData({
    required String userId,
  });
  Future<List<JobOrderData>> getJobOrderSumHistory({required String userId});
  Future<List<UserOrg>> getOrgs();
  Future<void> giveOrgAccess({
    required String newUserId,
    required String userId,
    required String orgId,
  });
  Future<MachineCreateResponse> createMachine({
    required String machinename,
    required String userId,
  });

  Future<List<OrgMachineInfo>> assignMachineToOrg({
    required String machinename,
    required String userId,
    required String orgId,
  });
  Future<List<SubInvData>> getSubInv({
    required String orgId,
  });
  Future<void> createLocator({
    required String userId,
    required String orgId,
    required String pSubInv,
    required String pRow,
    required String pRack,
    required String pBeen,
    required String pDesc,
  });
  Future<List<RqrData>> getRePrintData({
    required String pTrno,
  });
  Future<void> enableRePrint({
    required String pTrno,
  });

  Future<List<JobDetail>> getJobDtlDrillDw({
    required String userid,
    required String jobOrderNo,
  });
}
