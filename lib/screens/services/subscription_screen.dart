import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String frequency = "Chaque mois";
  String product = "Sodigaz 12kg";
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Planifier mes livraisons")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue.shade200)
              ),
              child: Row(
                children: const [
                  Icon(Icons.calendar_month, color: Colors.blue, size: 40),
                  SizedBox(width: 15),
                  Expanded(child: Text("Ne tombez plus jamais en panne ! Programmez vos livraisons.", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // FORMULAIRE
            const Text("Je veux recevoir :", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: product,
              items: ["Sodigaz 12kg", "Total 12kg", "Oryx 12kg", "Sodigaz 6kg"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => product = v!),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            const Text("Fréquence :", style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: frequency,
              items: ["Chaque semaine", "Chaque 2 semaines", "Chaque mois", "Tous les 2 mois"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => frequency = v!),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            
            const SizedBox(height: 20),
            
            SwitchListTile(
              title: const Text("Activer l'abonnement automatique", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Paiement automatique via Portefeuille"),
              value: isActive,
              activeColor: const Color(0xFF00A86B),
              onChanged: (v) => setState(() => isActive = v),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Abonnement enregistré !"), backgroundColor: Colors.green));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
                child: const Text("VALIDER LA PLANIFICATION"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
