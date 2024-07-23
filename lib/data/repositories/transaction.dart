import 'package:ebroker/utils/api.dart';
import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/data/model/transaction_model.dart';

class TransactionRepository {
  Future<DataOutput<TransactionModel>> fetchTransactions(
      {required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {};

    Map<String, dynamic> response = await Api.get(
        url: Api.getPaymentDetails,
        queryParameters: parameters,
        callInfo: callInfo);

    List<TransactionModel> transactionList = (response['data'] as List)
        .map((e) => TransactionModel.fromMap(e))
        .toList();

    return DataOutput<TransactionModel>(
        total: transactionList.length, modelList: transactionList);
  }
}
