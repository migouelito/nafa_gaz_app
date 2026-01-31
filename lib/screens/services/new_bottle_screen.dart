import 'package:flutter/material.dart';
import '../order/checkout_screen.dart'; // On réutilise le checkout existant

class NewBottleScreen extends StatelessWidget {
  const NewBottleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste des produits avec Prix TOTAL (Gaz + Caution)
    final List<Map<String, dynamic>> newKits = [
      {
        "name": "Sodigaz", 
        "weight": "12kg", 
        "gas_price": 7500, 
        "deposit_price": 15000, 
        "color": Colors.blue
      },
      {
        "name": "Sodigaz", 
        "weight": "6kg", 
        "gas_price": 2000, 
        "deposit_price": 10000, 
        "color": Colors.blue
      },
      {
        "name": "TotalEnergies", 
        "weight": "12kg", 
        "gas_price": 7500, 
        "deposit_price": 16000, 
        "color": Colors.orange
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Acheter un nouveau Kit")),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: newKits.length,
        itemBuilder: (context, index) {
          final kit = newKits[index];
          final total = kit['gas_price'] + kit['deposit_price'];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.propane_tank, size: 60, color: kit['color']),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Kit ${kit['name']} ${kit['weight']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(5)),
                              child: const Text("Bouteille neuve + Gaz inclus", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      Text("$total F", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF00A86B))),
                    ],
                  ),
                  const Divider(height: 30),
                  // Détail du prix pour transparence
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Gaz: ${kit['gas_price']} F  +  Caution: ${kit['deposit_price']} F", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ElevatedButton(
                        onPressed: () {
                          // On adapte l'objet pour le Checkout
                          final productForCheckout = {
                            "name": kit['name'],
                            "weight": kit['weight'],
                            "price": total, // Prix total
                            "color": kit['color'],
                            "is_new_kit": true // Flag pour le backend
                          };
                          Navigator.push(context, MaterialPageRoute(builder: (c) => CheckoutScreen(product: productForCheckout)));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), foregroundColor: Colors.white),
                        child: const Text("ACHETER"),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
