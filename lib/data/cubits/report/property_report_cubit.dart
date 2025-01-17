import 'package:ebroker/utils/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ebroker/data/repositories/report_property_repository.dart';

List<int> reportedProperties = [];

abstract class PropertyReportState {}

class PropertyReportInitial extends PropertyReportState {}

class PropertyReportInProgress extends PropertyReportState {}

class PropertyReportInSuccess extends PropertyReportState {
  final String responseMessage;

  PropertyReportInSuccess(this.responseMessage);
}

class PropertyReportFaliure extends PropertyReportState {
  final dynamic error;

  PropertyReportFaliure(this.error);
}

class PropertyReportCubit extends Cubit<PropertyReportState> {
  PropertyReportCubit() : super(PropertyReportInitial());
  ReportPropertyRepository repository = ReportPropertyRepository();
  void report(
      {required int property_id,
      required int reason_id,
      String? message,
      required CallInfo callInfo}) async {
    try {
      emit(PropertyReportInProgress());
      Map result = await repository.reportProperty(
          reasonId: reason_id,
          propertyId: property_id,
          message: message,
          callInfo: callInfo);

      reportedProperties.add(property_id);
      emit(PropertyReportInSuccess(result['message']));
    } catch (e) {
      emit(PropertyReportFaliure(e));
    }
  }
}
