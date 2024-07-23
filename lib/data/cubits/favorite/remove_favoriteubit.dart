// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ebroker/utils/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ebroker/data/repositories/favourites_repository.dart';

abstract class RemoveFavoriteState {}

class RemoveFavoriteInitial extends RemoveFavoriteState {}

class RemoveFavoriteInProgress extends RemoveFavoriteState {}

class RemoveFavoriteSuccess extends RemoveFavoriteState {
  final int id;
  RemoveFavoriteSuccess({
    required this.id,
  });
}

class RemoveFavoriteFailure extends RemoveFavoriteState {
  final String errorMessage;

  RemoveFavoriteFailure(this.errorMessage);
}

class RemoveFavoriteCubit extends Cubit<RemoveFavoriteState> {
  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  RemoveFavoriteCubit() : super(RemoveFavoriteInitial());

  void remove(int propertyID, {required CallInfo callInfo}) async {
    try {
      emit(RemoveFavoriteInProgress());
      await _favoriteRepository.removeFavorite(propertyID, callInfo: callInfo);
      emit(RemoveFavoriteSuccess(id: propertyID));
    } catch (e) {
      emit(RemoveFavoriteFailure(e.toString()));
    }
  }
}
