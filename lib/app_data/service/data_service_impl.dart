import 'package:pran_rfl_erp/app_data/entities/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/entities/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
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
  Future<void> transferBatch(
      {required String batchId,
      required String itemId,
      required String rackId,
      required String rqty,
      required String split}) async {
    await remoteDataRepository.transferBatch(
      batchId: batchId,
      itemId: itemId,
      rackId: rackId,
      rqty: rqty,
      split: split,
    );
  }

  @override
  Future<List<TransferBatchData>> getTransferBatchData() async {
    var response = await remoteDataRepository.getTransferBatchData();
    return response.items ?? [];
  }

  @override
  Future<List<UserMachine>> getUserMachine({required String userId}) async {
    var response = await remoteDataRepository.getUserMachine(userId: userId);
    return response.userMachineData ?? [];
  }

  @override
  Future<void> rackTransfer(
    int transactId,
  ) async {
    var response = await remoteDataRepository.rackTransfer(transactId);
  }

  @override
  Future<List<JobHistory>> getJobHistory() async {
    var response = await remoteDataRepository.getJobHistory();
    return response.items ?? [];
  }

  @override
  Future<void> tranferDelete({required int trnsfid}) async {
    await remoteDataRepository.tranferDelete(trnsfid: trnsfid);
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
}
