import 'package:pran_rfl_erp/app_data/entities/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/entities/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/entities/sys_menu_parent_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/system_module_response.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/remote_data_repository.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';
import 'package:pran_rfl_erp/core/exceptions/api_exceptions.dart';

import '../../core/exceptions/custom_exception.dart';
import '../entities/user_menu_item_response.dart';
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
    var response = await remoteDataRepository.rackTransfer(
        transactId: transactId, userId: userId);
  }

  @override
  Future<List<JobHistory>> getJobHistory() async {
    var response = await remoteDataRepository.getJobHistory();
    return response.items ?? [];
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
    required String trackid,
    required String itemid,
    required String rqty,
    required String batchid,
  }) async {
    await remoteDataRepository.interOrgTransfer(
      userid: userid,
      trackid: trackid,
      itemid: itemid,
      rqty: rqty,
      batchid: batchid,
    );
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
}
