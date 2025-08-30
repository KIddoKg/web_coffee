// import 'package:flutter/cupertino.dart';
// import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
//
// abstract class BaseListViewModel<T> extends ChangeNotifier {
//   bool nothing = false;
//   int page = 1;
//   final int pageSize = 20;
//   bool hasMore = true;
//   List<T> typeData = [];
//   RefreshController refreshController = RefreshController(initialRefresh: false);
//
//   /// 🔁 Reset all data
//   void resetBase() {
//     page = 1;
//     nothing = false;
//     hasMore = true;
//     typeData.clear();
//     // refreshController.dispose();
//     notifyListeners();
//   }
//
//   void resetAll(){
//     resetBase();
//     notifyListeners();
//   }
//
//   /// 🔃 Initialize data
//   Future<void> init(BuildContext context) async {
//     onRefresh(context);
//   }
//
//   /// 🔄 Refresh data
//   void onRefresh(BuildContext context) async {
//     page = 1;
//     hasMore = true;
//     nothing = false;
//
//     typeData.clear();
//     notifyListeners();
//     await Future.delayed(Duration(milliseconds: 1000));
//     await fetchData(context, isRefresh: true);
//   }
//
//   /// 🔽 Load more data if available
//   void onLoading(BuildContext context) async {
//     if (hasMore) {
//       await fetchData(context);
//     } else {
//       refreshController.loadNoData();
//     }
//   }
//
//   /// 📥 Fetch data from API (to be implemented in subclasses)
//   Future<void> fetchData(BuildContext context, {bool isRefresh = false});
// }
