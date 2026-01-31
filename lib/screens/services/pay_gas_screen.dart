import 'package:flutter/material.dart';

class PayGasScreen extends StatelessWidget {
  const PayGasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payer pour un proche")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("À qui voulez-vous envoyer du gaz ?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Numéro du bénéficiaire",
                prefixIcon: const Icon(Icons.contact_phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: const Icon(Icons.contacts),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Le bénéficiaire recevra un code SMS pour se faire livrer gratuitement.", style: TextStyle(color: Colors.grey)),
            const Spacer(),
             SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), foregroundColor: Colors.white),
                child: const Text("CHOISIR LA BOUTEILLE À OFFRIR"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
