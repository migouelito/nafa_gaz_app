import 'package:flutter/material.dart';

class ProScreen extends StatelessWidget {
  const ProScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Espace Professionnel")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: const [
                  Icon(Icons.storefront, size: 40, color: Colors.blueGrey),
                  SizedBox(width: 15),
                  Expanded(child: Text("Maquis, Hôtels, Boulangeries : Commandez vos B36 ou lots de B12 ici.", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildProOption(context, "Commande de Gros", "Plus de 5 bouteilles", Icons.local_shipping),
            _buildProOption(context, "Demander un Devis", "Installation réseau gaz", Icons.description),
            _buildProOption(context, "Compte Facturation", "Paiement fin de mois", Icons.account_balance),
          ],
        ),
      ),
    );
  }

  Widget _buildProOption(BuildContext context, String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.blueGrey, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Service réservé aux comptes vérifiés.")));
        },
      ),
    );
  }
}
