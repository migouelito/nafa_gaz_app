import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sécurité du compte"), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text("Définissez votre Code PIN", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Ce code à 4 chiffres sécurisera votre compte.", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
            const SizedBox(height: 30),

            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(labelText: "Nouveau PIN", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(labelText: "Confirmer le PIN", border: OutlineInputBorder()),
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (_pinController.text.length == 4 && _pinController.text == _confirmController.text) {
            Get.offAllNamed(Routes.LOGIN);
                  } else {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Les codes ne correspondent pas.")));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), foregroundColor: Colors.white),
                child: const Text("FINALISER L'INSCRIPTION"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
