import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AddressListController extends GetxController {
  var addresses = <Map<String, String>>[
    {"name": "Maison", "details": "Patte d'oie, Rue 14.55, Porte 200", "type": "Domicile"},
    {"name": "Bureau", "details": "Ouaga 2000, Av. Pascal Zagré", "type": "Travail"},
  ].obs;

  var isLoading = false.obs;

  void removeAddress(int index) {
    addresses.removeAt(index);
    if (!Get.isSnackbarOpen) {
      Get.snackbar(
        "Suppression", 
        "L'adresse a été retirée de votre compte",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> refreshAddresses() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); 
    isLoading.value = false;
  }
}