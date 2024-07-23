import 'dart:io';

import 'package:dio/dio.dart';

import 'package:ebroker/utils/api.dart';

class AdvertisementRepository {
  Future<Map<String, dynamic>> create(
      {required String type,
      required String propertyId,
      File? image,
      required CallInfo callInfo}) async {
    Map<String, dynamic> parameters = {
      Api.propertyId: propertyId,
      Api.type: type
    };
    if (image != null) {
      parameters[Api.image] = await MultipartFile.fromFile(image.path);
    }

    return await Api.post(
        url: Api.storeAdvertisement, parameter: parameters, callInfo: callInfo);
  }

  Future deleteAdvertisment(dynamic id, {required CallInfo callInfo}) async {
    await Api.post(
        url: Api.deleteAdvertisement,
        parameter: {Api.id: id},
        callInfo: callInfo);
  }
}
