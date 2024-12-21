import 'package:pran_rfl_erp/app_data/models/Job_order_sum_history_response.dart';
import 'package:pran_rfl_erp/app_data/models/apps_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_close_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_dtl_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/chat_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/employee_response.dart';
import 'package:pran_rfl_erp/app_data/models/iot_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/jo_loc_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_dtl_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_info_response.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/models/lot_trn_response.dart';
import 'package:pran_rfl_erp/app_data/models/machine_assign_response.dart';
import 'package:pran_rfl_erp/app_data/models/machine_create_response.dart';
import 'package:pran_rfl_erp/app_data/models/opm_dash_sm_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/rcv_inv_org_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/re_print_qr_response.dart';
import 'package:pran_rfl_erp/app_data/models/sub_inv_response.dart';
import 'package:pran_rfl_erp/app_data/models/sys_menu_parent_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/system_module_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/app_data/models/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_create_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/remote_data_repository.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';
import 'package:pran_rfl_erp/core/exceptions/api_exceptions.dart';
import '../../core/exceptions/custom_exception.dart';
import '../models/user_menu_item_response.dart';
import '../models/user_info_model.dart';

class DataServiceImpl implements DataService {
  final LocalDataRepository localDataRepository;
  final RemoteDataRepository remoteDataRepository;

  DataServiceImpl({
    required this.localDataRepository,
    required this.remoteDataRepository,
  });

  @override
  Future<List<Employee>> getEmplist() async {
    var response = await remoteDataRepository.getEmplist();
    return response.items;
  }

  @override
  Future<void> sendProdQrInfo(
    String itemId,
    String batchId,
    String qty,
    String goodQty,
    String badQty,
    String machine,
  ) async {
    await remoteDataRepository.sendProdQrInfo(
      itemId,
      batchId,
      qty,
      goodQty,
      badQty,
      machine,
    );
  }

  @override
  Future<List<TempBatchData>> getTempBatchData() async {
    var response = await remoteDataRepository.getTempBatchData();
    return response.items ?? [];
  }

  @override
  Future<void> transferBatch({
    required String pTrnid,
    required String userid,
    required String rackId,
    required String rqty,
    required String split,
  }) async {
    await remoteDataRepository.transferBatch(
      pTrnid: pTrnid,
      userid: userid,
      rackId: rackId,
      rqty: rqty,
      split: split,
    );
  }

  @override
  Future<List<TransferBatchData>> getTransferBatchData(
      {required String userId}) async {
    var response =
        await remoteDataRepository.getTransferBatchData(userId: userId);
    return response.userBatchtrnData ?? [];
  }

  @override
  Future<List<UserMachine>> getUserMachine({required String userId}) async {
    var response = await remoteDataRepository.getUserMachine(userId: userId);
    return response.userMachineData ?? [];
  }

  @override
  Future<void> rackTransfer({
    required int transactId,
    required String userId,
  }) async {
    await remoteDataRepository.rackTransfer(
        transactId: transactId, userId: userId);
  }

  @override
  Future<List<JobHistory>> getJobHistory({required String userId}) async {
    var response = await remoteDataRepository.getJobHistory(userId: userId);
    return response.jobOrderInfo ?? [];
  }

  @override
  Future<void> tranferDelete({
    required int trnsfid,
    required String userId,
  }) async {
    await remoteDataRepository.tranferDelete(trnsfid: trnsfid, userId: userId);
  }

  @override
  Future<UserInfo> authenticate(
      {required String userid, required String passw}) async {
    var response =
        await remoteDataRepository.authenticate(userid: userid, passw: passw);
    if (response.statusCode == 200) {
      return response.userInfo!.first;
    }
    throw ApiDataException(response.errmsg);
  }

  @override
  Future<void> saveUserToLocal({
    required UserInfoModel userInfoModel,
  }) async {
    try {
      await localDataRepository.saveUserToLocal(userInfoModel: userInfoModel);
    } catch (e) {
      throw const CustomException("Failed To Save User Information");
    }
  }

  @override
  Future<List<UserMenuItem>> getUserMenu({
    required String userid,
  }) async {
    var response = await remoteDataRepository.getUserMenu(userid: userid);
    if (response.statusCode == 200) {
      return response.userMenuItems ?? [];
    }
    throw ApiDataException(response.errmsg);
  }

  @override
  Future<UserInfoModel?> getLoggedUser() async {
    var response = await localDataRepository.getLoggedUser();
    return response;
  }

  @override
  Future<void> clearUserFrmLocal() async {
    await localDataRepository.clearUserFrmLocal();
  }

  @override
  Future<List<UserOrg>> getUserOrg({
    required String userid,
  }) async {
    var response = await remoteDataRepository.getUserOrg(userid: userid);
    if (response.statusCode == 200) {
      return response.userOrgs ?? [];
    }
    throw ApiDataException(response.errmsg);
  }

  @override
  Future<UserBasicDataResponse> getUserBasicData({
    required String userid,
    required String orgid,
  }) async {
    var response = await remoteDataRepository.getUserBasicData(
      userid: userid,
      orgid: orgid,
    );
    if (response.statusCode == 200) {
      return response;
    }
    throw ApiDataException(response.errmsg);
  }

  @override
  Future<void> interOrgTransfer({
    required String userid,
    required String itemlotno,
    required String torackid,
    required String trnid,
  }) async {
    var response = await remoteDataRepository.interOrgTransfer(
      userid: userid,
      itemlotno: itemlotno,
      torackid: torackid,
      trnid: trnid,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<BatchQrData>> userQrSave({
    required String userid,
    required String itemid,
    required String machine,
    required String batchid,
    required String orgid,
    required String goodQty,
    required String badQty,
    required String qty,
  }) async {
    var response = await remoteDataRepository.userQrSave(
      userid: userid,
      itemid: itemid,
      machine: machine,
      batchid: batchid,
      orgid: orgid,
      goodQty: goodQty,
      badQty: badQty,
      qty: qty,
    );
    if (response.statusCode == 200) {
      return response.batchQrData ?? [];
    }
    throw ApiDataException(response.errorMessage);
  }

  @override
  Future<List<UserBatchQrData>> getUserQrPrintData({
    required String userid,
    required String orgid,
  }) async {
    var response = await remoteDataRepository.getUserQrPrintData(
      userid: userid,
      orgid: orgid,
    );
    if (response.statusCode == 200) {
      return response.userBatchData ?? [];
    }
    throw const ApiDataException("Unable To Get Data");
  }

  @override
  Future<void> updateProdQrPrintStatus({
    required String trnlotno,
  }) async {
    var response =
        await remoteDataRepository.updateProdQrPrintStatus(trnlotno: trnlotno);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<SysModuleData>> getSystemModule({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getSystemModule(userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.sysModuleData ?? [];
  }

  @override
  Future<List<SysMenuparentData>> getSystemMenuParent({
    required String userId,
    required String moduleName,
  }) async {
    var response = await remoteDataRepository.getSystemMenuParent(
        userId: userId, moduleName: moduleName);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.sysMenuparentData ?? [];
  }

  @override
  Future<void> sysCreateMenu({
    required String userId,
    required String pMenuName,
    required String pMenuType,
    required String pModule,
    required String? pParent,
  }) async {
    var response = await remoteDataRepository.sysCreateMenu(
      userId: userId,
      pMenuName: pMenuName,
      pMenuType: pMenuType,
      pModule: pModule,
      pParent: pParent,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<AppsUserData>> getAppsUser() async {
    var response = await remoteDataRepository.getAppsUser();
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.appsUserData ?? [];
  }

  @override
  Future<List<NewUserInfo>> createUser({
    required String newUserId,
    required String newUserName,
    required String userId,
    required String passw,
    required String appUser,
    required String mobileNo,
    required String desigName,
    required String deptName,
  }) async {
    var response = await remoteDataRepository.createUser(
        newUserId: newUserId,
        newUserName: newUserName,
        userId: userId,
        passw: passw,
        appUser: appUser,
        mobileNo: mobileNo,
        desigName: desigName,
        deptName: deptName);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.newUserInfo ?? [];
  }

  @override
  Future<List<QrUserData>> getQrUsers() async {
    var response = await remoteDataRepository.getQrUsers();
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.userData ?? [];
  }

  @override
  Future<List<QrModuleData>> getQrUserMenu({
    required String newUserId,
    required String creatorId,
  }) async {
    var response = await remoteDataRepository.getQrUserMenu(
      newUserId: newUserId,
      creatorId: creatorId,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.usersMenuData ?? [];
  }

  @override
  Future<List<QrUserChildMenu>> getQrUserChildMenu({
    required String newUserId,
    required String creatorId,
    required String routeName,
  }) async {
    var response = await remoteDataRepository.getQrUserChildMenu(
      newUserId: newUserId,
      creatorId: creatorId,
      routeName: routeName,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.usersChildMenuData ?? [];
  }

  @override
  Future<void> giveUserMenuPermission({
    required String userId,
    required String newUserId,
    required String menuId,
  }) async {
    var response = await remoteDataRepository.giveUserMenuPermission(
      userId: userId,
      newUserId: newUserId,
      menuId: menuId,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<LotTrnData>> getLotTrnData({
    required String userId,
    required String racklocator,
  }) async {
    var response = await remoteDataRepository.getLotTrnData(
        userId: userId, racklocator: racklocator);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.lotTrnData ?? [];
  }

  @override
  Future<List<BatchCloseData>> getBatchCloseData({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getBatchCloseData(userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.batchCloseData ?? [];
  }

  @override
  Future<void> batchClose({
    required String userId,
    required int batchid,
  }) async {
    var response =
        await remoteDataRepository.batchClose(userId: userId, batchid: batchid);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<BatchCompData>> getBatchCompData({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getBatchCompData(userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.batchCompData ?? [];
  }

  @override
  Future<List<SkuDtlData>> getBatchCompDtlData({
    required String userId,
    required String batchid,
  }) async {
    var response = await remoteDataRepository.getBatchCompDtlData(
        userId: userId, batchid: batchid);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.skuDtlData ?? [];
  }

  @override
  Future<void> batchCompDtlDataLnUpdt({
    required String userId,
    required String mtldtlid,
    required String madeqty,
  }) async {
    var response = await remoteDataRepository.batchCompDtlDataLnUpdt(
        userId: userId, mtldtlid: mtldtlid, madeqty: madeqty);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<void> completeBatch({
    required String userId,
    required String batchid,
  }) async {
    var response = await remoteDataRepository.completeBatch(
        userId: userId, batchid: batchid);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<void> getBatchReleaseData({
    required String userId,
    required String orgId,
    required String batchId,
  }) async {
    var response = await remoteDataRepository.getBatchReleaseData(
        userId: userId, orgId: orgId, batchId: batchId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<RcvIotData>> getRcvInvOrgTrnData({
    required String userId,
  }) async {
    var response =
        await remoteDataRepository.getRcvInvOrgTrnData(userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.rcvIotData ?? [];
  }

  @override
  Future<List<IotTrnData>> getIotTrnData({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getIotTrnData(userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.iotTrnData ?? [];
  }

  @override
  Future<List<JobOrderData>> getJobOrderSumHistory(
      {required String userId}) async {
    var response =
        await remoteDataRepository.getJobOrderSumHistory(userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.jobLocatorInfo ?? [];
  }

  @override
  Future<List<UserOrg>> getOrgs() async {
    var response = await remoteDataRepository.getOrgs();
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.orgData ?? [];
  }

  @override
  Future<void> giveOrgAccess({
    required String newUserId,
    required String userId,
    required String orgId,
  }) async {
    var response = await remoteDataRepository.giveOrgAccess(
        newUserId: newUserId, userId: userId, orgId: orgId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<MachineCreateResponse> createMachine({
    required String machinename,
    required String userId,
  }) async {
    var response = await remoteDataRepository.createMachine(
        machinename: machinename, userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response;
  }

  @override
  Future<List<OrgMachineInfo>> assignMachineToOrg({
    required String machinename,
    required String userId,
    required String orgId,
  }) async {
    var response = await remoteDataRepository.assignMachineToOrg(
        machinename: machinename, userId: userId, orgId: orgId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.orgMachineInfo ?? [];
  }

  @override
  Future<List<SubInvData>> getSubInv({
    required String orgId,
  }) async {
    var response = await remoteDataRepository.getSubInv(orgId: orgId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.subinvData ?? [];
  }

  @override
  Future<void> createLocator({
    required String userId,
    required String orgId,
    required String pSubInv,
    required String pRow,
    required String pRack,
    required String pBeen,
    required String pDesc,
  }) async {
    await remoteDataRepository.createLocator(
      userId: userId,
      orgId: orgId,
      pSubInv: pSubInv,
      pRow: pRow,
      pRack: pRack,
      pBeen: pBeen,
      pDesc: pDesc,
    );
  }

  @override
  Future<List<RqrData>> getRePrintData({
    required String pTrno,
  }) async {
    var response = await remoteDataRepository.getRePrintData(pTrno: pTrno);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.rqrData ?? [];
  }

  @override
  Future<void> enableRePrint({
    required String pTrno,
  }) async {
    var response = await remoteDataRepository.enableRePrint(pTrno: pTrno);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<JobDetail>> getJobDtlDrillDw({
    required String userid,
    required String jobOrderNo,
  }) async {
    var response = await remoteDataRepository.getJobDtlDrillDw(
        userid: userid, jobOrderNo: jobOrderNo);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.jobDetails ?? [];
  }

  @override
  Future<List<JobLocatorInfo>> getJobLocDrillDw({
    required String userid,
    required String jobOrderNo,
    required String itemCode,
  }) async {
    var response = await remoteDataRepository.getJobLocDrillDw(
        userid: userid, jobOrderNo: jobOrderNo, itemCode: itemCode);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.jobLocatorInfo ?? [];
  }

  @override
  Future<OpmDashSmResponse> getOpmDashboardSM({
    required String userid,
  }) async {
    var response = await remoteDataRepository.getOpmDashboardSM(userid: userid);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response;
  }

  @override
  Future<void> askAdd({
    required String userid,
    required String askText,
  }) async {
    var response =
        await remoteDataRepository.askAdd(userid: userid, askText: askText);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<GptInfo>> getMessages({
    required String userid,
  }) async {
    var response = await remoteDataRepository.getMessages(
      userid: userid,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.gptInfo ?? [];
  }

  @override
  Future<List<TaskInfo>> getTaskInfoList({
    required String userid,
  }) async {
    var response = await remoteDataRepository.getTaskInfoList(
      userid: userid,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.taskInfo ?? [];
  }

  @override
  Future<List<TaskInfo>> getJobTaskList({
    required String userid,
  }) async {
    var response = await remoteDataRepository.getTaskInfoList(
      userid: userid,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.taskInfo ?? [];
  }

  @override
  Future<void> saveTaskStatus({
    required String userid,
    required String taskStatus,
    required int taskId,
  }) async {
    var response = await remoteDataRepository.saveTaskStatus(
        userid: userid, taskStatus: taskStatus, taskId: taskId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<JobOrderInfo>> getJobOrderInfo({
    required String userId,
    required String itemId,
    required String jobOrderNo,
  }) async {
    var response = await remoteDataRepository.getJobOrderInfo(
        userId: userId, itemId: itemId, jobOrderNo: jobOrderNo);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.jobOrderInfo ?? [];
  }
}
