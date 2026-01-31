import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../appColors/appColors.dart';
import 'package:flutter/services.dart';
import '../../../routes/app_routes.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ⚡ resizeToAvoidBottomInset à false permet d'éviter que le clavier ne pousse tout vers le haut et crée un overflow
      resizeToAvoidBottomInset: false, 
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.grey.shade50],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                const Spacer(flex: 1), // ⚡ Espace flexible en haut

                // --- LOGO ---
                _buildLogoSection(),
                
                const Text(
                  "L'ÉNERGIE QUI VOUS RAPPROCHE",
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1.5),
                ),

                const Spacer(flex: 2), // ⚡ Espace entre logo et titre

                Text(
                  "Bienvenue sur NAFAGAZ",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                ),
                const SizedBox(height: 5),
                const Text(
                "Commande de bouteilles simple, rapide et sûre ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.blueGrey),
                ),

                const Spacer(flex: 2),

                // Formulaire
                _buildModernField(child: _buildPhoneField()),
                const SizedBox(height: 15),
                _buildModernField(child: _buildPasswordField()),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => print("Mot de passe oublié"),
                    child: Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(color: AppColors.generalColor, fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Bouton Se connecter
                _buildSubmitButton(),

                const Spacer(flex: 2),

                // Connexion Biométrique
                _buildFingerprintAction(),

                const Spacer(flex: 2),

                // SECTION INSCRIPTION
                _buildRegisterLink(),
                
                const Spacer(flex: 1),
                
                _buildAppSource("By Elite IT Partners"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- COMPOSANTS OPTIMISÉS POUR L'ESPACE ---

  Widget _buildLogoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 60, width: 60, // ⚡ Taille réduite pour gagner de l'espace
          decoration: BoxDecoration(
            color: Colors.white, 
            shape: BoxShape.circle, 
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/nafagaz_truck_orange.png", fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.local_shipping, color: Color(0xFF003317), size: 30),
            ),
          ),
        ),
        const SizedBox(width: 12),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.0),
            children: [
              TextSpan(text: "NAFA", style: TextStyle(color: Color(0xFF003317))),
              TextSpan(text: "GAZ", style: TextStyle(color: Color(0xFFFF5722))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModernField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _buildPhoneField() {
    return TextField(
      controller: controller.matriculeController,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: _inputDecoration(label: "Téléphone", hint: "Numéro de téléphone", icon: Icons.phone_android),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() => TextField(
      controller: controller.passwordController,
      obscureText: controller.isPasswordHidden.value,
      decoration: _inputDecoration(
        label: "Mot de passe",
        hint: "••••••••",
        icon: Icons.lock_outline_rounded,
        suffix: IconButton(
          icon: Icon(controller.isPasswordHidden.value ? Icons.visibility_off : Icons.visibility, size: 20),
          onPressed: controller.togglePasswordVisibility,
        ),
      ),
    ));
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity, height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: const Color(0xFF003317).withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        onPressed: controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003317), foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text("Se connecter", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildFingerprintAction() {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Icon(Icons.fingerprint, color: AppColors.generalColor, size: 45),
          const SizedBox(height: 5),
          Text("Utiliser l'empreinte", style: TextStyle(color: Colors.grey[700], fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text("Pas de compte ?", style: TextStyle(color: Colors.grey, fontSize: 13)),
        TextButton(
          onPressed: () => Get.toNamed(Routes.SIGNINUP),
          child: Text("S'inscrire", style: TextStyle(color: AppColors.generalColor, fontWeight: FontWeight.w900, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildAppSource(String appSource) {
    return Text(appSource.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.w900, letterSpacing: 1.2));
  }

  InputDecoration _inputDecoration({required String label, required String hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      hintText: hint, labelText: label,
      prefixIcon: Icon(icon, color: AppColors.generalColor, size: 20),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.generalColor.withOpacity(0.5), width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.generalColor, width: 1.5)),
      labelStyle: TextStyle(color: Colors.grey[700], fontSize: 13, fontWeight: FontWeight.w600),
      floatingLabelStyle: TextStyle(color: AppColors.generalColor, fontWeight: FontWeight.w700, fontSize: 13),
    );
  }
}