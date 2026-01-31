import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'siginup_controller.dart';
import '../../../../appColors/appColors.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,       
        title: const Text(
          "Inscription",
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            color: Colors.black,
          ),
        ),
      ),
      // Le bouton est placé ici pour qu'il "colle" au clavier
      bottomNavigationBar: _buildBottomAction(),
      body: SingleChildScrollView( // Utilisation d'un scroll pour éviter les erreurs d'overflow
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            const Text(
              "Entrez votre numéro de téléphone pour recevoir un code de validation par SMS.",
              style: TextStyle(color: Colors.grey, fontSize: 15, height: 1.5),
            ),
            
            const SizedBox(height: 45),

            // Champ de saisie moderne
            _buildPhoneField(),
            
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }

  // Widget séparé pour l'action en bas
  Widget _buildBottomAction() {
    return Padding(
      // ViewInsets.bottom permet de suivre exactement la hauteur du clavier
      padding: EdgeInsets.only(
        left: 25, 
        right: 25, 
        bottom: Get.context!.mediaQueryViewInsets.bottom > 0 ? 15 : 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSubmitButton(),
      
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.generalColor.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        autofocus: true, // Focus automatique pour faire monter le bouton immédiatement
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle( fontSize: 17),
        decoration: InputDecoration(
          labelText: "Numéro de téléphone",
          hintText: "70 00 00 00",
          prefixIcon: Icon(
            Icons.phone_android,
            color: AppColors.generalColor,
            size: 22,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          floatingLabelStyle: TextStyle(
            color: AppColors.generalColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.generalColor, width: 2),
          ),
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: controller.verifyPhone,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.generalColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0, 
        ),
        child: const Text(
          "VÉRIFIER LE NUMÉRO",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
        ),
      ),
    );
  }
}