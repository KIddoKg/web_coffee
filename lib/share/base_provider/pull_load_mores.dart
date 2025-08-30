// import 'package:flutter/cupertino.dart';
// import 'package:xanh_coffee/share/base_provider/page_controller.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
//
// // abstract class BaseListMoresViewModel<T> extends ChangeNotifier {
// //   bool nothing = false;
// //   int page = 1;
// //   final int pageSize = 20;
// //   bool hasMore = true;
// //   List<T> typeData = [];
// //   RefreshController refreshController = RefreshController(initialRefresh: false);
// //
// //
// //   /// 🔃 Initialize data
// //   Future<void> init(BuildContext context) async {
// //     onRefresh(context);
// //   }
// //
// //   /// 🔄 Refresh data
// //   void onRefresh(BuildContext context) async {
// //     page = 1;
// //     hasMore = true;
// //     nothing = false;
// //
// //     typeData.clear();
// //     notifyListeners();
// //     await Future.delayed(Duration(milliseconds: 1000));
// //     await fetchData(context, isRefresh: true);
// //   }
// //
// //   /// 🔽 Load more data if available
// //   void onLoading(BuildContext context) async {
// //     if (hasMore) {
// //       await fetchData(context);
// //     } else {
// //       refreshController.loadNoData();
// //     }
// //   }
// //
// //   /// 📥 Fetch data from API (to be implemented in subclasses)
// //   Future<void> fetchData(BuildContext context, {bool isRefresh = false});
// //
// //
// //
// //   bool nothingTwo = false;
// //   int pageTwo = 1;
// //   final int pageSizeTwo = 20;
// //   bool hasMoreTwo = true;
// //   List<T> typeDataTwo = [];
// //   RefreshController refreshControllerTwo = RefreshController(initialRefresh: false);
// //
// //
// //   /// 🔃 Initialize data
// //   Future<void> initTwo(BuildContext context) async {
// //     onRefreshTwo(context);
// //   }
// //
// //   /// 🔄 Refresh data
// //   void onRefreshTwo(BuildContext context) async {
// //     pageTwo = 1;
// //     hasMoreTwo = true;
// //     nothingTwo = false;
// //
// //     typeDataTwo.clear();
// //     notifyListeners();
// //     await Future.delayed(Duration(milliseconds: 1000));
// //     await fetchDataTwo(context, isRefresh: true);
// //   }
// //
// //   /// 🔽 Load more data if available
// //   void onLoadingTwo(BuildContext context) async {
// //     if (hasMore) {
// //       await fetchDataTwo(context);
// //     } else {
// //       refreshControllerTwo.loadNoData();
// //     }
// //   }
// //
// //   /// 📥 Fetch data from API (to be implemented in subclasses)
// //   Future<void> fetchDataTwo(BuildContext context, {bool isRefresh = false});
// //
// //
// //
// //
// //
// //   /// 🔁 Reset all data
// //   void resetBase() {
// //     page = 1;
// //     nothing = false;
// //     hasMore = true;
// //     typeData.clear();
// //     // refreshController.dispose();
// //     notifyListeners();
// //   }
// //
// //   void resetAll(){
// //     resetBase();
// //     notifyListeners();
// //   }
// // }
// import 'package:flutter/material.dart';
//
// abstract class BaseListMoresViewModel<T, U> extends ChangeNotifier {
//   final PagingController<T> listOne = PagingController<T>();
//   final PagingController<U> listTwo = PagingController<U>();
//
//   /// 🔃 Initialize both lists
//   Future<void> init(BuildContext context) async {
//     await onRefresh(context, list: listOne, fetchFunc: fetchData);
//   }
//
//   Future<void> initTwo(BuildContext context) async {
//     await onRefresh(context, list: listTwo, fetchFunc: fetchDataTwo);
//   }
//
//   /// 🔁 Refresh logic for both lists
//   Future<void> onRefresh(
//       BuildContext context, {
//         required PagingController<dynamic> list,
//         required Future<void> Function(BuildContext, {bool isRefresh}) fetchFunc,
//       }) async {
//     list.reset(); // Reset the list before refreshing
//     notifyListeners();
//     await Future.delayed(Duration(milliseconds: 500)); // Optional: Delay to simulate loading
//     await fetchFunc(context, isRefresh: true);
//   }
//
//   /// 🔽 Load more logic for both lists
//   Future<void> onLoading(
//       BuildContext context, {
//         required PagingController<dynamic> list,
//         required Future<void> Function(BuildContext, {bool isRefresh}) fetchFunc,
//       }) async {
//     if (list.hasMore) {
//       await fetchFunc(context);
//     } else {
//       list.refreshController.loadNoData();
//     }
//   }
//
//   /// 📥 To be implemented by child classes
//   Future<void> fetchData(BuildContext context, {bool isRefresh = false});
//   Future<void> fetchDataTwo(BuildContext context, {bool isRefresh = false});
//
//   /// 🔄 Reset both lists
//   void resetAll() {
//     listOne.reset();
//     listTwo.reset();
//     notifyListeners();
//   }
// }
//
