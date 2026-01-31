import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../appColors/appColors.dart';
import 'update_activity_controller.dart';

class UpdateActivityView extends GetView<UpdateActivityController> {
  const UpdateActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Modifier la commande", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        // Écran blanc/chargement au début
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Que souhaitez-vous modifier ?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF003317)),
              ),
              const SizedBox(height: 10),
              const Text(
                "Choisissez une option pour mettre à jour votre commande en cours.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Option 1 : Changer la bouteille
              _buildChoiceCard(
                title: "Changer de bouteille",
                subtitle: "Sélectionner un autre modèle ou une autre marque",
                icon: Icons.sync_alt_rounded,
                onTap: controller.chooseChangeBottle,
              ),

              const SizedBox(height: 20),

              // Option 2 : Modifier la quantité
              _buildChoiceCard(
                title: "Modifier le nombre",
                subtitle: "Augmenter ou réduire le nombre de bouteilles",
                icon: Icons.format_list_numbered_rounded,
                onTap: controller.chooseChangeQuantity,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildChoiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.generalColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.generalColor, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}