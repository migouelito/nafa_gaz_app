import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Canpop {
  /// Pop multiple pages en utilisant Get
  static void popMultiple(int count) {
    for (int i = 0; i < count; i++) {
      if (Navigator.canPop(Get.context!)) {
        Get.back();
      } else {
        break;
      }
    }
  }
}