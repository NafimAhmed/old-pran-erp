import 'package:pran_rfl_erp/app_data/api_service/api_end_points.dart';
import 'package:pran_rfl_erp/app_data/api_service/http_service.dart';
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
import 'package:pran_rfl_erp/app_data/models/org_response.dart';
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
import 'package:pran_rfl_erp/app_data/models/user_machine_response.dart';
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
  final HttpService httpService;
  DataServiceImpl({
    required this.localDataRepository,
    required this.remoteDataRepository,
    required this.httpService,
  });
  @override
  Future<void> sendProdQrInfo(String itemId, String batchId, String qty,
      String goodQty, String badQty, String machine) async {
    await httpService
        .postCall(endPoint: ApiEndPoints.sendProdQrInfo, parameters: {
      "itemid": itemId,
      "BATCHID": batchId,
      "QTY": qty,
      "GOOD_QTY": goodQty,
      "BAD_QTY": badQty,
      "machine": machine
    });
  }

  @override
  Future<List<TempBatchData>> getTempBatchData() async {
    var response = await httpService
        .getCall(endPoint: ApiEndPoints.getTempBatchData, parameters: {});
    var decodedRes = TempBatchDataResponse.fromJson(response);
    return decodedRes.items ?? [];
  }

  @override
  Future<void> transferBatch({
    required String pTrnid,
    required String userid,
    required String rackId,
    required String rqty,
    required String split,
  }) async {
    await httpService
        .postCall(endPoint: ApiEndPoints.transferBatch, parameters: {
      "rqty": rqty,
      "userid": userid,
      "p_trnid": pTrnid,
      "rackid": rackId,
      "split_flag": split
    });
  }

  @override
  Future<List<TransferBatchData>> getTransferBatchData(
      {required String userId}) async {
    var response = await httpService.getCall(
        endPoint: ApiEndPoints.transferBatch, parameters: {"userid": userId});
    var decodedRes = TransferBatchDataResponse.fromJson(response);
    return decodedRes.userBatchtrnData ?? [];
  }

  @override
  Future<List<UserMachine>> getUserMachine({required String userId}) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getUserMachine, parameters: {"userid": userId});
    var decodedRes = UserMachineResponse.fromJson(response);
    return decodedRes.userMachineData ?? [];
  }

  @override
  Future<void> rackTransfer({
    required int transactId,
    required String userId,
  }) async {
    await httpService.postCall(
        endPoint: ApiEndPoints.rackTransfer,
        parameters: {"trnid": "$transactId", "userid": userId, "split": "0"});
  }

  @override
  Future<List<JobHistory>> getJobHistory(
      {required String userId, required String jobNo}) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getJobHistory,
        parameters: {"userid": userId, "jobno": jobNo});
    var decodedRes = JobHistoryResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.jobOrderInfo ?? [];
  }

  @override
  Future<void> tranferDelete({
    required int trnsfid,
    required String userId,
  }) async {
    await httpService.postCall(
        endPoint: ApiEndPoints.tranferDelete,
        parameters: {"userid": userId, "trnsfid": trnsfid});
  }

  @override
  Future<UserInfo> authenticate(
      {required String userid, required String passw}) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.login,
        parameters: {"userid": userid, "passw": passw});
    var authResponse = AuthenticationResponse.fromJson(response);

    if (authResponse.statusCode == 200) {
      return authResponse.userInfo!.first;
    }
    throw ApiDataException(authResponse.errmsg);
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
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getUserMenu, parameters: {"userid": userid});
    var decodedRes = UserMenuItemResponse.fromJson(response);

    if (decodedRes.statusCode == 200) {
      return decodedRes.userMenuItems ?? [];
    }
    throw ApiDataException(decodedRes.errmsg);
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
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getUserOrg, parameters: {"userid": userid});
    var decoderRes = UserOrgsResponse.fromJson(response);
    if (decoderRes.statusCode == 200) {
      return decoderRes.userOrgs ?? [];
    }
    throw ApiDataException(decoderRes.errmsg);
  }

  @override
  Future<List<UserOrg>> getRcvingOrgs() async {
    var response = await httpService
        .getCall(endPoint: ApiEndPoints.getRcvingOrgs, parameters: {});
    var decodedRes = UserOrgsResponse.fromJson(response);
    if (decodedRes.statusCode == 200) {
      return decodedRes.userOrgs ?? [];
    }
    throw ApiDataException(decodedRes.errmsg);
  }

  @override
  Future<List<UserBatch>> getProdBatchData({
    required String userid,
    required String orgid,
    required String jobOrderNo,
  }) async {
    var response = await httpService.getCall(
        endPoint: ApiEndPoints.getUserBatchData,
        parameters: {
          "userid": userid,
          "orgid": orgid,
          "job_order_no": jobOrderNo
        });
    var decoderRes = ProdBatchDataResponse.fromJson(response);
    if (decoderRes.statusCode == 200) {
      return decoderRes.prodBatchData ?? [];
    }
    throw ApiDataException(decoderRes.errmsg);
  }

  @override
  Future<ProdBasicDataResponse> getUserBasicData({
    required String userid,
    required String orgid,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getUserBasicData,
        parameters: {"userid": userid, "orgid": orgid});
    var decoderRes = ProdBasicDataResponse.fromJson(response);
    if (decoderRes.statusCode == 200) {
      return decoderRes;
    }
    throw ApiDataException(decoderRes.errmsg);
  }

  @override
  Future<void> interOrgTransfer({
    required String userid,
    required String itemlotno,
    required String torackid,
    required String trnid,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.interOrgTransfer,
        parameters: {
          "userid": userid,
          "itemlotno": itemlotno,
          "tlockid": torackid,
          "trnid": trnid
        });
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
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
    var response = await httpService
        .postCall(endPoint: ApiEndPoints.userQrSave, parameters: {
      "userid": userid,
      "machine": machine,
      "orgid": orgid,
      "batchid": batchid,
      "itemid": itemid,
      "goodqty": goodQty,
      "badqty": badQty,
      "qty": qty,
      "shiftnm": shiftnm,
      "shiftFromTime": shiftFromTime
    });
    var decoderRes = BatchQrDataResponse.fromJson(response);
    if (decoderRes.statusCode == 200) {
      return decoderRes.batchQrData ?? [];
    }
    throw ApiDataException(decoderRes.errorMessage);
  }

  @override
  Future<List<UserBatchQrData>> getUserQrPrintData({
    required String userid,
    required String orgid,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getUserQrPrintData,
        parameters: {"userid": userid, "orgid": orgid});
    var decodedRes = UserQrPrintResponse.fromJson(response);
    if (decodedRes.statusCode == 200) {
      return decodedRes.userBatchData ?? [];
    }
    throw const ApiDataException("Unable To Get Data");
  }

  @override
  Future<void> updateProdQrPrintStatus({
    required String trnlotno,
  }) async {
    var response = await httpService.putCall(
        endPoint: ApiEndPoints.updateProdQrPrintStatus,
        parameters: {"trnlotno": trnlotno});
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
  }

  @override
  Future<List<SysModuleData>> getSystemModule({
    required String userId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getSystemModule, parameters: {"userid": userId});
    var decodedRes = SystemModuleResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.sysModuleData ?? [];
  }

  @override
  Future<List<SysMenuparentData>> getSystemMenuParent({
    required String userId,
    required String moduleName,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getSystemMenuParent,
        parameters: {"userid": userId, "modulename": moduleName});
    var decodedRes = SystemMenuParentDataResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.sysMenuparentData ?? [];
  }

  @override
  Future<void> sysCreateMenu({
    required String userId,
    required String pMenuName,
    required String pMenuType,
    required String pModule,
    required String? pParent,
  }) async {
    var response = await httpService
        .postCall(endPoint: ApiEndPoints.sysCreateMenu, parameters: {
      "userid": userId,
      "P_menu_name": pMenuName,
      "P_menu_type": pMenuType,
      "P_module": pModule,
      "P_parent": pParent
    });
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
  }

  @override
  Future<List<AppsUserData>> getAppsUser() async {
    var response = await httpService
        .postCall(endPoint: ApiEndPoints.getAppsUser, parameters: {});
    var decodedRes = AppsUserResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.appsUserData ?? [];
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
    var response = await httpService
        .postCall(endPoint: ApiEndPoints.createUser, parameters: {
      "newuserid": newUserId,
      "newusername": newUserName,
      "userid": userId,
      "passw": passw,
      "appuser": appUser,
      "mobileno": mobileNo,
      "designame": "null",
      "deptname": "null"
    });
    var decodedRes = UserCreateResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.errorMessage);
    }
    return decodedRes.newUserInfo ?? [];
  }

  @override
  Future<List<QrUserData>> getQrUsers() async {
    var response = await httpService
        .postCall(endPoint: ApiEndPoints.getQrUsers, parameters: {});
    var decodedRes = QrUserResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.userData ?? [];
  }

  @override
  Future<List<QrModuleData>> getQrUserMenu({
    required String newUserId,
    required String creatorId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getQrUserMenu,
        parameters: {"newuserid": newUserId, "creatorid": creatorId});
    var decoderRes = QrUserMenuResponse.fromJson(response);
    if (decoderRes.statusCode != 200) {
      throw ApiDataException(decoderRes.message);
    }
    return decoderRes.usersMenuData ?? [];
  }

  @override
  Future<List<QrUserChildMenu>> getQrUserChildMenu({
    required String newUserId,
    required String creatorId,
    required String routeName,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getQrUserChildMenu,
        parameters: {
          "newuserid": newUserId,
          "creatorid": creatorId,
          "routename": routeName
        });
    var decodedRes = QrUserMenuResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.usersChildMenuData ?? [];
  }

  @override
  Future<void> giveUserMenuPermission({
    required String userId,
    required String newUserId,
    required String menuId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.giveUserMenuPermission,
        parameters: {
          "userid": userId,
          "newuserid": newUserId,
          "menu_id": menuId
        });
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.errorMessage);
    }
  }

  @override
  Future<List<LotTrnData>> getLotTrnData({
    required String userId,
    required String racklocator,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getLotTrnData,
        parameters: {"userid": userId, "racklocator": racklocator});
    var decodedRes = LotTrnResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.lotTrnData ?? [];
  }

  @override
  Future<List<BatchCloseData>> getBatchCloseData({
    required String userId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getBatchCloseData,
        parameters: {"userid": userId});
    var decodedRes = BatchCloseDataResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.batchCloseData ?? [];
  }

  @override
  Future<void> batchClose({
    required String userId,
    required int batchid,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.batchClose,
        parameters: {"userid": userId, "batchid": batchid});
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
  }

  @override
  Future<List<BatchCompData>> getBatchCompData({
    required String userId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getBatchCloseData,
        parameters: {"userid": userId});
    var decodedRes = BatchCompDataResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.batchCompData ?? [];
  }

  @override
  Future<List<SkuDtlData>> getBatchCompDtlData({
    required String userId,
    required String batchid,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getBatchCompDtlData,
        parameters: {"userid": userId, "batchid": batchid});
    var decodedRes = BatchComDtlDataResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.skuDtlData ?? [];
  }

  @override
  Future<void> batchCompDtlDataLnUpdt({
    required String userId,
    required String mtldtlid,
    required String madeqty,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.batchCompDtlDataLnUpdt,
        parameters: {
          "userid": userId,
          "mtldtlid": mtldtlid,
          "madeqty": madeqty
        });
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
  }

  @override
  Future<void> completeBatch({
    required String userId,
    required String batchid,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.completeBatch,
        parameters: {"userid": userId, "batchid": batchid});
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
  }

  @override
  Future<void> getBatchReleaseData({
    required String userId,
    required String orgId,
    required String batchId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getBatchReleaseData,
        parameters: {"userid": userId, "orgid": orgId, "batchid": batchId});
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
  }

  @override
  Future<List<RcvIotData>> getRcvInvOrgTrnData({
    required String userId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getRcvInvOrgTrnData,
        parameters: {"userid": userId});
    var decodedRes = RcvInvOrgTrnDataResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.rcvIotData ?? [];
  }

  @override
  Future<List<IotTrnData>> getIotTrnData({
    required String userId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getIotTrnData, parameters: {"userid": userId});

    var decodedRes = IotTrnDataResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.iotTrnData ?? [];
  }

  @override
  Future<List<JobOrderData>> getJobOrderSumHistory(
      {required String userId}) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getJobOrderSumHistory,
        parameters: {"userid": userId});
    var decodedRes = JobOrderSumHistoryResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.jobLocatorInfo ?? [];
  }

  @override
  Future<List<UserOrg>> getOrgs() async {
    var response = await httpService
        .postCall(endPoint: ApiEndPoints.getOrgs, parameters: {});
    var decodedRes = OrgsResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.orgData ?? [];
  }

  @override
  Future<void> giveOrgAccess({
    required String newUserId,
    required String userId,
    required String orgId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.giveOrgAccess,
        parameters: {"newuserid": newUserId, "userid": userId, "orgid": orgId});
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.errorMessage);
    }
  }

  @override
  Future<MachineCreateResponse> createMachine({
    required String machinename,
    required String userId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.createMachine,
        parameters: {"machinename": machinename, "userid": userId});
    var decodedRes = MachineCreateResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes;
  }

  @override
  Future<List<OrgMachineInfo>> assignMachineToOrg({
    required String machinename,
    required String userId,
    required String orgId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.assignMachineToOrg,
        parameters: {
          "userid": userId,
          "orgid": orgId,
          "machinename": machinename
        });
    var decodedRes = MachineAssignResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.orgMachineInfo ?? [];
  }

  @override
  Future<List<SubInvData>> getSubInv({
    required String orgId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getSubInv, parameters: {"orgid": orgId});
    var decodedRes = SubInvResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.subinvData ?? [];
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
    await httpService
        .postCall(endPoint: ApiEndPoints.createLocator, parameters: {
      "userid": userId,
      "orgid": orgId,
      "p_subinv": pSubInv,
      "prow": pRow,
      "prack": pRack,
      "pbeen": pBeen,
      "pdesc": pDesc
    });
  }

  @override
  Future<List<RqrData>> getRePrintData({
    required String pTrno,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getRePrintData, parameters: {"ptrno": pTrno});
    var decodedRes = RePrintQrResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.rqrData ?? [];
  }

  @override
  Future<void> enableRePrint({
    required String pTrno,
  }) async {
    var response = await httpService.putCall(
        endPoint: ApiEndPoints.getRePrintData, parameters: {"ptrno": pTrno});
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
  }

  @override
  Future<List<JobDetail>> getJobDtlDrillDw({
    required String userid,
    required String jobOrderNo,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getJobDtlDrillDw,
        parameters: {"userid": userid, "joborderno": jobOrderNo});
    var decodedRes = JobDtlDrillDwResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.jobDetails ?? [];
  }

  @override
  Future<List<JobLocatorInfo>> getJobLocDrillDw({
    required String userid,
    required String jobOrderNo,
    required String itemCode,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getJobLocDrillDw,
        parameters: {
          "userid": userid,
          "joborderno": jobOrderNo,
          "itemcode": itemCode
        });
    var decodedRes = JoLocDrillDwResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.jobLocatorInfo ?? [];
  }

  @override
  Future<OpmDashSmResponse> getOpmDashboardSM({
    required String userid,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getOpmDashboardSM,
        parameters: {"userid": userid});
    var decoderRes = OpmDashSmResponse.fromJson(response);
    if (decoderRes.statusCode != 200) {
      throw ApiDataException(decoderRes.message);
    }
    return decoderRes;
  }

  @override
  Future<void> askAdd({
    required String userid,
    required String askText,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.askAdd,
        parameters: {"userid": userid, "asktext": askText});
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
  }

  @override
  Future<List<GptInfo>> getMessages({
    required String userid,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getMessages, parameters: {"userid": userid});
    var decodedRes = ChatListResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.gptInfo ?? [];
  }

  @override
  Future<List<TaskInfo>> getTaskInfoList({
    required String userid,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getTaskInfoList, parameters: {"userid": userid});
    var decodedRes = TaskInfoResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.taskInfo ?? [];
  }

  @override
  Future<List<JoInfo>> getJoList({
    required String userid,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getJoList, parameters: {"userid": userid});
    var decodedRes = JobOrderListResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.taskJoInfo ?? [];
  }

  @override
  Future<void> saveTaskStatus({
    required String userid,
    required String taskStatus,
    required int taskId,
  }) async {
    var response = await httpService.putCall(
        endPoint: ApiEndPoints.saveTaskStatus,
        parameters: {
          "userid": userid,
          "taskstatus": taskStatus,
          "tskid": taskId
        });
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
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
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getJobOrderInfo,
        parameters: {"jobno": jobOrderNo, "itemid": itemId, "userid": userId});

    var decodedRes = JobOrderInfoResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.jobOrderInfo ?? [];
  }

  @override
  Future<List<ShiftData>> getShiftData() async {
    var response = await httpService
        .postCall(endPoint: ApiEndPoints.getShiftData, parameters: {});
    var decodedRes = ShiftDataResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.shiftData ?? [];
  }

  @override
  Future<BatchShiftChangeResponse> getBatchShiftData({
    required String userId,
    required int orgId,
    required String batchNo,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getBatchShiftData,
        parameters: {"userid": userId, "orgid": orgId, "batchno": batchNo});
    var decodedRes = BatchShiftChangeResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes;
  }

  @override
  Future<void> batchShiftChange({
    required String userId,
    required String lotNo,
    required String shiftName,
    required String machineName,
    required String manPower,
  }) async {
    var response = await httpService
        .putCall(endPoint: ApiEndPoints.batchShiftChange, parameters: {
      "lotno": lotNo,
      "userid": userId,
      "shiftnm": shiftName,
      "mcnname": machineName,
      "manpw": manPower
    });
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
  }

  @override
  Future<List<JobOrderCompletion>> getJoComplList({
    required String userId,
  }) async {
    var response = await httpService.postCall(
        endPoint: ApiEndPoints.getJoComplList, parameters: {"userid": userId});
    var decodedRes = JobOrderCompletionListResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
    }
    return decodedRes.jobData ?? [];
  }

  @override
  Future<void> completeJO({
    required String userId,
    required String jobOrderNo,
  }) async {
    var response = await httpService.putCall(
        endPoint: ApiEndPoints.completeJO,
        parameters: {"userid": userId, "joborderno": jobOrderNo});
    var decodedRes = GenericResponse.fromJson(response);
    if (decodedRes.statusCode != 200) {
      throw ApiDataException(decodedRes.message);
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
