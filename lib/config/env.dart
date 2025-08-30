import '../helper/di/di.dart';

enum ENVType {
  uat,
  beta,
  prod;

  bool get isDev => this == ENVType.uat;

  bool get isBeta => this == ENVType.beta;

  bool get isProd => this == ENVType.prod;

  Env toENV() {
    switch (this) {
      case uat:
        return UatEnv();
      case beta:
        return BetaEnv();
      case prod:
        return ProdEnv();
      default:
        return UatEnv();
    }
  }
}

enum LogType {
  INFO,
  WARNING,
  ERROR;

  bool get isInfo => this == INFO;

  bool get isWarning => this == WARNING;

  bool get isError => this == ERROR;
}

abstract class Env {
  String get baseUrl;

  String get apiKey;

  String get socket;
}

class UatEnv implements Env {
  @override
  String get baseUrl => ' http://54.179.94.142:8081/api/v1';
  @override
  String get apiKey => 'xJL86Xe4owFAq68IVlVSYUGJ4IirntBUUD0KnTB9';
  @override
  String get socket => 'ws://103.167.89.112:8088/ws';
}

class BetaEnv implements Env {
  @override
  String get baseUrl => 'http://54.179.94.142:8081/api/v1';
  @override
  String get apiKey => 'xJL86Xe4owFAq68IVlVSYUGJ4IirntBUUD0KnTB9';
  @override
  String get socket => 'xJL86Xe4owFAq68IVlVSYUGJ4IirntBUUD0KnTB9';
}

class ProdEnv implements Env {
  @override
  String baseUrl = 'http://54.179.94.142:8081/api/v1';
  @override
  String apiKey = 'xJL86Xe4owFAq68IVlVSYUGJ4IirntBUUD0KnTB9';
  @override
  String get socket => 'ws://160.187.146.113:8088/ws';
}


class EnvSwitcher {
  static ENVType currentEnv = ENVType.uat;

  static Future<void> switchEnv(ENVType newEnv) async {
    if (currentEnv != newEnv) {
      currentEnv = newEnv;
      await initDI(currentEnv);
    }
  }
}

