import 'package:flutter/material.dart';

class SwapScreen extends StatelessWidget {
  const SwapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Échanger de marque")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Quelle bouteille vide avez-vous ?", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              items: ["TotalEnergies", "Sodigaz", "Oryx"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {},
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Marque actuelle"),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.arrow_downward, color: Colors.grey),
            const SizedBox(height: 20),
            const Text("Quelle marque voulez-vous ?", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
             DropdownButtonFormField<String>(
              items: ["TotalEnergies", "Sodigaz", "Oryx"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) {},
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Nouvelle marque"),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(15),
              color: Colors.orange.shade50,
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange),
                  SizedBox(width: 10),
                  Expanded(child: Text("Des frais d'échange de 1000F à 5000F peuvent s'appliquer selon les marques.")),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {}, // Logique à venir
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), foregroundColor: Colors.white),
                child: const Text("ESTIMER L'ÉCHANGE"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
