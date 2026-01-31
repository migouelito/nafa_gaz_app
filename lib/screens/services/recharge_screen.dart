import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'package:get/get.dart';
class RechargeScreen extends StatelessWidget {
  const RechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recharger ma bouteille")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sync, size: 80, color: Color(0xFF00A86B)),
            const SizedBox(height: 20),
            const Text("J'ai une bouteille vide,", style: TextStyle(fontSize: 18)),
            const Text("je veux la même pleine.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Redirige vers le catalogue (filtré idéalement sur la marque habituelle)
                Get.toNamed(Routes.CALALOG);
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), foregroundColor: Colors.white),
              child: const Text("CHOISIR MA BOUTEILLE"),
            )
          ],
        ),
      ),
    );
  }
}
