import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:xanh_coffee/screens/home/viewModel/home_screen_vm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/env.dart';
import '../../router/router_app.dart';
import '../../screens/home_mobile/viewModel/home_mobile_screen_vm.dart';
import '../widget/util.dart';


// dđ
final di = GetIt.asNewInstance()..allowReassignment = true;

@injectableInit
Future<void> initDI(ENVType env) async {
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  di
    ..registerLazySingleton<ENVType>(() => env)
    ..registerFactory<Env>(() => env.toENV())
    ..registerFactory<SharedPreferences>(() => sharedPreferences)
    ..registerLazySingleton<WidgetUtil>(() => WidgetUtil())
    ..registerLazySingleton<AppRoute>(() => AppRoute())
    ..registerLazySingleton<HomeScreenVm>(() => HomeScreenVm())
    ..registerLazySingleton<HomeMobileScreenVm>(() => HomeMobileScreenVm());
  // ..registerFactory<FlutterSecureStorage>(() => const FlutterSecureStorage());
  // ..registerLazySingleton<CommonInterceptor>(
  //     () => CommonInterceptor(di<ENVType>().toENV()))
  // ..registerLazySingleton<DSBottomNavigationBarHelper>(
  //     () => DSBottomNavigationBarHelper());
}

void resetDi() {
  di.reset();
}
