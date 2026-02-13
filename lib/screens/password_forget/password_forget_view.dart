import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'password_forget_controller.dart';
import '../../appColors/appColors.dart';

class PasswordForgetView extends GetView<ForgotPasswordController> {
  const PasswordForgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Récupération de mot de passe",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Code PIN oublié ?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "Entrez votre numéro de téléphone pour réinitialiser votre PIN.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),

            // Champ Téléphone
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: _buildInputDecoration(
                label: "Numéro de téléphone",
                hint: "Ex: 01020304",
                icon: Icons.phone_android,
              ),
            ),

            // Ce widget prend tout l'espace vide pour pousser le bouton vers le bas
            const Spacer(), 

            // Bouton maintenant tout en bas
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => controller.sendOtp(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.generalColor,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("ENVOYER LE CODE",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            // Petit espace de sécurité pour ne pas coller au bord du téléphone
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      hintText: hint,
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.generalColor, size: 20),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: AppColors.generalColor.withOpacity(0.5), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.generalColor, width: 1.5),
      ),
      labelStyle: TextStyle(
          color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w600),
      floatingLabelStyle: TextStyle(
          color: AppColors.generalColor,
          fontWeight: FontWeight.w700,
          fontSize: 13),
    );
  }
}