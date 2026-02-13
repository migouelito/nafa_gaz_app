import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final phoneController = TextEditingController();

  void sendOtp() {
    String phone = phoneController.text.trim();
    
    if (phone.length >= 8) {
      // On passe le numéro à l'écran suivant via les arguments
      Get.toNamed('/otp', arguments: phone);
    } else {
      Get.snackbar(
        "Erreur",
        "Veuillez entrer un numéro valide",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}