import 'package:ebroker/utils/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ebroker/data/repositories/property_repository.dart';

abstract class DeletePropertyState {}

class DeletePropertyInitial extends DeletePropertyState {}

class DeletePropertyInProgress extends DeletePropertyState {}

class DeletePropertySuccess extends DeletePropertyState {}

class DeletePropertyFailure extends DeletePropertyState {
  final String errorMessage;

  DeletePropertyFailure(this.errorMessage);
}

class DeletePropertyCubit extends Cubit<DeletePropertyState> {
  final PropertyRepository _propertyRepository = PropertyRepository();
  DeletePropertyCubit() : super(DeletePropertyInitial());

  Future<void> delete(int id, {required CallInfo callInfo}) async {
    try {
      emit(DeletePropertyInProgress());

      await _propertyRepository.deleteProperty(id, callInfo: callInfo);
      emit(DeletePropertySuccess());
    } catch (e) {
      emit(DeletePropertyFailure(e.toString()));
    }
  }
}
