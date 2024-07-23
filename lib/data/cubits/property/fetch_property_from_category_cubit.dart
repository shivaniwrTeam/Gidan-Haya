import 'package:ebroker/utils/admob/native_ad_manager.dart';
import 'package:ebroker/utils/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ebroker/data/helper/filter.dart';
import 'package:ebroker/data/model/data_output.dart';
import 'package:ebroker/data/model/property_model.dart';
import 'package:ebroker/data/repositories/property_repository.dart';

abstract class FetchPropertyFromCategoryState {}

class FetchPropertyFromCategoryInitial extends FetchPropertyFromCategoryState {}

class FetchPropertyFromCategoryInProgress
    extends FetchPropertyFromCategoryState {}

class FetchPropertyFromCategorySuccess extends FetchPropertyFromCategoryState {
  final bool isLoadingMore;
  final bool loadingMoreError;
  final List<dynamic> propertymodel;
  final int offset;
  final int total;
  final int? categoryId;
  FetchPropertyFromCategorySuccess(
      {required this.isLoadingMore,
      required this.loadingMoreError,
      required this.propertymodel,
      required this.offset,
      required this.total,
      this.categoryId});

  FetchPropertyFromCategorySuccess copyWith(
      {bool? isLoadingMore,
      bool? loadingMoreError,
      List<dynamic>? propertymodel,
      int? offset,
      int? total,
      int? categoryId}) {
    return FetchPropertyFromCategorySuccess(
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        loadingMoreError: loadingMoreError ?? this.loadingMoreError,
        propertymodel: propertymodel ?? this.propertymodel,
        offset: offset ?? this.offset,
        total: total ?? this.total,
        categoryId: categoryId ?? this.categoryId);
  }
}

class FetchPropertyFromCategoryFailure extends FetchPropertyFromCategoryState {
  final dynamic errorMessage;
  FetchPropertyFromCategoryFailure(this.errorMessage);
}

class FetchPropertyFromCategoryCubit
    extends Cubit<FetchPropertyFromCategoryState> {
  NativeAdInjector injector = NativeAdInjector();

  FetchPropertyFromCategoryCubit() : super(FetchPropertyFromCategoryInitial()) {
    injector(
      (conditions) {
        conditions
            .setAfter(7)
            .setInjectSetting(perLength: 10, count: 5)
            .setMinListCount(7);
      },
    );
  }

  final PropertyRepository _propertyRepository = PropertyRepository();
  Future<void> fetchPropertyFromCategory(int categoryId,
      {FilterApply? filter,
      bool? showPropertyType,
      required CallInfo callInfo}) async {
    try {
      emit(FetchPropertyFromCategoryInProgress());

      DataOutput<PropertyModel> result =
          await _propertyRepository.fetchProperyFromCategoryId(
        id: categoryId,
        offset: 0,
        showPropertyType: showPropertyType,
        filter: filter,
        callInfo: callInfo,
      );
      List<NativeAdWidgetContainer> properties = List.from(result.modelList);
      injector.wrapper(injectableList: properties);
      emit(
        FetchPropertyFromCategorySuccess(
          isLoadingMore: false,
          loadingMoreError: false,
          propertymodel: properties,
          offset: 0,
          total: result.total,
          categoryId: categoryId,
        ),
      );
    } catch (e, st) {
      emit(
        FetchPropertyFromCategoryFailure(
          e,
        ),
      );
    }
  }

  Future<void> fetchPropertyFromCategoryMore(
      {bool? showPropertyType, required CallInfo callInfo}) async {
    try {
      if (state is FetchPropertyFromCategorySuccess) {
        if ((state as FetchPropertyFromCategorySuccess).isLoadingMore) {
          return;
        }
        emit((state as FetchPropertyFromCategorySuccess)
            .copyWith(isLoadingMore: true));

        DataOutput<PropertyModel> result =
            await _propertyRepository.fetchProperyFromCategoryId(
                id: (state as FetchPropertyFromCategorySuccess).categoryId!,
                showPropertyType: showPropertyType,
                offset: (state as FetchPropertyFromCategorySuccess)
                    .propertymodel
                    .whereType<PropertyModel>()
                    .length,
                callInfo: callInfo);

        FetchPropertyFromCategorySuccess property =
            (state as FetchPropertyFromCategorySuccess);

        property.propertymodel.addAll(result.modelList);

        emit(
          FetchPropertyFromCategorySuccess(
            isLoadingMore: false,
            loadingMoreError: false,
            propertymodel: property.propertymodel,
            offset: (state as FetchPropertyFromCategorySuccess)
                .propertymodel
                .whereType<PropertyModel>()
                .length,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit(
        (state as FetchPropertyFromCategorySuccess).copyWith(
          isLoadingMore: false,
          loadingMoreError: true,
        ),
      );
    }
  }

  bool hasMoreData() {
    if (state is FetchPropertyFromCategorySuccess) {
      return (state as FetchPropertyFromCategorySuccess)
              .propertymodel
              .whereType<PropertyModel>()
              .length <
          (state as FetchPropertyFromCategorySuccess).total;
    }
    return false;
  }
}
