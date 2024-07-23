import 'package:ebroker/utils/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ebroker/data/repositories/transaction.dart';
import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/data/model/transaction_model.dart';

abstract class FetchTransactionsState {}

class FetchTransactionsInitial extends FetchTransactionsState {}

class FetchTransactionsInProgress extends FetchTransactionsState {}

class FetchTransactionsSuccess extends FetchTransactionsState {
  final bool isLoadingMore;
  final bool loadingMoreError;
  final List<TransactionModel> transactionmodel;
  final int offset;
  final int total;
  FetchTransactionsSuccess({
    required this.isLoadingMore,
    required this.loadingMoreError,
    required this.transactionmodel,
    required this.offset,
    required this.total,
  });

  FetchTransactionsSuccess copyWith({
    bool? isLoadingMore,
    bool? loadingMoreError,
    List<TransactionModel>? transactionmodel,
    int? offset,
    int? total,
  }) {
    return FetchTransactionsSuccess(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadingMoreError: loadingMoreError ?? this.loadingMoreError,
      transactionmodel: transactionmodel ?? this.transactionmodel,
      offset: offset ?? this.offset,
      total: total ?? this.total,
    );
  }
}

class FetchTransactionsFailure extends FetchTransactionsState {
  final dynamic errorMessage;
  FetchTransactionsFailure(this.errorMessage);
}

class FetchTransactionsCubit extends Cubit<FetchTransactionsState> {
  FetchTransactionsCubit() : super(FetchTransactionsInitial());

  final TransactionRepository _transactionRepository = TransactionRepository();

  Future<void> fetchTransactions({required CallInfo callInfo}) async {
    try {
      emit(FetchTransactionsInProgress());

      DataOutput<TransactionModel> result =
          await _transactionRepository.fetchTransactions(callInfo: callInfo);

      emit(FetchTransactionsSuccess(
          isLoadingMore: false,
          loadingMoreError: false,
          transactionmodel: result.modelList,
          offset: 0,
          total: result.total));
    } catch (e) {
      if (!isClosed) {
        emit(FetchTransactionsFailure(e));
      }
    }
  }

  Future<void> fetchTransactionsMore({required CallInfo callInfo}) async {
    try {
      if (state is FetchTransactionsSuccess) {
        if ((state as FetchTransactionsSuccess).isLoadingMore) {
          return;
        }
        emit((state as FetchTransactionsSuccess).copyWith(isLoadingMore: true));
        DataOutput<TransactionModel> result =
            await _transactionRepository.fetchTransactions(callInfo: callInfo
                // offset: (state as FetchTransactionsSuccess).offset.LIST.length,
                );

        FetchTransactionsSuccess transactionmodelState =
            (state as FetchTransactionsSuccess);
        transactionmodelState.transactionmodel.addAll(result.modelList);
        emit(FetchTransactionsSuccess(
            isLoadingMore: false,
            loadingMoreError: false,
            transactionmodel: transactionmodelState.transactionmodel,
            offset: 0, //(state as FetchTransactionsSuccess).offset.LIST.length,
            total: result.total));
      }
    } catch (e) {
      emit((state as FetchTransactionsSuccess)
          .copyWith(isLoadingMore: false, loadingMoreError: true));
    }
  }

  bool hasMoreData() {
    if (state is FetchTransactionsSuccess) {
      // return (state as FetchTransactionsSuccess).offset.LIST.length <
      //     (state as FetchTransactionsSuccess).total;
    }
    return false;
  }
}
