import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';

class SignupController extends GetxController {
  final TextEditingController phoneController = TextEditingController();

  void verifyPhone() {
    String phone = phoneController.text.trim();
    if (phone.isNotEmpty) {
      Get.toNamed(Routes.SIGNINOTP);
    } else {
      Get.snackbar(
        "Erreur", 
        "Veuillez entrer un numéro de téléphone valide",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
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