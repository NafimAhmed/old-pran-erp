import 'package:pran_rfl_erp/app_data/models/Job_order_sum_history_response.dart';
import 'package:pran_rfl_erp/app_data/models/apps_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_close_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_dtl_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_shift_change_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_status_check_response.dart';
import 'package:pran_rfl_erp/app_data/models/buyer_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/chat_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/customer_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/department_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/generic_response.dart';
import 'package:pran_rfl_erp/app_data/models/grn_jo_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/grn_po_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/grn_purchase_req_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/grn_qr_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/iot_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/jo_loc_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_dtl_drill_dw_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_completion_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_info_response.dart';
import 'package:pran_rfl_erp/app_data/models/job_order_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/models/lot_trn_response.dart';
import 'package:pran_rfl_erp/app_data/models/machine_assign_response.dart';
import 'package:pran_rfl_erp/app_data/models/machine_create_response.dart';
import 'package:pran_rfl_erp/app_data/models/mo_req_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/operation_unit_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/opm_dash_sm_response.dart';
import 'package:pran_rfl_erp/app_data/models/parent_task_list.dart';
import 'package:pran_rfl_erp/app_data/models/po_job_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/prod_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/project_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/purchase_requisition_details_response.dart';
import 'package:pran_rfl_erp/app_data/models/purchase_requisition_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/rcv_inv_org_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/re_print_qr_response.dart';
import 'package:pran_rfl_erp/app_data/models/shift_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/smpl_qr_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/sub_inv_response.dart';
import 'package:pran_rfl_erp/app_data/models/sys_menu_parent_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/system_module_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_note_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/top_jo_info_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/prod_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_create_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/remote_data_repository.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';
import 'package:pran_rfl_erp/core/exceptions/api_exceptions.dart';
import 'package:pran_rfl_erp/core/data_class/main_task.dart';
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
  Future<List<JobHistory>> getJobHistory(
      {required String userId, required String jobNo}) async {
    var response =
        await remoteDataRepository.getJobHistory(userId: userId, jobNo: jobNo);
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
  Future<List<UserOrg>> getRcvingOrgs() async {
    var response = await remoteDataRepository.getRcvingOrgs();
    if (response.statusCode == 200) {
      return response.userOrgs ?? [];
    }
    throw ApiDataException(response.errmsg);
  }

  @override
  Future<List<UserBatch>> getProdBatchData({
    required String userid,
    required String orgid,
    required String jobOrderNo,
  }) async {
    var response = await remoteDataRepository.getUserBatchData(
        userid: userid, orgid: orgid, jobOrderNo: jobOrderNo);
    if (response.statusCode == 200) {
      return response.prodBatchData ?? [];
    }
    throw ApiDataException(response.errmsg);
  }

  @override
  Future<ProdBasicDataResponse> getUserBasicData({
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
    required String shiftnm,
    required String shiftFromTime,
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
      shiftnm: shiftnm,
      shiftFromTime: shiftFromTime,
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
      throw ApiDataException(response.errorMessage);
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
      throw ApiDataException(response.errorMessage);
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
      throw ApiDataException(response.errorMessage);
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
  Future<List<JoInfo>> getJoList({
    required String userid,
  }) async {
    var response = await remoteDataRepository.getJoList(
      userid: userid,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.taskJoInfo ?? [];
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
  Future<void> saveTaskStatusToExAuto({
    required String vUser,
    required String vStatus,
    required String vNote,
    required int taskId,
    required String vCustomerPo,
    required String vJobOrderNo,
    required String vFdate,
    required String vTdate,
    required String vAdate,
  }) async {
    var response = await remoteDataRepository.saveTaskStatusToExAuto(
        vUser: vUser,
        vStatus: vStatus,
        vNote: vNote,
        taskId: taskId,
        vCustomerPo: vCustomerPo,
        vJobOrderNo: vJobOrderNo,
        vFdate: vFdate,
        vTdate: vTdate,
        vAdate: vAdate);

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

  @override
  Future<List<ShiftData>> getShiftData() async {
    var response = await remoteDataRepository.getShiftData();
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.shiftData ?? [];
  }

  @override
  Future<BatchShiftChangeResponse> getBatchShiftData({
    required String userId,
    required int orgId,
    required String batchNo,
  }) async {
    var response = await remoteDataRepository.getBatchShiftData(
      userId: userId,
      orgId: orgId,
      batchNo: batchNo,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response;
  }

  @override
  Future<void> batchShiftChange({
    required String userId,
    required String lotNo,
    required String shiftName,
    required String machineName,
    required String manPower,
  }) async {
    var response = await remoteDataRepository.batchShiftChange(
        userId: userId,
        lotNo: lotNo,
        shiftName: shiftName,
        machineName: machineName,
        manPower: manPower);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<JobOrderCompletion>> getJoComplList({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getJoComplList(
      userId: userId,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.jobData ?? [];
  }

  @override
  Future<void> completeJO({
    required String userId,
    required String jobOrderNo,
  }) async {
    var response = await remoteDataRepository.completeJO(
        userId: userId, jobOrderNo: jobOrderNo);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<TopJoInfo>> getTopJOInfoList({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getTopJOInfoList(
      userId: userId,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.topJoInfo ?? [];
  }

  @override
  Future<List<Task>> getTaskList({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getTaskList(
      userId: userId,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.allTaskList ?? [];
  }

  @override
  Future<void> taskAssign({
    required String userId,
    required String assigneeId,
    required String department,
    required String taskId,
  }) async {
    var response = await remoteDataRepository.taskAssign(
        userId: userId,
        assigneeId: assigneeId,
        department: department,
        taskId: taskId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<BatchStatusCheck> getBatchStatus({
    required String userId,
    required String lotNo,
  }) async {
    var response =
        await remoteDataRepository.getBatchStatus(userId: userId, lotNo: lotNo);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.batchStatusCk?.first ?? BatchStatusCheck();
  }

  @override
  Future<void> createProject({
    required String pname,
    required String pDesc,
    required String stDate,
    required String endate,
    required String pManager,
    required String pClientName,
    required String pBudget,
    required String pStatus,
    required String pPriority,
    required String pTtlPerson,
    required String pManHours,
  }) async {
    var response = await remoteDataRepository.createProject(
      pname: pname,
      pDesc: pDesc,
      stDate: stDate,
      endate: endate,
      pManager: pManager,
      pClientName: pClientName,
      pBudget: pBudget,
      pStatus: pStatus,
      pPriority: pPriority,
      pTtlPerson: pTtlPerson,
      pManHours: pManHours,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.errorMessage);
    }
  }

  @override
  Future<List<Department>> getDeptList({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getDeptList(userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.deptList ?? [];
  }

  @override
  Future<List<Buyer>> getBuyerList({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getBuyerList(userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.buyerList ?? [];
  }

  @override
  Future<List<Project>> getProjectList({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getProjectList(userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.projectList ?? [];
  }

  @override
  Future<void> createMainTask({
    required String userId,
    required MainTask mainTask,
  }) async {
    var response = await remoteDataRepository.createMainTask(
        userId: userId, mainTask: mainTask);
    if (response.statusCode != 200) {
      throw ApiDataException(response.errorMessage);
    }
  }

  @override
  Future<List<ParentTask>> getParentTaskList({
    required String userId,
    required int projectId,
  }) async {
    var response = await remoteDataRepository.getParentTaskList(
      userId: userId,
      projectId: projectId,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.parentTaskList ?? [];
  }

  @override
  Future<List<PoJob>> getPoJobList({
    required String userId,
    required String jobpono,
  }) async {
    var response = await remoteDataRepository.getPoJobList(
      userId: userId,
      jobpono: jobpono,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.poJobList ?? [];
  }

  @override
  Future<void> addTaskNote({
    required String userId,
    required int taskId,
    required String tasknote,
  }) async {
    var response = await remoteDataRepository.addTaskNote(
        userId: userId, taskId: taskId, tasknote: tasknote);
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
  }

  @override
  Future<List<TaskNote>> getTaskNoteList({
    required String userId,
    required int taskId,
  }) async {
    var response = await remoteDataRepository.getTaskNoteList(
      userId: userId,
      taskId: taskId,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.message);
    }
    return response.taskNoteList ?? [];
  }

  @override
  Future<void> locatorTranfer({
    required String userid,
    required String torackid,
    required String trnid,
  }) async {
    var response = await remoteDataRepository.locatorTranfer(
      userid: userid,
      torackid: torackid,
      trnid: trnid,
    );
    if (response.statusCode != 200) {
      throw ApiDataException(response.errorMessage);
    }
  }

  @override
  Future<void> userPassChange({
    required String userid,
    required String oldPass,
    required String newPass,
  }) async {
    var response = await remoteDataRepository.userPassChange(
        userid: userid, oldPass: oldPass, newPass: newPass);
    if (response.statusCode != 200) {
      throw ApiDataException(response.errorMessage);
    }
  }

  @override
  Future<List<PurchaseRequisition>> getPurchaseRequisitionList({
    required String userId,
  }) async {
    var response =
        await remoteDataRepository.getPurchaseRequisitionList(userId: userId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.errmsg);
    }
    return response.purchaseRequisition ?? [];
  }

  @override
  Future<List<PurchaseRequisitionDetail>> getPurchaseRequisitionDetails({
    required int headerId,
  }) async {
    var response = await remoteDataRepository.getPurchaseRequisitionDetails(
        headerId: headerId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.errmsg);
    }
    return response.purchaseRequisitionDetails ?? [];
  }

  @override
  Future<GenericResponse> updatePurReqDtl({
    required int headerId,
    required int itemId,
    required int qty,
  }) async {
    var response = await remoteDataRepository.updatePurReqDtl(
        headerId: headerId, itemId: itemId, qty: qty);
    if (response.statusCode != 200) {
      throw ApiDataException(response.errorMessage);
    }
    return response;
  }

  @override
  Future<GenericResponse> approvePurReq({
    required String reqNo,
    required String userId,
    required int orgId,
  }) async {
    var response = await remoteDataRepository.approvePurReq(
        reqNo: reqNo, userId: userId, orgId: orgId);
    if (response.statusCode != 200) {
      throw ApiDataException(response.errorMessage);
    }
    return response;
  }

  @override
  Future<List<OperationUnit>> getOperationUnit() async {
    var response = await remoteDataRepository.getOperationUnit();
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
    return response.operationUnitList ?? [];
  }

  @override
  Future<List<GrnPurchaseReqNumber>> getGrnPurchaseReqList(
      {required int ordId}) async {
    var response =
        await remoteDataRepository.getGrnPurchaseReqList(ordId: ordId);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
    return response.purchaseReqList ?? [];
  }

  @override
  Future<List<GrnJO>> getGrnJOList({required String reqNo}) async {
    var response = await remoteDataRepository.getGrnJOList(reqNo: reqNo);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
    return response.grnJoList ?? [];
  }

  @override
  Future<List<GrnPO>> getGrnPOList({required String jobOrderNo}) async {
    var response =
        await remoteDataRepository.getGrnPOList(jobOrderNo: jobOrderNo);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
    return response.poList ?? [];
  }

  @override
  Future<List<GrnQr>> getGrnQrList({required String userId}) async {
    var response = await remoteDataRepository.getGrnQrList(userId: userId);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
    return response.grnQrList ?? [];
  }

  @override
  Future<void> getGrnQrSave({
    required String userId,
    required int orgId,
    required int itemId,
    required num goodQty,
    required num qty,
    required num badQty,
    required String jobOrderNo,
    required String prId,
  }) async {
    var response = await remoteDataRepository.getGrnQrSave(
      userId: userId,
      orgId: orgId,
      itemId: itemId,
      goodQty: goodQty,
      qty: qty,
      badQty: badQty,
      jobOrderNo: jobOrderNo,
      prId: prId,
    );
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
  }

  @override
  Future<List<UserOrg>> getGrnOrgList({required int ouId}) async {
    var response = await remoteDataRepository.getGrnOrgList(ouId: ouId);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
    return response.grnOrg ?? [];
  }

  @override
  Future<List<MOReqTask>> getMOReqList({required String userId}) async {
    var response = await remoteDataRepository.getMOReqList(userId: userId);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
    return response.moReqTaskList ?? [];
  }

  @override
  Future<void> moReqSave({
    required String taskStatus,
    required int taskId,
  }) async {
    var response = await remoteDataRepository.moReqSave(
        taskStatus: taskStatus, taskId: taskId);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
  }

  @override
  Future<List<Customer>> getCustomerList({
    required String searchV,
  }) async {
    var response = await remoteDataRepository.getCustomerList(searchV: searchV);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
    return response.customerList ?? [];
  }

  @override
  Future<String> smplColHdrSave({
    required int rcvOrg,
    required String customerCode,
    required String customerName,
    required String rcvDate,
    required String smplSender,
    required String note,
    required String assignee,
    required String userId,
  }) async {
    var response = await remoteDataRepository.smplColHdrSave(
      rcvOrg: rcvOrg,
      customerCode: customerCode,
      customerName: customerName,
      rcvDate: rcvDate,
      smplSender: smplSender,
      note: note,
      assignee: assignee,
      userId: userId,
    );
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
    return response.info ?? "";
  }

  @override
  Future<void> smplColHdrDtlSave({
    required int headerId,
    required String itemCode,
    required String itemName,
    required num qty,
    required String unit,
  }) async {
    var response = await remoteDataRepository.smplColHdrDtlSave(
        headerId: headerId,
        itemCode: itemCode,
        itemName: itemName,
        qty: qty,
        unit: unit);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
  }

  @override
  Future<List<SampleColQr>> getSmplColQrList({
    required String userId,
  }) async {
    var response = await remoteDataRepository.getSmplColQrList(userId: userId);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
    return response.sampleColQr ?? [];
  }

  @override
  Future<void> updateSmplColQrList({
    required int id,
  }) async {
    var response = await remoteDataRepository.updateSmplColQrList(id: id);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
  }

  @override
  Future<void> updateGrnQrList({
    required String trnId,
  }) async {
    var response = await remoteDataRepository.updateGrnQrList(trnId: trnId);
    if (response.statusCode != 200) {
      throw const ApiDataException();
    }
  }
}
