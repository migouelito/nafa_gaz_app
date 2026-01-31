import 'package:flutter/material.dart';
import '../tracking/tracking_screen.dart'; // Lien vers le tracking

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const CheckoutScreen({super.key, required this.product});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String clientEmptyBottleBrand = "Sodigaz"; 
  int deliveryFee = 1500;
  int cautionAmount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.product['name'] != clientEmptyBottleBrand) {
      cautionAmount = 15000; 
    }
  }

  @override
  Widget build(BuildContext context) {
    int total = widget.product['price'] + deliveryFee + cautionAmount;

    return Scaffold(
      appBar: AppBar(title: const Text("Confirmation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // RÉCAP PRODUIT
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                  Icon(Icons.propane_tank, color: widget.product['color'], size: 40),
                  const SizedBox(width: 15),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("${widget.product['name']} ${widget.product['weight']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("${widget.product['price']} F CFA"),
                  ]),
              ]),
            ),
            const SizedBox(height: 20),
            
            // ADRESSE
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Row(children: const [
                  Icon(Icons.location_on, color: Color(0xFF00A86B)),
                  SizedBox(width: 10),
                  Expanded(child: Text("Maison (Patte d'oie), Rue 14.55")),
              ]),
            ),
             const SizedBox(height: 40),
             const Text("Total à payer", style: TextStyle(color: Colors.grey)),
             Text("$total F CFA", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xFF00A86B))),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
               // SIMULATION PAIEMENT RÉUSSI -> VERS TRACKING
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TrackingScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A86B), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
            child: const Text("PAYER ET SUIVRE MA LIVRAISON"),
          ),
        ),
      ),
    );
  }
}
