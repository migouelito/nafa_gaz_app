import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class OtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  late String phone;

  @override
  void onInit() {
    super.onInit();
    phone = Get.arguments?.toString() ?? "Inconnu";
  }

  void verifyOtp() {
    // ⚡ Changement ici : on vérifie 6 caractères
    if (otpController.text.length == 6) {
      print("Code valide, passage à l'étape suivante");
      Get.back();
      Get.back();
    } else {
      Get.snackbar(
        "Code incomplet", 
        "Veuillez saisir les 6 chiffres du code reçu.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    }
  }

  

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}