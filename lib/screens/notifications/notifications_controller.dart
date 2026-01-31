import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  // Liste réactive (données brutes)
  var notifications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void fetchNotifications() {
    notifications.assignAll([
      {
        "title": "Promo Flash ⚡️",
        "body": "Profitez de -10% sur les recharges Oryx !",
        "time": "Il y a 20 min",
        "icon": Icons.local_offer,
        "color": Colors.orange,
        "isRead": false,
      },
      {
        "title": "Livreur en approche",
        "body": "Karim O. est à moins de 500m de votre domicile.",
        "time": "14:35",
        "icon": Icons.delivery_dining,
        "color": const Color(0xFF00A86B),
        "isRead": true,
      },
    ]);
  }

  void markAllAsRead() {
    for (var i = 0; i < notifications.length; i++) {
      var item = Map<String, dynamic>.from(notifications[i]);
      item['isRead'] = true;
      notifications[i] = item;
    }
    Get.snackbar("Succès", "Toutes les notifications sont lues");
  }
}