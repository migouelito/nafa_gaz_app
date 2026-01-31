import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Toutes les notifications marquées comme lues")));
            }, 
            child: const Text("Tout marquer comme lu", style: TextStyle(color: Color(0xFF00A86B)))
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _buildNotifItem(
            "Promo Flash ⚡️", 
            "Profitez de -10% sur les recharges Oryx aujourd'hui seulement !", 
            "Il y a 20 min", 
            Icons.local_offer, 
            Colors.orange,
            false // Non lu
          ),
          _buildNotifItem(
            "Livreur en approche", 
            "Karim O. est à moins de 500m de votre domicile.", 
            "14:35", 
            Icons.delivery_dining, 
            const Color(0xFF00A86B),
            true // Lu
          ),
          _buildNotifItem(
            "Bienvenue !", 
            "Merci d'avoir créé votre compte Nafa Gaz. N'oubliez pas de compléter votre profil.", 
            "Hier", 
            Icons.star, 
            Colors.blue,
            true // Lu
          ),
        ],
      ),
    );
  }

  Widget _buildNotifItem(String title, String body, String time, IconData icon, Color color, bool isRead) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : const Color(0xFF00A86B).withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: isRead ? Border.all(color: Colors.grey.shade200) : Border.all(color: const Color(0xFF00A86B).withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isRead ? Colors.black : const Color(0xFF00A86B))),
                    Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 5),
                Text(body, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
