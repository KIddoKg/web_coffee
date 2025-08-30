import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:xanh_coffee/share/app_imports.dart';


enum logInType { customer, driver, owner }

class KeyValueThree {
  String key;
  dynamic value;
  dynamic status;
  int number;

  KeyValueThree(String key, dynamic value, dynamic status, int number)
      : key = key,
        value = value,
        status = status,
        number = number;
}

class KeyValue {
  String key;
  dynamic value;

  KeyValue(String key, dynamic value)
      : key = key,
        value = value;
}

KeyValue getTypeInfo(logInType type) {
  KeyValue x = KeyValue('', null);
  switch (type) {
    case logInType.driver:
      x = KeyValue('Tài xế', 0);
      break;
    case logInType.customer:
      x = KeyValue('Muốn Thuê xe', 3);
      break;
    case logInType.owner:
      x = KeyValue('Chủ Xe', 1);
      break;

    default:
      x = KeyValue('khác', -1);
      break;
  }
  return x;
}
//
// class KeyValueThree {
//   String key;
//   dynamic value;
//   dynamic value2;
//
//   KeyValueThree(String key, dynamic value, dynamic value2)
//       : key = key,
//         value = value,
//         value2 = value2;
// }

enum StatusShipper {
  all,
  project, //Dự án
  initialization, // Mới tạo
  waitProcess, // chờ tiến hành
  confirmation, //chờ xác nhận
  pickDelivery, // chờ lấy hàng
  transport, // vận chuyển
  delivered, // đã giao
  doneShipCTT, // Hoàn thành (CTT)
  doneShipDTT, // Hoàn thành (ĐTT)
  cancelShip, // huỷ ddơn
  pendingPayment, //đang tt
  notFound // chưa bt
}

KeyValueThree getTypeShipper(StatusShipper type) {
  KeyValueThree x = KeyValueThree('', null, null, 0);
  switch (type) {
    case StatusShipper.project:
      x = KeyValueThree('Đơn hàng Dự án', "Dự án", StatusShipper.initialization, 0);
      break;
    case StatusShipper.initialization:
      x = KeyValueThree('Đơn hàng đã được tạo', "Tạo đơn", StatusShipper.initialization, 1);
      break;
    case StatusShipper.waitProcess:
      x = KeyValueThree('Đơn hàng chờ tiến hành', "chờ tiến hành", StatusShipper.initialization, 14);
      break;
    case StatusShipper.confirmation:
      x = KeyValueThree('Đơn hàng đang đợi xác nhận', "Chờ xác nhận", StatusShipper.confirmation, -1);
      break;
    case StatusShipper.pickDelivery:
      x = KeyValueThree('Tài xế đã lấy đơn', "Lấy hàng", StatusShipper.pickDelivery, 3);
      break;
    case StatusShipper.transport:
      x = KeyValueThree('Đơn hàng đang vận chuyển', "Vận chuyển", StatusShipper.transport, 4);
      break;
    case StatusShipper.delivered:
      x = KeyValueThree('Đơn hàng đã giao', "Đã giao", StatusShipper.delivered, 5);
      break;
    case StatusShipper.doneShipCTT:
      x = KeyValueThree('Đơn hàng chưa thanh toán', "Đợi thanh toán", StatusShipper.doneShipCTT, 12);
      break;
    case StatusShipper.doneShipDTT:
      x = KeyValueThree('Đơn hàng đã thanh toán', "Đã thanh toán", StatusShipper.doneShipCTT, 11);
      break;
    case StatusShipper.cancelShip:
      x = KeyValueThree('Đơn hàng đã bị huỷ', "Bị huỷ", StatusShipper.cancelShip, 7);

    case StatusShipper.pendingPayment:
      x = KeyValueThree('Đơn hàng đang thanh toán', "Đang thanh toán", StatusShipper.pendingPayment, 15);
      break;
    default:
      x = KeyValueThree('khác', "khác", StatusShipper.notFound, -1);
      break;
  }
  return x;
}

Color getStatusColor(int status) {
  switch (status) {
    case 1:
      return AppStyle.primaryGray_999999;
    case 3:
      return AppStyle.primaryYellowFAAD14;
    case 4:
      return AppStyle.primaryOrangeFA541C;
    case 5:
      return AppStyle.primaryRedEB2F96;
    case 7:
      return AppStyle.primaryRedFF4D4F;
    case 11:
      return AppStyle.primaryBlue13C2C2;
    case 12:
      return AppStyle.primaryGreen52C41A;
    case 14:
      return AppStyle.primaryYellowFAAD14;
      case 15:
      return AppStyle.primaryYellowFA8C16;
    default:
      return AppStyle.primaryColor;
  }
}

class StatusColorModel {
  final Color color;
  final double number;

  StatusColorModel(this.color, this.number);
}

StatusColorModel getStatusColorAndNumber(int status) {
  switch (status) {
    case 1:
      return StatusColorModel(AppStyle.primaryColor, 0.0);
    case 3:
      return StatusColorModel(AppStyle.primaryColor, 0.2);
    case 4:
      return StatusColorModel(AppStyle.primaryColor, 0.5);
    case 5:
      return StatusColorModel(AppStyle.primaryRedEB2F96, 0.6);
    case 7:
      return StatusColorModel(AppStyle.primaryRedFF4D4F, 0.0);
    case 11:
      return StatusColorModel(AppStyle.primaryBlue13C2C2, 1);
    case 12:
      return StatusColorModel(AppStyle.primaryGreen52C41A, 0.8);
    case 14:
      return StatusColorModel(AppStyle.primaryYellowFAAD14, 0.0);
    case 15:
      return StatusColorModel(AppStyle.primaryYellowFA8C16, 0.9);
    default:
      return StatusColorModel(AppStyle.primaryColor, 0);
  }
}

Color getTagColor(int status) {
  switch (status) {
    case 1:
      return AppStyle.primaryGreen52C41A;
    case 2:
      return AppStyle.primaryYellowFAAD14;
    case 3:
      return AppStyle.primaryGray_999999;
    case 4:
      return AppStyle.primaryRedFF4D4F;
    case 5:
      return AppStyle.primaryOrangeFA541C;
    default:
      return AppStyle.primaryColor;
  }
}

Color getColorCircle(double status) {
  switch (status) {
    case <= 0.4:
      return AppStyle.primaryColor;
    case <= 0.6:
      return AppStyle.primaryYellowFADB14;
    case <= 0.8:
      return AppStyle.primaryYellowFAAD14;
    case <= 0.9:
      return AppStyle.primaryOrangeFA541C;
    case <= 1:
      return AppStyle.primaryGreen52C41A;
    case > 1:
      return AppStyle.primaryGreen52C41A;
    default:
      return AppStyle.primaryColor;
  }
}


Color getColorPayDebt(String status) {
  switch (status) {
    case "Công nợ chưa thanh toán":
      return AppStyle.primaryBlue13C2C2;
    case "Công nợ đang thanh toán":
      return AppStyle.primaryYellowFAAD14;
    case  "Công nợ đã thanh toán":
      return AppStyle.primaryGreen52C41A;

    default:
      return AppStyle.primaryColor;
  }
}


Color getColorCircleDebt(double status) {
  switch (status) {
    case <= 0.2:
      return AppStyle.primaryRedFF4D4F;
    case <= 0.4:
      return AppStyle.primaryYellowFA8C16;
    case <= 0.6:
      return AppStyle.primaryYellowFAAD14;
    case <= 0.8:
      return AppStyle.primaryGray_999999;
    case <= 1:
      return AppStyle.primaryGreen52C41A;
    case > 1:
      return AppStyle.primaryGreen52C41A;
    default:
      return AppStyle.primaryColor;
  }
}

T checkNull<T>(T? value, {required T defaultValue}) {
  return value ?? defaultValue;
}

String checkNullString(dynamic value) {
  return value?.toString() ?? "N/A";
}
