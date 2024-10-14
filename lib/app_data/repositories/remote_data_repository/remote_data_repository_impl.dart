import 'package:http/http.dart' as http;
import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
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
}
