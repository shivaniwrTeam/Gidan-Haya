import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ebroker/utils/api.dart';
import 'package:ebroker/utils/hive_utils.dart';
import 'package:ebroker/data/helper/custom_exception.dart';

abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountProgress extends DeleteAccountState {}

class DeleteAccountFailure extends DeleteAccountState {
  final String errorMessage;
  DeleteAccountFailure(this.errorMessage);
}

class AccountDeleted extends DeleteAccountState {
  final String successMessage;
  AccountDeleted({required this.successMessage});
}

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());
  void deleteUserAccount(BuildContext context,{
    required CallInfo callInfo 
  }) {
    emit(DeleteAccountProgress());
    deleteAccount(context, callInfo: callInfo)
        .then((value) => emit(AccountDeleted(successMessage: value)))
        .catchError((e) => emit(DeleteAccountFailure(e.toString())));
  }

  Future<String> deleteAccount(BuildContext context,
      {required CallInfo callInfo}) async {
    String message = '';

    /* User? currentUser = await FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.reload();
      }*/
    Map<String, String> parameter = {
      // Api.userid: HiveUtils.getUserId()!,
    };

    var response = await Api.post(
        url: Api.apiDeleteUser, parameter: parameter, callInfo: callInfo);

    if (response['error']) {
      throw CustomException(response['message']);
    } else {
      Future.delayed(
        Duration.zero,
        () {
          HiveUtils.logoutUser(context, onLogout: () {}, isRedirect: false);
        },
      );
      message = response['message'];
    }

    return message;
  }
}
