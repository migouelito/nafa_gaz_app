import 'package:flutter/material.dart';
import 'otp_screen.dart'; // On réutilise l'OTP existant

class ForgotPinScreen extends StatefulWidget {
  const ForgotPinScreen({super.key});

  @override
  State<ForgotPinScreen> createState() => _ForgotPinScreenState();
}

class _ForgotPinScreenState extends State<ForgotPinScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Récupération du PIN"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Code PIN oublié ?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "Entrez votre numéro de téléphone. Nous allons vous envoyer un code pour réinitialiser votre PIN.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),
            
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Numéro de téléphone",
                prefixIcon: const Icon(Icons.phone_android),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_phoneController.text.length >= 8) {
                    // ON ENVOIE VERS L'ÉCRAN OTP
                    // L'écran OTP redirigera ensuite vers "CreatePinScreen" pour définir le NOUVEAU code.
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => OtpScreen(phone: _phoneController.text))
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Numéro invalide")));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B), 
                  foregroundColor: Colors.white
                ),
                child: const Text("ENVOYER LE CODE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
