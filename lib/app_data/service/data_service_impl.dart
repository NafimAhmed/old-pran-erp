import 'package:pran_rfl_erp/app_data/entities/employee_response.dart';
import 'package:pran_rfl_erp/app_data/entities/jobhist_response.dart';
import 'package:pran_rfl_erp/app_data/entities/lov_response.dart';
import 'package:pran_rfl_erp/app_data/entities/temp_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/entities/transfer_batch_data_response.dart';
import 'package:pran_rfl_erp/app_data/repositories/local_data_repository/local_data_repository.dart';
import 'package:pran_rfl_erp/app_data/repositories/remote_data_repository/remote_data_repository.dart';
import 'package:pran_rfl_erp/app_data/service/data_service.dart';
import 'package:pran_rfl_erp/core/exceptions/api_exceptions.dart';

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
  Future<bool> sendProdQrInfo(
    String itemId,
    String batchId,
    String qty,
    String goodQty,
    String badQty,
    String machine,
  ) async {
    var response = await remoteDataRepository.sendProdQrInfo(
      itemId,
      batchId,
      qty,
      goodQty,
      badQty,
      machine,
    );
    if (!response) {
      throw const ApiDataException("Unable to save the data");
    }
    return response;
  }

  @override
  Future<List<TempBatchData>> getTempBatchData() async {
    var response = await remoteDataRepository.getTempBatchData();
    return response.items ?? [];
  }

  @override
  Future<void> transferBatch(
      String batchId, String itemId, String rackId) async {
    await remoteDataRepository.transferBatch(batchId, itemId, rackId);
  }

  @override
  Future<List<TransferBatchData>> getTransferBatchData() async {
    var response = await remoteDataRepository.getTransferBatchData();
    return response.items ?? [];
  }

  @override
  Future<List<Lov>> getLov() async {
    var response = await remoteDataRepository.getLov();
    return response.items ?? [];
  }

  @override
  Future<void> rackTransfer(int transactId) async {
    var response = await remoteDataRepository.rackTransfer(transactId);
  }

  @override
  Future<List<JobHistory>> getJobHistory() async {
    var response = await remoteDataRepository.getJobHistory();
    return response.items ?? [];
  }
}
