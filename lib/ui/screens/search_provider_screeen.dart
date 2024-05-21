// ignore_for_file: file_names

import 'dart:developer';
import 'package:e_demand/ui/screens/providerlist/newsearchList.dart';
import 'package:http/http.dart' as http;
import 'package:e_demand/app/generalImports.dart';
import 'package:e_demand/data/model/search_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({final Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();

  static Route route(final RouteSettings routeSettings) => CupertinoPageRoute(
        builder: (final BuildContext context) =>
            BlocProvider<SearchProviderCubit>(
          create: (final context) =>
              SearchProviderCubit(ProviderRepository(), ServiceRepository()),
          child: const SearchScreen(),
        ),
      );
}

class _SearchScreenState extends State<SearchScreen> {
  // search provider controller
  final TextEditingController searchProviderController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();

  //give delay to live search
  Timer? delayTimer;

  //to check length of search text
  int previousLength = 0;
  List<SearchModel> newSearchList = [];
  List<SearchModel> filteredList = [];

  // combineFunction() async {
  //   final List<Services> serviceList = [];
  //   final List<Providers> providerList = [];

  //   final Map<String, dynamic> parameterService = <String, dynamic>{
  //     Api.latitude: Hive.box(userDetailBoxKey).get(latitudeKey).toString(),
  //     Api.longitude: Hive.box(userDetailBoxKey).get(longitudeKey).toString(),
  //     "limit": "100"
  //   };
  //   final Map<String, dynamic> parameterprovider = <String, dynamic>{
  //     Api.latitude: Hive.box(userDetailBoxKey).get(latitudeKey).toString(),
  //     Api.longitude: Hive.box(userDetailBoxKey).get(longitudeKey).toString(),
  //   };

  //   final response =
  //       await http.post(body: parameterprovider, Uri.parse(Api.searchUser));
  //   print("-------------------------");
  //   print(Api.getProviders);
  //   print(parameterprovider);
  //   print("-------------------------");

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> header = jsonDecode(response.body);

  //     final List<dynamic> providerData = header["data"];
  //     setState(() {
  //       providerList.addAll(
  //           providerData.map((header) => Providers.fromJson(header)).toList());
  //     });

  //     print("yyyyy" + providerList.length.toString());
  //   } else {
  //     // print(response.reasonPhrase);
  //   }
  //   // print("111111");
  //   // print(parameter);
  //   // var responses =
  //   //     await http.post(body: parameterService, Uri.parse(Api.getServices));
  //   // print("-------------------------");
  //   // print(Api.getServices);
  //   // print(parameterService);
  //   // print("-------------------------");

  //   // if (responses.statusCode == 200) {
  //   //   final Map<String, dynamic> header = jsonDecode(responses.body);

  //   //   print("servicesss ------  " + responses.body);

  //   //   final List<dynamic> serviceData = header["data"];
  //   //   setState(() {
  //   //     serviceList.addAll(
  //   //         serviceData.map((header) => Services.fromJson(header)).toList());

  //   //     print("aaaaa--" + serviceList[0].userId.toString());
  //   //   });

  //   //   print("yyyyy" + serviceList.length.toString());
  //   // } else {}

  //   for (var i = 0; i < serviceList.length; i++) {
  //     SearchModel value = SearchModel(
  //       id: serviceList[i].id,
  //       image: "",
  //       name: serviceList[i].title,
  //       partnerName: serviceList[i].partnerName,
  //       providerId: serviceList[i].userId,
  //       rating: serviceList[i].rating,
  //     );
  //     print("model ---" + value.toJson().toString());
  //     newSearchList.add(value);
  //     print("user id" + newSearchList[i].providerId.toString());
  //   }
  //   // for (var i = 0; i < providerList.length; i++) {
  //   //   SearchModel value = SearchModel(
  //   //     id: providerList[i].id,
  //   //     image: providerList[i].image,
  //   //     name: providerList[i].companyName,
  //   //     partnerName: providerList[i].partnerName,
  //   //     providerId: providerList[i].providerId,
  //   //     rating: "",
  //   //   );
  //   //   setState(() {});

  //   //   newSearchList.add(value);
  //   //   print("provider id" + newSearchList[i].providerId.toString());
  //   // }

  //   setState(() {
  //     filteredList = newSearchList;
  //   });
  //   print("searchlist" + newSearchList.length.toString());
  //   print("servicelist " + serviceList.length.toString());
  //   print("provider" + providerList.length.toString());
  // }

  Future<void> combineFunction() async {
    final List<Providers> providerList = [];
    final List<SearchModel> newSearchList = [];

    final String latitude =
        Hive.box(userDetailBoxKey).get(latitudeKey).toString();
    final String longitude =
        Hive.box(userDetailBoxKey).get(longitudeKey).toString();

    final Map<String, dynamic> parameterProvider = {
      Api.latitude: latitude,
      Api.longitude: longitude,
    };

    final response =
        await http.post(body: parameterProvider, Uri.parse(Api.searchUser));
    print("-------------------------");
    print(Api.getProviders);
    print(parameterProvider);
    print("-------------------------");

    if (response.statusCode == 200) {
      final Map<String, dynamic> header = jsonDecode(response.body);
      final List<dynamic> providerData = header["data"];
      providerList
          .addAll(providerData.map((header) => Providers.fromJson(header)));

      print("Provider Count: ${providerList.length}");

      for (var provider in providerList) {
        SearchModel value = SearchModel(
          id: provider.id,
          image: provider.image,
          name: provider.companyName,
          partnerName: provider.partnerName,
          providerId: provider.providerId,
          rating: "",
        );
        newSearchList.add(value);
        print("Provider ID: ${value.providerId}");
      }
    } else {
      // Handle error
    }

    setState(() {
      filteredList = newSearchList;
    });

    print("Search List Count: ${newSearchList.length}");
    print("Provider List Count: ${providerList.length}");
  }

  //
  // void searchProvider({required final String searchText}) {
  //   context
  //       .read<SearchProviderCubit>()
  //       .searchProvider(searchKeyword: searchText);
  // }
  void searchFunction({required final String searchText}) {
    String searchvalue = searchText.toLowerCase();
    setState(() {
      filteredList = newSearchList
          .where((product) => product.name!.toLowerCase().contains(searchvalue))
          .toList();
    });
  }

  //
  // void searchTextListener() {
  //   if (searchProviderController.text.isEmpty) {
  //     delayTimer?.cancel();
  //   }

  //   if (delayTimer?.isActive ?? false) delayTimer?.cancel();

  //   delayTimer = Timer(const Duration(milliseconds: 300), () {
  //     if (searchProviderController.text.isNotEmpty) {
  //       if (searchProviderController.text.length != previousLength) {
  //         searchProvider(searchText: searchProviderController.text);
  //         //
  //         previousLength = searchProviderController.text.length;
  //       }
  //     } else {
  //       previousLength = 0;
  //       searchProvider(searchText: '');
  //     }
  //   });
  // }

  ///
  @override
  void initState() {
    super.initState();
    combineFunction();
    // searchProvider(searchText: '');
    //listen to search text change to  fetch data
    // searchProviderController.addListener(searchTextListener);

    _scrollController.addListener(() {
      if (!context.read<SearchProviderCubit>().hasMoreProviders()) {
        return;
      }

// nextPageTrigger will have a value equivalent to 70% of the list size.
      final nextPageTrigger = 0.7 * _scrollController.position.maxScrollExtent;

// _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
      if (_scrollController.position.pixels > nextPageTrigger) {
        if (mounted) {
          context.read<SearchProviderCubit>().fetchMoreSearchedProvider(
              searchKeyword: searchProviderController.text.trim());
        }
      }
    });
  }

  @override
  void dispose() {
    searchProviderController.dispose();
    _scrollController.dispose();
    delayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => AnnotatedRegion(
        value: UiUtils.getSystemUiOverlayStyle(context: context),
        child: Scaffold(
          appBar: AppBar(
            leading: CustomInkWellContainer(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SvgPicture.asset(
                  context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
                      ? Directionality.of(context)
                              .toString()
                              .contains(TextDirection.RTL.value.toLowerCase())
                          ? UiUtils.getImagePath("back_arrow_dark_ltr.svg")
                          : UiUtils.getImagePath("back_arrow_dark.svg")
                      : Directionality.of(context)
                              .toString()
                              .contains(TextDirection.RTL.value.toLowerCase())
                          ? UiUtils.getImagePath("back_arrow_light_ltr.svg")
                          : UiUtils.getImagePath("back_arrow_light.svg"),
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.accentColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            title: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 35.rh(context),
                child: TextField(
                  onChanged: (value) => searchFunction(searchText: value),
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.blackColor),
                  controller: searchProviderController,
                  cursorColor: Theme.of(context).colorScheme.blackColor,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 2, left: 15),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryColor,
                    hintText: 'searchProvider'.translate(context: context),
                    hintStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.blackColor),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    suffixIcon: Container(
                      padding: const EdgeInsets.all(10),
                      child: UiUtils.getSvgImage(
                        svgImage: 'search.svg',
                        height: 12,
                        width: 12,
                        color: Theme.of(context).colorScheme.blackColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.secondaryColor,
          ),
          body: BlocConsumer<SearchProviderCubit, SearchProviderState>(
            listener: (final BuildContext context,
                final SearchProviderState searchState) {
              if (searchState is SearchProviderFailure) {
                UiUtils.showMessage(
                    context,
                    searchState.errorMessage.translate(context: context),
                    MessageType.error);
              }
            },
            builder: (final BuildContext context,
                final SearchProviderState searchState) {
              // if (searchState is SearchProviderFailure) {
              //   return Center(
              //     child: ErrorContainer(
              //       errorMessage:
              //           'somethingWentWrong'.translate(context: context),
              //       onTapRetry: () => searchFunction(
              //           searchText: searchProviderController.text.trim()),
              //       showRetryButton: true,
              //     ),
              //   );
              // } else if (searchState is SearchProviderSuccess) {
              //   // if (searchState.providerList.isEmpty) {
              //   //   return NoDataContainer(
              //   //     titleKey: 'noProviderFound'.translate(context: context),
              //   //   );
              //   // }
              return _getProviderList();
              // }

              // return const SingleChildScrollView(
              //     child: ProviderListShimmerEffect(
              //   showTotalProviderContainer: false,
              // ));
            },
          ),
        ),
      );

  Widget _getProviderList() => CustomRefreshIndicator(
        onRefreshCallback: () {
          searchFunction(searchText: '');
        },
        displacment: 12,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: filteredList.length,
          itemBuilder: (final BuildContext context, final int index) {
            if (index >= filteredList.length) {
              return Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.accentColor),
              );
            }
            return SearchList(
              searchdetails: filteredList[index],
            );
          },
        ),
      );
}

// ignore_for_file: file_names

// import 'package:e_demand/app/generalImports.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({final Key? key}) : super(key: key);

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();

//   static Route route(final RouteSettings routeSettings) => CupertinoPageRoute(
//         builder: (final BuildContext context) =>
//             BlocProvider<SearchProviderCubit>(
//           create: (final context) => SearchProviderCubit(ProviderRepository()),
//           child: const SearchScreen(),
//         ),
//       );
// }

// class _SearchScreenState extends State<SearchScreen> {
//   // search provider controller
//   final TextEditingController searchProviderController =
//       TextEditingController();
//   final ScrollController _scrollController = ScrollController();

//   //give delay to live search
//   Timer? delayTimer;

//   //to check length of search text
//   int previousLength = 0;

//   //
//   void searchProvider({required final String searchText}) {
//     context
//         .read<SearchProviderCubit>()
//         .searchProvider(searchKeyword: searchText);
//   }

//   //
//   void searchTextListener() {
//     if (searchProviderController.text.isEmpty) {
//       delayTimer?.cancel();
//     }

//     if (delayTimer?.isActive ?? false) delayTimer?.cancel();

//     delayTimer = Timer(const Duration(milliseconds: 300), () {
//       if (searchProviderController.text.isNotEmpty) {
//         if (searchProviderController.text.length != previousLength) {
//           searchProvider(searchText: searchProviderController.text);
//           //
//           previousLength = searchProviderController.text.length;
//         }
//       } else {
//         previousLength = 0;
//         searchProvider(searchText: '');
//       }
//     });
//   }

//   ///
//   @override
//   void initState() {
//     super.initState();
//     searchProvider(searchText: '');
//     //listen to search text change to  fetch data
//     searchProviderController.addListener(searchTextListener);

//     _scrollController.addListener(() {
//       if (!context.read<SearchProviderCubit>().hasMoreProviders()) {
//         return;
//       }

// // nextPageTrigger will have a value equivalent to 70% of the list size.
//       final nextPageTrigger = 0.7 * _scrollController.position.maxScrollExtent;

// // _scrollController fetches the next paginated data when the current position of the user on the screen has surpassed
//       if (_scrollController.position.pixels > nextPageTrigger) {
//         if (mounted) {
//           context.read<SearchProviderCubit>().fetchMoreSearchedProvider(
//               searchKeyword: searchProviderController.text.trim());
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     searchProviderController.dispose();
//     _scrollController.dispose();
//     delayTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(final BuildContext context) => AnnotatedRegion(
//         value: UiUtils.getSystemUiOverlayStyle(context: context),
//         child: Scaffold(
//           appBar: AppBar(
//             leading: CustomInkWellContainer(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: SvgPicture.asset(
//                   context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
//                       ? Directionality.of(context)
//                               .toString()
//                               .contains(TextDirection.RTL.value.toLowerCase())
//                           ? UiUtils.getImagePath("back_arrow_dark_ltr.svg")
//                           : UiUtils.getImagePath("back_arrow_dark.svg")
//                       : Directionality.of(context)
//                               .toString()
//                               .contains(TextDirection.RTL.value.toLowerCase())
//                           ? UiUtils.getImagePath("back_arrow_light_ltr.svg")
//                           : UiUtils.getImagePath("back_arrow_light.svg"),
//                   colorFilter: ColorFilter.mode(
//                     Theme.of(context).colorScheme.accentColor,
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//             ),
//             title: Align(
//               alignment: Alignment.centerLeft,
//               child: SizedBox(
//                 height: 35.rh(context),
//                 child: TextField(
//                   style: TextStyle(
//                       fontSize: 12,
//                       color: Theme.of(context).colorScheme.blackColor),
//                   controller: searchProviderController,
//                   cursorColor: Theme.of(context).colorScheme.blackColor,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.only(bottom: 2, left: 15),
//                     filled: true,
//                     fillColor: Theme.of(context).colorScheme.primaryColor,
//                     hintText: 'searchProvider'.translate(context: context),
//                     hintStyle: TextStyle(
//                         fontSize: 12,
//                         color: Theme.of(context).colorScheme.blackColor),
//                     focusedBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.transparent),
//                       borderRadius: BorderRadius.all(Radius.circular(12)),
//                     ),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.transparent),
//                       borderRadius: BorderRadius.all(Radius.circular(12)),
//                     ),
//                     border: const OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.transparent),
//                       borderRadius: BorderRadius.all(Radius.circular(12)),
//                     ),
//                     suffixIcon: Container(
//                       padding: const EdgeInsets.all(10),
//                       child: UiUtils.getSvgImage(
//                         svgImage: 'search.svg',
//                         height: 12,
//                         width: 12,
//                         color: Theme.of(context).colorScheme.blackColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             elevation: 0,
//             backgroundColor: Theme.of(context).colorScheme.secondaryColor,
//           ),
//           body: BlocConsumer<SearchProviderCubit, SearchProviderState>(
//             listener: (final BuildContext context,
//                 final SearchProviderState searchState) {
//               if (searchState is SearchProviderFailure) {
//                 UiUtils.showMessage(
//                     context,
//                     searchState.errorMessage.translate(context: context),
//                     MessageType.error);
//               }
//             },
//             builder: (final BuildContext context,
//                 final SearchProviderState searchState) {
//               if (searchState is SearchProviderFailure) {
//                 return Center(
//                   child: ErrorContainer(
//                     errorMessage:
//                         'somethingWentWrong'.translate(context: context),
//                     onTapRetry: () => searchProvider(
//                         searchText: searchProviderController.text.trim()),
//                     showRetryButton: true,
//                   ),
//                 );
//               } else if (searchState is SearchProviderSuccess) {
//                 if (searchState.providerList.isEmpty) {
//                   return NoDataContainer(
//                     titleKey: 'noProviderFound'.translate(context: context),
//                   );
//                 }
//                 return _getProviderList(
//                     providerList: searchState.providerList,
//                     isLoadingMoreData: searchState.isLoadingMore);
//               }

//               return const SingleChildScrollView(
//                   child: ProviderListShimmerEffect(
//                 showTotalProviderContainer: false,
//               ));
//             },
//           ),
//         ),
//       );

//   Widget _getProviderList(
//           {required final List<Providers> providerList,
//           required final bool isLoadingMoreData}) =>
//       CustomRefreshIndicator(
//         onRefreshCallback: () {
//           searchProvider(searchText: '');
//         },
//         displacment: 12,
//         child: ListView.builder(
//           controller: _scrollController,
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           physics: const AlwaysScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: providerList.length + (isLoadingMoreData ? 1 : 0),
//           itemBuilder: (final BuildContext context, final int index) {
//             if (index >= providerList.length) {
//               return Center(
//                 child: CircularProgressIndicator(
//                     color: Theme.of(context).colorScheme.accentColor),
//               );
//             }
//             return ProviderList(
//               providerDetails: providerList[index],
//             );
//           },
//         ),
//       );
// }
