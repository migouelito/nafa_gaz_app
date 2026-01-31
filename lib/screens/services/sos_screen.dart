import 'package:flutter/material.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("SOS & Accessoires"),
          bottom: const TabBar(
            labelColor: Color(0xFF00A86B),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFF00A86B),
            tabs: [
              Tab(icon: Icon(Icons.build), text: "Dépannage"),
              Tab(icon: Icon(Icons.shopping_bag), text: "Boutique"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ONGLET 1 : DÉPANNAGE (SOS)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTechCard(context, "Fuite de Gaz", "Intervention urgente (-30min)", Icons.warning, Colors.red),
                  _buildTechCard(context, "Installation Cuisinière", "Raccordement sécurisé", Icons.kitchen, Colors.blue),
                  _buildTechCard(context, "Diagnostic Sécurité", "Vérification complète", Icons.shield, Colors.green),
                ],
              ),
            ),

            // ONGLET 2 : BOUTIQUE ACCESSOIRES
            GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(15),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.8,
              children: [
                _buildShopItem("Détendeur Standard", "2500 F", Icons.settings_input_component),
                _buildShopItem("Tuyau Blindé (1.5m)", "1500 F", Icons.cable),
                _buildShopItem("Collier de serrage", "200 F", Icons.circle_outlined),
                _buildShopItem("Brûleur Rapide", "4000 F", Icons.local_fire_department),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET TECHNICIEN
  Widget _buildTechCard(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Recherche d'un technicien...")));
          },
          style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, minimumSize: const Size(80, 30)),
          child: const Text("APPELER"),
        ),
      ),
    );
  }

  // WIDGET BOUTIQUE
  Widget _buildShopItem(String name, String price, IconData icon) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.blueGrey),
          const SizedBox(height: 10),
          Text(name, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(price, style: const TextStyle(color: Color(0xFF00A86B), fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: (){}, 
            style: ElevatedButton.styleFrom(minimumSize: const Size(80, 30)),
            child: const Text("Ajouter")
          )
        ],
      ),
    );
  }
}
