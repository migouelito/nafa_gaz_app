import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Pour lancer les appels/mails
import '../../appColors/appColors.dart';
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  // Fonctions d'action
  void _callSupport() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '8842'); // Numéro court fictif
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }

  void _whatsappSupport() async {
    // Lien WhatsApp API
    final Uri launchUri = Uri.parse('https://wa.me/22670000000');
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aide & Support"),
        backgroundColor:AppColors.generalColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER CONTACT
            Container(
              padding: const EdgeInsets.all(30),
              color: AppColors.generalColor,
              width: double.infinity,
              child: Column(
                children: [
                  const Text("Besoin d'aide ?", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Notre équipe est disponible 7j/7 de 7h à 22h.", style: TextStyle(color: Colors.white70), textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildContactBtn(Icons.phone, "Appeler", _callSupport),
                      const SizedBox(width: 20),
                      _buildContactBtn(Icons.chat, "WhatsApp", _whatsappSupport),
                    ],
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // FAQ RAPIDE
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(alignment: Alignment.centerLeft, child: Text("Questions Fréquentes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ),
            
            _buildFaqTile("Comment changer ma bouteille ?", "Lors de la commande, sélectionnez 'Échange de marque'. Une caution peut s'appliquer."),
            _buildFaqTile("Quels sont les frais de livraison ?", "La livraison standard est à 1500 F CFA pour les bouteilles de 12kg."),
            _buildFaqTile("Le livreur est en retard", "Vous pouvez suivre sa position en temps réel ou l'appeler directement depuis l'écran de suivi."),
            
            const SizedBox(height: 20),
            
            // FORMULAIRE SIGNALEMENT
            Padding(
              padding: const EdgeInsets.all(20),
              child: OutlinedButton.icon(
                onPressed: () {}, 
                icon: const Icon(Icons.bug_report, color: Colors.red),
                label: const Text("Signaler un problème technique", style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContactBtn(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: AppColors.generalColor),
      label: Text(label, style: TextStyle(color:  AppColors.generalColor, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
    );
  }

  Widget _buildFaqTile(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: const TextStyle(color: Colors.grey)),
        )
      ],
    );
  }
}
