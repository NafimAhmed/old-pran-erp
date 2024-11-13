import 'package:http/http.dart' as http;
import 'package:pran_rfl_erp/app_data/entities/apps_user_response.dart';
import 'package:pran_rfl_erp/app_data/entities/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/entities/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
import 'package:pran_rfl_erp/app_data/entities/generic_response.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/entities/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/entities/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/entities/sys_menu_parent_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/system_module_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_machine_response.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/entities/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/decoder_service_mixin.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/remote_data_repository.dart';
import 'package:pran_rfl_erp/config/app_config.dart';

import '../../entities/user_menu_item_response.dart';

class RemoteDataRepositoryImpl
    with DecoderServiceMixin
    implements RemoteDataRepository {
  final AppConfig appConfig;

  RemoteDataRepositoryImpl({required this.appConfig});

  @override
  Future<EmployeResponse> getEmplist() async {
    var request = http.Request(
        'GET', Uri.parse('${appConfig.baseUrl}/ords/rpro/hr/empinfo/'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response, decoder: EmployeResponse.fromJson);
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
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/qrinfo?itemid=$itemId&BATCHID=$batchId&QTY=$qty&GOOD_QTY=$goodQty&BAD_QTY=$badQty&machine=$machine'));

    http.StreamedResponse response = await request.send();

    await decodeResponse(response);
  }

  @override
  Future<TempBatchDataResponse> getTempBatchData() async {
    var request = http.Request('GET',
        Uri.parse('${appConfig.baseUrl}/ords/rpro/batch/temp_batch_data'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response,
        decoder: TempBatchDataResponse.fromJson);
  }

  // @override
  // Future<void> transferBatch(
  //     {required String batchId,
  //     required String itemId,
  //     required String rackId,
  //     required String rqty,
  //     required String split}) async {
  //   var request = http.Request(
  //       'POST',
  //       Uri.parse(
  //           '${appConfig.baseUrl}/ords/rpro/batch/trnsfbatch_test?batchid=$batchId&itemid=$itemId&rqty=$rqty&rackid=$rackId&split_flag=$split'));

  //   http.StreamedResponse response = await request.send();

  //   await decodeResponse(
  //     response,
  //   );
  // }
  @override
  Future<void> transferBatch({
    required String pTrnid,
    required String userid,
    required String rackId,
    required String rqty,
    required String split,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/userbatchstock?rqty=$rqty&userid=$userid&p_trnid=$pTrnid&rackid=$rackId&split_flag=$split'));

    http.StreamedResponse response = await request.send();

    await decodeResponse(
      response,
    );
  }

  @override
  Future<TransferBatchDataResponse> getTransferBatchData(
      {required String userId}) async {
    // var request = http.Request(
    //     'GET', Uri.parse('${appConfig.baseUrl}/ords/rpro/batch/trnsfbatch'));
    var request = http.Request(
        'GET',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/userbatchstock?userid=$userId'));
    http.StreamedResponse response = await request.send();

    return await decodeResponse(response,
        decoder: TransferBatchDataResponse.fromJson);
  }

  @override
  Future<UserMachineResponse> getUserMachine({required String userId}) async {
    var request = http.Request(
        'Post',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/usermachine?userid=$userId'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response,
        decoder: UserMachineResponse.fromJson);
  }

  @override
  Future<void> rackTransfer({
    required int transactId,
    required String userId,
  }) async {
    // var request = http.Request(
    //     'POST',
    //     Uri.parse(
    //         '${appConfig.baseUrl}/ords/rpro/batch/racktrnsf?racktrnid=$transactId'));
    var request = http.Request(
      'POST',
      Uri.parse(
          '${appConfig.baseUrl}/ords/rpro/batch/userstocksubinvtrns?trnid=$transactId&userid=$userId&split=0'),
    );

    http.StreamedResponse response = await request.send();

    await decodeResponse(
      response,
    );
    // var request = http.Request(
    //     'POST',
    //     Uri.parse(
    //         '${appConfig.baseUrl}/ords/rpro/batch/racktrnf_test?racktrnid=$transactId'));

    // http.StreamedResponse response = await request.send();

    // await decodeResponse(response);
  }

  @override
  Future<JobHistoryResponse> getJobHistory() async {
    var request = http.Request(
        'GET', Uri.parse('${appConfig.baseUrl}/ords/rpro/batch/jobhist'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response, decoder: JobHistoryResponse.fromJson);
  }

  @override
  Future<void> tranferDelete({
    required int trnsfid,
    required String userId,
  }) async {
    // var request = http.Request(
    //     'POST',
    //     Uri.parse(
    //         '${appConfig.baseUrl}/ords/rpro/batch/trnfdel?trnsfid=$trnsfid'));
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/userskttrnfdel?userid=$userId&trnsfid=$trnsfid'));

    http.StreamedResponse response = await request.send();

    await decodeResponse(response);
  }

  @override
  Future<AuthenticationResponse> authenticate(
      {required String userid, required String passw}) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/login?userid=$userid&passw=$passw'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response,
        decoder: AuthenticationResponse.fromJson);
  }

  @override
  Future<UserMenuItemResponse> getUserMenu({
    required String userid,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/usermenu?userid=$userid'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse<UserMenuItemResponse>(response,
        decoder: UserMenuItemResponse.fromJson);
  }

  @override
  Future<UserOrgsResponse> getUserOrg({
    required String userid,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/userorgs?userid=$userid'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse<UserOrgsResponse>(response,
        decoder: UserOrgsResponse.fromJson);
  }

  @override
  Future<UserBasicDataResponse> getUserBasicData({
    required String userid,
    required String orgid,
  }) async {
    var request = http.Request(
      'POST',
      Uri.parse(
          '${appConfig.baseUrl}/ords/rpro/batch/userbasicdata?userid=$userid&orgid=$orgid'),
    );

    http.StreamedResponse response = await request.send();
    return decodeResponse<UserBasicDataResponse>(response,
        decoder: UserBasicDataResponse.fromJson);
  }

  @override
  Future<void> interOrgTransfer({
    required String userid,
    required String trackid,
    required String itemid,
    required String rqty,
    required String batchid,
  }) async {
    var request = http.Request(
      'POST',
      Uri.parse(
          '${appConfig.baseUrl}/ords/rpro/batch/interorgtrns?userid=$userid&trackid=$trackid&itemid=$itemid&rqty=$rqty&batchid=$batchid'),
    );

    http.StreamedResponse response = await request.send();

    await decodeResponse(response);
  }

  @override
  Future<BatchQrDataResponse> userQrSave({
    required String userid,
    required String itemid,
    required String machine,
    required String batchid,
    required String orgid,
    required String goodQty,
    required String badQty,
    required String qty,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/userqrsave?userid=$userid&machine=$machine&orgid=$orgid&batchid=$batchid&itemid=$itemid&goodqty=$goodQty&badqty=$badQty&qty=$qty'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response,
        decoder: BatchQrDataResponse.fromJson);
  }

  @override
  Future<UserQrPrintResponse> getUserQrPrintData({
    required String userid,
    required String orgid,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/userqrprint?userid=$userid&orgid=$orgid'));

    http.StreamedResponse response = await request.send();

    return decodeResponse(response, decoder: UserQrPrintResponse.fromJson);
  }

  @override
  Future<GenericResponse> updateProdQrPrintStatus({
    required String trnlotno,
  }) async {
    var request = http.Request(
        'PUT',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/userqrsave?trnlotno=$trnlotno'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<SystemModuleResponse> getSystemModule({
    required String userId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/sysmanager?userid=$userId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: SystemModuleResponse.fromJson);
  }

  @override
  Future<SystemMenuParentDataResponse> getSystemMenuParent({
    required String userId,
    required String moduleName,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/sysmenu?userid=$userId&modulename=$moduleName'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: SystemMenuParentDataResponse.fromJson);
  }

  @override
  Future<GenericResponse> sysCreateMenu({
    required String userId,
    required String pMenuName,
    required String pMenuType,
    required String pModule,
    required String? pParent,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/syscreatemenu?userid=$userId&P_menu_name=$pMenuName&P_menu_type=$pMenuType&P_module=$pModule&P_parent=$pParent'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<AppsUserResponse> getAppsUser() async {
    var request = http.Request(
        'POST', Uri.parse('${appConfig.baseUrl}/ords/rpro/sysadmin/appsuser'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response, decoder: AppsUserResponse.fromJson);
  }

  @override
  Future<GenericResponse> createUser({
    required String newUserId,
    required String newUserName,
    required String userId,
    required String passw,
    required String appUser,
    required String mobileNo,
    required String desigName,
    required String deptName,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/usercreation?newuserid=$newUserId&newusername=$newUserName&userid=$userId&passw=$passw&appuser=$appUser&mobileno=$mobileNo&designame=null&deptname=null'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<QrUserResponse> getQrUsers() async {
    var request = http.Request(
        'POST', Uri.parse('${appConfig.baseUrl}/ords/rpro/sysadmin/qruser'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response, decoder: QrUserResponse.fromJson);
  }

  @override
  Future<QrUserMenuResponse> getQrUserMenu(
      {required String newUserId, required String creatorId}) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/qrmodule?newuserid=$newUserId&creatorid=$creatorId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: QrUserMenuResponse.fromJson);
  }

  @override
  Future<QrUserMenuResponse> getQrUserChildMenu({
    required String newUserId,
    required String creatorId,
    required String routeName,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/qrchildmenu?newuserid=$newUserId&creatorid=$creatorId&routename=$routeName'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: QrUserMenuResponse.fromJson);
  }

  @override
  Future<GenericResponse> giveUserMenuPermission({
    required String userId,
    required String newUserId,
    required String menuId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/menupermission?userid=$userId&newuserid=$newUserId&menu_id=$menuId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }
}
