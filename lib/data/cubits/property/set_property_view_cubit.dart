import 'package:ebroker/utils/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ebroker/data/repositories/property_repository.dart';

abstract class SetPropertyViewState {}

class SetPropertyViewInitial extends SetPropertyViewState {}

class SetPropertyViewInProgress extends SetPropertyViewState {}

class SetPropertyViewSuccess extends SetPropertyViewState {}

class SetPropertyViewFailure extends SetPropertyViewState {
  final String errorMessage;

  SetPropertyViewFailure(this.errorMessage);
}

class SetPropertyViewCubit extends Cubit<SetPropertyViewState> {
  final PropertyRepository _propertyRepository = PropertyRepository();

  SetPropertyViewCubit() : super(SetPropertyViewInitial());

  Future<void> set(String propertyId,{
    required CallInfo callInfo
  }) async {
    try {
      emit(SetPropertyViewInProgress());
      await _propertyRepository.setProeprtyView(propertyId, callInfo: callInfo);
      emit(SetPropertyViewSuccess());
    } catch (e) {
      emit(SetPropertyViewFailure(e.toString()));
    }
  }
}
