import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nafa_gaz_app/routes/app_routes.dart';
import '../../../alerte/alerte.dart';
import '../../../servicesApp/apiServices.dart';

class AuthController extends GetxController {
  final ApiService apiService = ApiService(); 

  final matriculeController = TextEditingController();
  final passwordController = TextEditingController();
  
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  var phoneError = RxnString();
  var passwordError = RxnString();

  @override
  void onInit() {
    super.onInit();
    matriculeController.addListener(() {
      if (phoneError.value != null) {
        phoneError.value = null;
      }
    });
    passwordController.addListener(() {
      if (passwordError.value != null) {
        passwordError.value = null;
      }
    });
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  bool validateFields() {
    bool isValid = true;
    String phone = matriculeController.text.trim();
    String pass = passwordController.text.trim();

    if (phone.isEmpty) {
      phoneError.value = "Veuillez entrer votre numéro de téléphone";
      isValid = false;
    } else if (phone.length < 8) {
      phoneError.value = "Le matricule doit contenir au moins 8 chiffres";
      isValid = false;
    }

    if (pass.isEmpty) {
      passwordError.value = "Veuillez entrer votre mot de passe";
      isValid = false;
    } else if (pass.length < 4) {
      passwordError.value = "Le mot de passe doit faire au moins 4 caractères";
      isValid = false;
    }

    return isValid;
  }

  Future<void> login() async {
    if (!validateFields()) return;

    try {
      isLoading.value = true;
      final dataconnexion = {
        "phone": "+226${matriculeController.text.trim().toUpperCase()}",
        "password": passwordController.text.trim(),
      };
      final result = await apiService.login(dataconnexion);

      if (result) {
        isLoading.value = false;
        Get.offAllNamed(Routes.HOMEMAIN);
      } else {
        isLoading.value = false;
        Alerte.show(
          title: "Erreur d'authentification",
          message: "Matricule ou mot de passe incorrect",
          imagePath: "assets/images/error.png",
          color: Colors.red,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Alerte.show(
        title: "Erreur de connexion",
        message: "Problème de communication avec le serveur.",
        imagePath: "assets/images/error.png",
        color: Colors.red,
      );
    }
  }

  @override
  void onClose() {
    matriculeController.dispose();
    passwordController.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }
}