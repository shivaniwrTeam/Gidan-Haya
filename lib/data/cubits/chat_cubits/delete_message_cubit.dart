// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ebroker/utils/api.dart';

class DeleteMessageState {}

class DeleteMessageInitial extends DeleteMessageState {}

class DeleteMessageInProgress extends DeleteMessageState {}

class DeleteMessageSuccess extends DeleteMessageState {
  final int id;
  DeleteMessageSuccess({
    required this.id,
  });
}

class DeleteMessageFail extends DeleteMessageState {
  dynamic error;
  DeleteMessageFail({
    required this.error,
  });
}

class DeleteMessageCubit extends Cubit<DeleteMessageState> {
  DeleteMessageCubit() : super(DeleteMessageInitial());

  void delete(int id,
      {required int receiverId, required CallInfo callInfo}) async {
    try {
      emit(DeleteMessageInProgress());
      var x = await Api.post(
          url: Api.deleteChatMessage,
          parameter: {
            'message_id': id,
            'receiver_id': receiverId,
          },
          callInfo: callInfo);

      emit(DeleteMessageSuccess(id: id));
    } catch (e) {
      emit(DeleteMessageFail(error: e.toString()));
    }
  }
}
