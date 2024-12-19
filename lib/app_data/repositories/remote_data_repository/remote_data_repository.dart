import 'package:pran_rfl_erp/app_data/models/Job_order_sum_history_response.dart';
import 'package:pran_rfl_erp/app_data/models/apps_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_close_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_dtl_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/chat_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/employee_response.dart';
import 'package:pran_rfl_erp/app_data/models/generic_response.dart';
import 'package:pran_rfl_erp/app_data/models/iot_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/jo_loc_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_dtl_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/models/lot_trn_response.dart';
import 'package:pran_rfl_erp/app_data/models/machine_assign_response.dart';
import 'package:pran_rfl_erp/app_data/models/machine_create_response.dart';
import 'package:pran_rfl_erp/app_data/models/opm_dash_sm_response.dart';
import 'package:pran_rfl_erp/app_data/models/org_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/re_print_qr_response.dart';
import 'package:pran_rfl_erp/app_data/models/sub_inv_response.dart';
import 'package:pran_rfl_erp/app_data/models/sys_menu_parent_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/system_module_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_create_response.dart';
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
  Future<JobHistoryResponse> getJobHistory({required String userId});
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

  Future<GenericResponse> interOrgTransfer({
    required String userid,
    required String itemlotno,
    required String torackid,
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
  Future<UserCreateResponse> createUser({
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
  Future<GenericResponse> batchClose({
    required String userId,
    required int batchid,
  });
  Future<BatchCompDataResponse> getBatchCompData({
    required String userId,
  });
  Future<BatchComDtlDataResponse> getBatchCompDtlData({
    required String userId,
    required String batchid,
  });
  Future<GenericResponse> batchCompDtlDataLnUpdt({
    required String userId,
    required String mtldtlid,
    required String madeqty,
  });
  Future<GenericResponse> completeBatch({
    required String userId,
    required String batchid,
  });
  Future<GenericResponse> getBatchReleaseData({
    required String userId,
    required String orgId,
    required String batchId,
  });
  Future<RcvInvOrgTrnDataResponse> getRcvInvOrgTrnData({
    required String userId,
  });
  Future<IotTrnDataResponse> getIotTrnData({
    required String userId,
  });
  Future<JobOrderSumHistoryResponse> getJobOrderSumHistory(
      {required String userId});
  Future<OrgsResponse> getOrgs();
  Future<GenericResponse> giveOrgAccess({
    required String newUserId,
    required String userId,
    required String orgId,
  });
  Future<MachineCreateResponse> createMachine({
    required String machinename,
    required String userId,
  });
  Future<MachineAssignResponse> assignMachineToOrg({
    required String machinename,
    required String userId,
    required String orgId,
  });
  Future<SubInvResponse> getSubInv({
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
  Future<RePrintQrResponse> getRePrintData({
    required String pTrno,
  });
  Future<GenericResponse> enableRePrint({
    required String pTrno,
  });
  Future<JobDtlDrillDwResponse> getJobDtlDrillDw({
    required String userid,
    required String jobOrderNo,
  });
  Future<JoLocDrillDwResponse> getJobLocDrillDw({
    required String userid,
    required String jobOrderNo,
    required String itemCode,
  });
  Future<OpmDashSmResponse> getOpmDashboardSM({
    required String userid,
  });
  Future<GenericResponse> askAdd({
    required String userid,
    required String askText,
  });
  Future<ChatListResponse> getMessages({
    required String userid,
  });
  Future<TaskInfoResponse> getTaskInfoList({
    required String userid,
  });
  Future<TaskInfoResponse> getJobTaskList({
    required String userid,
  });
  Future<GenericResponse> saveTaskStatus({
    required String userid,
    required String taskStatus,
    required int taskId,
  });
}
