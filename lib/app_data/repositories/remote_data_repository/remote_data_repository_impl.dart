import 'package:http/http.dart' as http;
import 'package:pran_rfl_erp/app_data/models/Job_order_sum_history_response.dart';
import 'package:pran_rfl_erp/app_data/models/apps_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/authentication_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_close_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_comp_dtl_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_qr_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_shift_change_response.dart';
import 'package:pran_rfl_erp/app_data/models/batch_status_check_response.dart';
import 'package:pran_rfl_erp/app_data/models/chat_list_response.dart';

import 'package:pran_rfl_erp/app_data/models/generic_response.dart';
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
import 'package:pran_rfl_erp/app_data/models/opm_dash_sm_response.dart';
import 'package:pran_rfl_erp/app_data/models/org_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_menu_response.dart';
import 'package:pran_rfl_erp/app_data/models/qr_user_response.dart';
import 'package:pran_rfl_erp/app_data/models/rcv_inv_org_trn_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/re_print_qr_response.dart';
import 'package:pran_rfl_erp/app_data/models/shift_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/sub_inv_response.dart';
import 'package:pran_rfl_erp/app_data/models/sys_menu_parent_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/system_module_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_info_response.dart';
import 'package:pran_rfl_erp/app_data/models/task_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/top_jo_info_list_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_create_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_machine_response.dart';
import 'package:pran_rfl_erp/app_data/models/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_basic_data_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_org_response.dart';
import 'package:pran_rfl_erp/app_data/models/user_qr_print_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/decoder_service_mixin.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/remote_data_repository.dart';
import 'package:pran_rfl_erp/config/app_config.dart';

import '../../models/user_menu_item_response.dart';

class RemoteDataRepositoryImpl
    with DecoderServiceMixin
    implements RemoteDataRepository {
  final AppConfig appConfig;

  RemoteDataRepositoryImpl({required this.appConfig});

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
    var request = http.Request(
      'POST',
      Uri.parse(
          '${appConfig.baseUrl}/ords/rpro/batch/userstocksubinvtrns?trnid=$transactId&userid=$userId&split=0'),
    );

    http.StreamedResponse response = await request.send();

    await decodeResponse(
      response,
    );
  }

  @override
  Future<JobHistoryResponse> getJobHistory(
      {required String userId, required String jobNo}) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/jobhist?userid=$userId&jobno=$jobNo'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response, decoder: JobHistoryResponse.fromJson);
  }

  @override
  Future<void> tranferDelete({
    required int trnsfid,
    required String userId,
  }) async {
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
  Future<GenericResponse> interOrgTransfer({
    required String userid,
    required String itemlotno,
    required String torackid,
    required String trnid,
  }) async {
    var request = http.Request(
      'POST',
      Uri.parse(
          '${appConfig.baseUrl}/ords/rpro/invtran/IOTapi?userid=$userid&itemlotno=$itemlotno&tlockid=$torackid&trnid=$trnid'),
    );

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response, decoder: GenericResponse.fromJson);
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
    required String shiftnm,
    required String shiftFromTime,
  }) async {
    var request = http.Request(
      'POST',
      Uri.parse(
        '${appConfig.baseUrl}/ords/rpro/batch/userqrsave?userid=$userid&machine=$machine&orgid=$orgid&batchid=$batchid&itemid=$itemid&goodqty=$goodQty&badqty=$badQty&qty=$qty&shiftnm=$shiftnm&shiftFromTime=$shiftFromTime',
      ),
    );

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
        '${appConfig.baseUrl}/ords/rpro/sysadmin/syscreatemenu?userid=$userId&P_menu_name=$pMenuName&P_menu_type=$pMenuType&P_module=$pModule&P_parent=$pParent',
      ),
    );

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
  Future<UserCreateResponse> createUser({
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
    return await decodeResponse(response, decoder: UserCreateResponse.fromJson);
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

  @override
  Future<LotTrnResponse> getLotTrnData({
    required String userId,
    required String racklocator,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/invtran/IOTstkdata?userid=$userId&racklocator=$racklocator'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: LotTrnResponse.fromJson);
  }

  @override
  Future<BatchCloseDataResponse> getBatchCloseData({
    required String userId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/BatchCloseData?userid=$userId'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response,
        decoder: BatchCloseDataResponse.fromJson);
  }

  @override
  Future<BatchComDtlDataResponse> getBatchCompDtlData({
    required String userId,
    required String batchid,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/BatchComDtlData?userid=$userId&batchid=$batchid'));

    http.StreamedResponse response = await request.send();
    return decodeResponse(response, decoder: BatchComDtlDataResponse.fromJson);
  }

  @override
  Future<GenericResponse> batchCompDtlDataLnUpdt({
    required String userId,
    required String mtldtlid,
    required String madeqty,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/BatchComLnUpdt?userid=$userId&mtldtlid=$mtldtlid&madeqty=$madeqty'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<GenericResponse> completeBatch({
    required String userId,
    required String batchid,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/BatchComplete?userid=$userId&batchid=$batchid'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<GenericResponse> batchClose({
    required String userId,
    required int batchid,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/BatchClose?userid=$userId&batchid=$batchid'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<BatchCompDataResponse> getBatchCompData({
    required String userId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/BatchCompleteData?userid=$userId'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response,
        decoder: BatchCompDataResponse.fromJson);
  }

  @override
  Future<GenericResponse> getBatchReleaseData({
    required String userId,
    required String orgId,
    required String batchId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/BatchRelease?userid=$userId&orgid=$orgId&batchid=$batchId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<RcvInvOrgTrnDataResponse> getRcvInvOrgTrnData({
    required String userId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/invtran/RcvIOTData?userid=$userId'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response,
        decoder: RcvInvOrgTrnDataResponse.fromJson);
  }

  @override
  Future<IotTrnDataResponse> getIotTrnData({
    required String userId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/invtran/IOTTrnsData?userid=$userId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: IotTrnDataResponse.fromJson);
  }

  @override
  Future<JobOrderSumHistoryResponse> getJobOrderSumHistory(
      {required String userId}) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/JoborderSumHistory?userid=$userId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: JobOrderSumHistoryResponse.fromJson);
  }

  @override
  Future<OrgsResponse> getOrgs() async {
    var request = http.Request('POST',
        Uri.parse('${appConfig.baseUrl}/ords/rpro/sysadmin/userAnOrgs'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: OrgsResponse.fromJson);
  }

  @override
  Future<GenericResponse> giveOrgAccess({
    required String newUserId,
    required String userId,
    required String orgId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/OrgAccessCreation?newuserid=$newUserId&userid=$userId&orgid=$orgId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<MachineCreateResponse> createMachine({
    required String machinename,
    required String userId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/newMachineCreare?machinename=$machinename&userid=$userId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: MachineCreateResponse.fromJson);
  }

  @override
  Future<MachineAssignResponse> assignMachineToOrg({
    required String machinename,
    required String userId,
    required String orgId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/machineAssign?userid=$userId&orgid=$orgId&machinename=$machinename'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: MachineAssignResponse.fromJson);
  }

  @override
  Future<SubInvResponse> getSubInv({
    required String orgId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/subinv?orgid=$orgId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: SubInvResponse.fromJson);
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
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/sysadmin/itemRackLocatorCreate?userid=$userId&orgid=$orgId&p_subinv=$pSubInv&prow=$pRow&prack=$pRack&pbeen=$pBeen&pdesc=$pDesc'));

    http.StreamedResponse response = await request.send();
    await decodeResponse(response);
  }

  @override
  Future<RePrintQrResponse> getRePrintData({
    required String pTrno,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/qrReprintEnbl?ptrno=$pTrno'));

    http.StreamedResponse response = await request.send();
    return decodeResponse(response, decoder: RePrintQrResponse.fromJson);
  }

  @override
  Future<GenericResponse> enableRePrint({
    required String pTrno,
  }) async {
    var request = http.Request(
        'PUT',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/qrReprintEnbl?ptrno=$pTrno'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<JobDtlDrillDwResponse> getJobDtlDrillDw({
    required String userid,
    required String jobOrderNo,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/userJobDtlDrillDw?userid=$userid&joborderno=$jobOrderNo'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: JobDtlDrillDwResponse.fromJson);
  }

  @override
  Future<JoLocDrillDwResponse> getJobLocDrillDw({
    required String userid,
    required String jobOrderNo,
    required String itemCode,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/JOLocDrillDw?userid=$userid&joborderno=$jobOrderNo&itemcode=$itemCode'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: JoLocDrillDwResponse.fromJson);
  }

  @override
  Future<OpmDashSmResponse> getOpmDashboardSM({
    required String userid,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/opmDashboardSM?userid=$userid'));

    http.StreamedResponse response = await request.send();
    return decodeResponse(response, decoder: OpmDashSmResponse.fromJson);
  }

  @override
  Future<GenericResponse> askAdd({
    required String userid,
    required String askText,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/glaiml/askadd?userid=$userid&asktext=$askText'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<ChatListResponse> getMessages({
    required String userid,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/glaiml/askans?userid=$userid'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: ChatListResponse.fromJson);
  }

  @override
  Future<TaskInfoResponse> getTaskInfoList({
    required String userid,
    required String jobOrderNo,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/taskapi/taskupdt?userid=$userid&joborderno=$jobOrderNo'));

    http.StreamedResponse response = await request.send();
    return decodeResponse(response, decoder: TaskInfoResponse.fromJson);
  }

  @override
  Future<JobOrderListResponse> getJoList({
    required String userid,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/taskapi/jobtask?userid=$userid'));

    http.StreamedResponse response = await request.send();
    return decodeResponse(response, decoder: JobOrderListResponse.fromJson);
  }

  @override
  Future<GenericResponse> saveTaskStatus({
    required String userid,
    required String taskStatus,
    required int taskId,
  }) async {
    var request = http.Request(
        'PUT',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/taskapi/taskupdt?userid=$userid&taskstatus=$taskStatus&tskid=$taskId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<JobOrderInfoResponse> getJobOrderInfo({
    required String userId,
    required String itemId,
    required String jobOrderNo,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/jobhistSum?jobno=$jobOrderNo&itemid=$itemId&userid=$userId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: JobOrderInfoResponse.fromJson);
  }

  @override
  Future<ShiftDataResponse> getShiftData() async {
    var request = http.Request(
        'POST', Uri.parse('${appConfig.baseUrl}/ords/rpro/batch/batchShift'));

    http.StreamedResponse response = await request.send();

    return await decodeResponse(response, decoder: ShiftDataResponse.fromJson);
  }

  @override
  Future<BatchShiftChangeResponse> getBatchShiftData({
    required String userId,
    required int orgId,
    required String batchNo,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/batchShiftChange?userid=$userId&orgid=$orgId&batchno=$batchNo'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: BatchShiftChangeResponse.fromJson);
  }

  @override
  Future<GenericResponse> batchShiftChange({
    required String userId,
    required String lotNo,
    required String shiftName,
    required String machineName,
    required String manPower,
  }) async {
    var request = http.Request(
        'PUT',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/batchShiftChange?lotno=$lotNo&userid=$userId&shiftnm=$shiftName&mcnname=$machineName&manpw=$manPower'));

    http.StreamedResponse response = await request.send();
    return decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<JobOrderCompletionListResponse> getJoComplList({
    required String userId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/jobStatusData?userid=$userId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: JobOrderCompletionListResponse.fromJson);
  }

  @override
  Future<GenericResponse> completeJO({
    required String userId,
    required String jobOrderNo,
  }) async {
    var request = http.Request(
        'PUT',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/opm/batch/jobStatusData?userid=$userId&joborderno=$jobOrderNo'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<TopJoInfoListResponse> getTopJOInfoList({
    required String userId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/jobhistTop?userid=$userId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response,
        decoder: TopJoInfoListResponse.fromJson);
  }

  @override
  Future<TaskListResponse> getTaskList({
    required String userId,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/taskapi/tasklist?userid=$userId'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: TaskListResponse.fromJson);
  }

  @override
  Future<GenericResponse> taskAssign({
    required int jobId,
    required int? pId,
    required String tsknm,
    required String tskdesc,
    required String tskasgne,
    required String startDate,
    required String endDate,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/taskapi/taskassignApi?jobid=$jobId&pid=$pId&tsknm=$tsknm&tskdesc=$tskdesc&tskasgne=$tskasgne&STDT=$startDate&EDDT=$endDate&userid=$tskasgne'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(response, decoder: GenericResponse.fromJson);
  }

  @override
  Future<BatchStatusCheckResponse> getBatchStatus({
    required String userId,
    required String lotNo,
  }) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/userBatchCheck?userid=$userId&lotno=$lotNo'));

    http.StreamedResponse response = await request.send();
    return await decodeResponse(
      response,
      decoder: BatchStatusCheckResponse.fromJson,
    );
  }
}
