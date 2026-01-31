import 'package:flutter/material.dart';
import 'create_pin_screen.dart';

class OtpScreen extends StatelessWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: Colors.black),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text("Code de validation", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text("Envoyé au $phone", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            // Champ Code simplifié
            const TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 4,
              style: TextStyle(fontSize: 24, letterSpacing: 10, fontWeight: FontWeight.bold),
              decoration: InputDecoration(hintText: "----", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // VALIDATION RÉUSSIE -> CRÉATION DU PIN
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CreatePinScreen()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), foregroundColor: Colors.white),
                child: const Text("VALIDER"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
