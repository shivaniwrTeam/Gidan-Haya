import 'dart:io';

import 'package:ebroker/utils/api.dart';
import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/data/model/subscription_pacakage_model.dart';
import 'package:ebroker/data/model/subscription_package_limit.dart';

enum SubscriptionLimitType { advertisement, property, isPremium }

class SubscriptionRepository {
  Future<DataOutput<SubscriptionPackageModel>> getSubscriptionPackages(
      {required int offset, required CallInfo callInfo}) async {
    Map<String, dynamic> response = await Api.get(
      url: Api.getPackage,
      queryParameters: {
        'platform': Platform.isIOS ? 'ios' : 'android',
        // "current_user": HiveUtils.getUserId()
      },
      callInfo: callInfo,
    );

    List<SubscriptionPackageModel> modelList = (response['data'] as List)
        .map((element) => SubscriptionPackageModel.fromJson(element))
        .toList();

    return DataOutput(total: modelList.length, modelList: modelList);
  }

  Future<SubcriptionPackageLimit> getPackageLimit(
      SubscriptionLimitType limitType,
      {required CallInfo callInfo}) async {
    Map<String, dynamic> response = await Api.get(
        url: Api.getLimitsOfPackage,
        queryParameters: {'package_type': limitType.name},
        callInfo: callInfo);
    return SubcriptionPackageLimit.fromMap(response);
  }

  Future<void> subscribeToPackage(int packageId, bool isPackageAvailable,
      {required CallInfo callInfo}) async {
    try {
      Map<String, dynamic> parameters = {
        Api.packageId: packageId,
        // Api.userid: HiveUtils.getUserId(),
        if (isPackageAvailable) 'flag': 1,
      };

      await Api.post(
        url: Api.userPurchasePackage,
        parameter: parameters,
        callInfo: callInfo,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> assignFreePackage(int packageId,
      {required CallInfo callInfo}) async {
    await Api.post(
        url: Api.assignPackage,
        parameter: {'package_id': packageId, 'in_app': false},
        callInfo: callInfo);
  }

  Future<void> assignPackage(
      {required String packageId,
      required String productId,
      required CallInfo callInfo}) async {
    try {
      await Api.post(
          url: Api.assignPackage,
          parameter: {
            'package_id': packageId,
            'product_id': productId,
            'in_app': true,
          },
          callInfo: callInfo);
    } catch (e) {
      throw 'e:$e';
    }
  }
}
