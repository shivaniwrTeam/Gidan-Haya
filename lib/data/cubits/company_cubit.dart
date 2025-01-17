import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ebroker/utils/api.dart';
import 'package:ebroker/data/helper/custom_exception.dart';
import 'package:ebroker/data/model/company.dart';

abstract class CompanyState {}

class CompanyInitial extends CompanyState {}

class CompanyFetchProgress extends CompanyState {}

class CompanyFetchSuccess extends CompanyState {
  Company companyData;

  CompanyFetchSuccess(this.companyData);
}

class CompanyFetchFailure extends CompanyState {
  final dynamic errmsg;
  CompanyFetchFailure(this.errmsg);
}

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit() : super(CompanyInitial());

  void fetchCompany(BuildContext context,{
    required CallInfo callInfo
  }) {
    emit(CompanyFetchProgress());
    fetchCompanyFromDb(context, callInfo:callInfo )
        .then((value) => emit(CompanyFetchSuccess(value)))
        .catchError((e) => emit(CompanyFetchFailure(e)));
  }

  Future<Company> fetchCompanyFromDb(BuildContext context,
      {required CallInfo callInfo}) async {
    try {
      Company companyData = Company();

      Map<String, String> body = {
        Api.type: Api.company,
      };

      // var response = await HelperUtils.sendApiRequest(
      //     Api.apiGetSystemSettings, body, true, context,
      //     passUserid: false);

      var response = await Api.post(
          url: Api.apiGetSystemSettings, parameter: body, callInfo: callInfo);

      // var getdata = json.decode(response);

      if (!response[Api.error]) {
        Map list = response['data'];
        // companyData = list.map((model) => Company.fromJson(model)).toList();

        companyData = Company.fromJson(Map.from(list));

        //set company mobile/contact number for Call @ Property details
        // Constant.session
        //     .setData(Session.keyCompMobNo, contactNumber.data.toString());
      } else {
        throw CustomException(response[Api.message]);
      }

      return companyData;
    } catch (e, st) {
      throw e;
    }
  }
}
