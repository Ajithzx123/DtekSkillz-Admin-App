import 'dart:developer';

import 'package:e_demand/app/generalImports.dart';

abstract class SearchProviderState {}

class SearchProviderInitial extends SearchProviderState {}

class SearchProviderInProgress extends SearchProviderState {}

class SearchProviderSuccess extends SearchProviderState {
  SearchProviderSuccess({
    required this.totalServices,
    required this.serviceList,
    required this.isLoadingMore,
    required this.providerList,
    required this.totalProviders,
  });

  List<Providers> providerList;
  List<Services> serviceList;
  final String totalServices;
  final String totalProviders;
  final bool isLoadingMore;

  SearchProviderSuccess copyWith({
    List<Providers>? providerList,
    List<Services>? servicesList,
    final String? totalServices,
    final String? totalProviders,
    final bool? isLoadingMore,
  }) =>
      SearchProviderSuccess(
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        totalProviders: totalProviders ?? this.totalProviders,
        providerList: providerList ?? this.providerList,
        serviceList: servicesList ?? this.serviceList,
        totalServices: totalServices ?? this.totalServices,
      );
}

class SearchProviderFailure extends SearchProviderState {
  SearchProviderFailure(this.errorMessage);

  final String errorMessage;
}

class SearchMoreProvidersFailure extends SearchProviderState {
  SearchMoreProvidersFailure(this.errorMessage);

  final String errorMessage;
}

class SearchProviderCubit extends Cubit<SearchProviderState> {
  SearchProviderCubit(this.providerRepository, this.serviceRepository)
      : super(SearchProviderInitial());
  final ProviderRepository providerRepository;
  final ServiceRepository serviceRepository;

  Future<void> searchProvider({required final String searchKeyword}) async {
    try {
      emit(SearchProviderInProgress());
      //
      final Map<String, dynamic> searchProviderData =
          await providerRepository.searchProvider(
        searchKeyword: searchKeyword,
        limit: limitOfAPIData,
        offset: "0",
      );
      final Map<String, dynamic> searchServiceData =
          await serviceRepository.searchService(
        searchKeyword: searchKeyword,
        offset: "0",
        limit: limitOfAPIData,
      );
      //
      emit(
        SearchProviderSuccess(
          serviceList: searchServiceData['services'],
          totalServices: searchServiceData['totalServices'],
          isLoadingMore: false,
          totalProviders: searchProviderData['totalProviders'],
          providerList: searchProviderData['providerList'],
        ),
      );
    } catch (error) {
      emit(SearchProviderFailure(error.toString()));
    }
  }

  Future<void> fetchMoreSearchedProvider(
      {required final String searchKeyword}) async {
    try {
      //
      final SearchProviderSuccess currentState = state as SearchProviderSuccess;
      final List<Providers> providerData = currentState.providerList;
      final List<Services> servicesData = currentState.serviceList;
      //
      if (currentState.isLoadingMore) {
        return;
      }
      //
      emit(currentState.copyWith(isLoadingMore: true));
      //
      final Map<String, dynamic> searchProviderData =
          await providerRepository.searchProvider(
        searchKeyword: searchKeyword,
        limit: limitOfAPIData,
        offset: currentState.providerList.length.toString(),
      );
      final Map<String, dynamic> searchServiceData =
          await providerRepository.searchProvider(
        searchKeyword: searchKeyword,
        limit: limitOfAPIData,
        offset: currentState.serviceList.length.toString(),
      );
      //
      servicesData.addAll(searchServiceData["services"]);
      providerData.addAll(searchProviderData["providerList"]);
      //
      emit(
        currentState.copyWith(
          providerList: providerData,
          isLoadingMore: false,
          servicesList: servicesData,
        ),
      );
    } catch (error) {
      emit(SearchMoreProvidersFailure(error.toString()));
    }
  }

  bool hasMoreProviders() {
    if (state is SearchProviderSuccess) {
      final bool hasMoreData =
          (state as SearchProviderSuccess).providerList.length <
              int.parse((state as SearchProviderSuccess).totalProviders);

      return hasMoreData;
    }
    return false;
  }
}

// import 'package:e_demand/app/generalImports.dart';

// abstract class SearchProviderState {}

// class SearchProviderInitial extends SearchProviderState {}

// class SearchProviderInProgress extends SearchProviderState {}

// class SearchProviderSuccess extends SearchProviderState {
//   SearchProviderSuccess({
//     required this.isLoadingMore,
//     required this.providerList,
//     required this.totalProviders,
//   });

//   List<Providers> providerList;
//   final String totalProviders;
//   final bool isLoadingMore;

//   SearchProviderSuccess copyWith({
//     List<Providers>? providerList,
//     final String? totalProviders,
//     final bool? isLoadingMore,
//   }) =>
//       SearchProviderSuccess(
//         isLoadingMore: isLoadingMore ?? this.isLoadingMore,
//         totalProviders: totalProviders ?? this.totalProviders,
//         providerList: providerList ?? this.providerList,
//       );
// }

// class SearchProviderFailure extends SearchProviderState {
//   SearchProviderFailure(this.errorMessage);

//   final String errorMessage;
// }

// class SearchMoreProvidersFailure extends SearchProviderState {
//   SearchMoreProvidersFailure(this.errorMessage);

//   final String errorMessage;
// }

// class SearchProviderCubit extends Cubit<SearchProviderState> {
//   SearchProviderCubit(this.providerRepository) : super(SearchProviderInitial());
//   final ProviderRepository providerRepository;

//   Future<void> searchProvider({required final String searchKeyword}) async {
//     try {
//       emit(SearchProviderInProgress());
//       //
//       final Map<String, dynamic> searchProviderData =
//           await providerRepository.searchProvider(
//         searchKeyword: searchKeyword,
//         limit: limitOfAPIData,
//         offset: "0",
//       );
//       //
//       emit(
//         SearchProviderSuccess(
//           isLoadingMore: false,
//           totalProviders: searchProviderData['totalProviders'],
//           providerList: searchProviderData['providerList'],
//         ),
//       );
//     } catch (error) {
//       emit(SearchProviderFailure(error.toString()));
//     }
//   }

//   Future<void> fetchMoreSearchedProvider(
//       {required final String searchKeyword}) async {
//     try {
//       //
//       final SearchProviderSuccess currentState = state as SearchProviderSuccess;
//       final List<Providers> providerData = currentState.providerList;
//       //
//       if (currentState.isLoadingMore) {
//         return;
//       }
//       //
//       emit(currentState.copyWith(isLoadingMore: true));
//       //
//       final Map<String, dynamic> searchProviderData =
//           await providerRepository.searchProvider(
//         searchKeyword: searchKeyword,
//         limit: limitOfAPIData,
//         offset: currentState.providerList.length.toString(),
//       );
//       //
//       providerData.addAll(searchProviderData["providerList"]);
//       //
//       emit(
//         currentState.copyWith(
//           providerList: providerData,
//           isLoadingMore: false,
//         ),
//       );
//     } catch (error) {
//       emit(SearchMoreProvidersFailure(error.toString()));
//     }
//   }

//   bool hasMoreProviders() {
//     if (state is SearchProviderSuccess) {
//       final bool hasMoreData =
//           (state as SearchProviderSuccess).providerList.length <
//               int.parse((state as SearchProviderSuccess).totalProviders);

//       return hasMoreData;
//     }
//     return false;
//   }
// }
