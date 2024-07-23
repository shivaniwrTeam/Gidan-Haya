import 'package:ebroker/exports/main_export.dart';
import 'package:ebroker/utils/admob/native_ad_manager.dart';

abstract class HomePageInfinityScrollState {}

class HomePageInfinityScrollInitial extends HomePageInfinityScrollState {}

class HomePageInfinityScrollInProgress extends HomePageInfinityScrollState {}

class HomePageInfinityScrollSuccess extends HomePageInfinityScrollState {
  final int offset;
  final int total;
  final List<dynamic> properties;
  final bool isLoadingMore;
  final bool hasLoadMoreError;

  HomePageInfinityScrollSuccess({
    required this.offset,
    required this.total,
    required this.properties,
    required this.isLoadingMore,
    required this.hasLoadMoreError,
  });

  HomePageInfinityScrollSuccess copyWith({
    int? offset,
    int? total,
    List<dynamic>? propertyModel,
    bool? isLoadingMore,
    bool? hasLoadMoreError,
  }) {
    return HomePageInfinityScrollSuccess(
      offset: offset ?? this.offset,
      total: total ?? this.total,
      properties: propertyModel ?? this.properties,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasLoadMoreError: hasLoadMoreError ?? this.hasLoadMoreError,
    );
  }
}

class HomePageInfinityScrollFailure extends HomePageInfinityScrollState {
  final dynamic error;
  HomePageInfinityScrollFailure(this.error);
}

class HomePageInfinityScrollCubit extends Cubit<HomePageInfinityScrollState> {
  final NativeAdInjector injector = NativeAdInjector();

  HomePageInfinityScrollCubit() : super(HomePageInfinityScrollInitial()) {
    injector(
      (conditions) {
        conditions
            .setAfter(7)
            .setInjectSetting(perLength: 10, count: 10)
            .setMinListCount(7);
      },
    );
  }
  PropertyRepository propertyRepository = PropertyRepository();

  void fetch({required CallInfo callInfo}) async {
    try {
      emit(HomePageInfinityScrollInProgress());
      DataOutput<NativeAdWidgetContainer> dataOutput = await propertyRepository
          .fetchAllProperties(offset: 0, callInfo: callInfo);
      List<NativeAdWidgetContainer> properties =
          List.from(dataOutput.modelList);
      injector.wrapper(injectableList: properties);
      emit(HomePageInfinityScrollSuccess(
          offset: 0,
          total: dataOutput.total,
          properties: properties,
          isLoadingMore: false,
          hasLoadMoreError: false));
    } catch (e) {
      emit(HomePageInfinityScrollFailure(e));
    }
  }

  bool isLoadingMore() {
    if (state is HomePageInfinityScrollSuccess) {
      return (state as HomePageInfinityScrollSuccess).isLoadingMore;
    }
    return false;
  }

  bool hasMoreData() {
    if (state is HomePageInfinityScrollSuccess) {
      return ((state as HomePageInfinityScrollSuccess)
                  .properties
                  .whereType<PropertyModel>())
              .length <
          (state as HomePageInfinityScrollSuccess).total;
    }
    return false;
  }

  void fetchMore({required CallInfo callInfo}) async {
    if (state is HomePageInfinityScrollSuccess) {
      try {
        HomePageInfinityScrollSuccess scrollSuccess =
            (state as HomePageInfinityScrollSuccess);
        if (scrollSuccess.isLoadingMore) return;
        emit((state as HomePageInfinityScrollSuccess)
            .copyWith(isLoadingMore: true));

        DataOutput<PropertyModel> dataOutput =
            await propertyRepository.fetchAllProperties(
                offset: (state as HomePageInfinityScrollSuccess)
                    .properties
                    .whereType<PropertyModel>()
                    .length,
                callInfo: callInfo);

        HomePageInfinityScrollSuccess currentState =
            (state as HomePageInfinityScrollSuccess);

        currentState.properties.addAll(dataOutput.modelList);
        emit(HomePageInfinityScrollSuccess(
            isLoadingMore: false,
            hasLoadMoreError: false,
            properties: currentState.properties,
            offset: (state as HomePageInfinityScrollSuccess)
                .properties
                .whereType<PropertyModel>()
                .length,
            total: dataOutput.total));
      } catch (e) {
        print('Issue while load more $e');
        emit((state as HomePageInfinityScrollSuccess)
            .copyWith(hasLoadMoreError: true));
      }
    }
  }
}
