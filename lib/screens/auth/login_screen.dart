import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'signup_screen.dart';
import 'forgot_pin_screen.dart'; 
import '../../main_layout.dart';
import '../../routes/app_routes.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      setState(() => _canCheckBiometrics = canAuthenticateWithBiometrics);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _authenticate() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Authentification Nafa Gaz',
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
      if (didAuthenticate) _goToHome();
    } catch (e) {
      print("Erreur bio: $e");
    }
  }

  void _goToHome() {
    Get.offAllNamed(Routes.HOMEMAIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
        child: Column(
          children: [
            const Icon(Icons.local_gas_station_rounded, size: 80, color: Color(0xFF00A86B)),
            const SizedBox(height: 20),
            const Text("Connexion", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Téléphone",
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: "Code PIN (4 chiffres)",
                counterText: "",
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // LIEN "PIN OUBLIÉ" CLIQUABLE
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // NAVIGATION VERS LA RÉCUPÉRATION
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const ForgotPinScreen()));
                },
                child: const Text("PIN oublié ?", style: TextStyle(color: Colors.grey)),
              ),
            ),
            
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _goToHome, 
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), foregroundColor: Colors.white),
                child: const Text("SE CONNECTER"),
              ),
            ),

            const SizedBox(height: 30),

            if (_canCheckBiometrics)
              GestureDetector(
                onTap: _authenticate,
                child: Column(
                  children: const [
                    Icon(Icons.fingerprint, size: 60, color: Color(0xFF00A86B)),
                    SizedBox(height: 5),
                    Text("Connexion par empreinte", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

            const SizedBox(height: 40),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Pas encore de compte ?"),
                TextButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SignupScreen())),
                  child: const Text("S'inscrire", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00A86B))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
