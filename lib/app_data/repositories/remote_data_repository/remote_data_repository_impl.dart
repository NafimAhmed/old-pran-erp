import 'package:http/http.dart' as http;
import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
import 'package:pran_rfl_erp/app_data/entities/generic_response.dart';
import 'package:pran_rfl_erp/app_data/entities/lov_response.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/decoder_service_mixin.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/remote_data_repository.dart';
import 'package:pran_rfl_erp/config/app_config.dart';

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

    return decodeResponse(response, decoder: EmployeResponse.fromJson);
  }

  @override
  Future<bool> sendProdQrInfo(
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

    return response.statusCode == 200 ? true : false;
  }

  @override
  Future<TempBatchDataResponse> getTempBatchData() async {
    var request = http.Request('GET',
        Uri.parse('${appConfig.baseUrl}/ords/rpro/batch/temp_batch_data'));

    http.StreamedResponse response = await request.send();

    return decodeResponse(response, decoder: TempBatchDataResponse.fromJson);
  }

  @override
  Future<void> transferBatch(
      String batchId, String itemId, String rackId) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/trnsfbatch?BATCHID=$batchId&itemid=$itemId&rackid=$rackId'));

    http.StreamedResponse response = await request.send();

    await decodeResponse(
      response,
    );
  }

  @override
  Future<TransferBatchDataResponse> getTransferBatchData() async {
    var request = http.Request(
        'GET', Uri.parse('${appConfig.baseUrl}/ords/rpro/batch/trnsfbatch'));

    http.StreamedResponse response = await request.send();

    return decodeResponse(response,
        decoder: TransferBatchDataResponse.fromJson);
  }

  @override
  Future<LovResponse> getLov() async {
    var request = http.Request(
        'GET', Uri.parse('${appConfig.baseUrl}/ords/rpro/batch/qrinfo'));

    http.StreamedResponse response = await request.send();

    return decodeResponse(response, decoder: LovResponse.fromJson);
  }

  @override
  Future<void> rackTransfer(int transactId) async {
    var request = http.Request(
        'POST',
        Uri.parse(
            '${appConfig.baseUrl}/ords/rpro/batch/racktrnsf?racktrnid=$transactId'));

    http.StreamedResponse response = await request.send();

    decodeResponse(response, decoder: GenericResponse.fromJson);
  }
}
