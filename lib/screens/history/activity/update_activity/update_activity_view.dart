import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart'; 
import '../../../../appColors/appColors.dart';
import 'update_activity_controller.dart';
import '../../../../loading/loading.dart';

class UpdateActivityView extends GetView<UpdateActivityController> {
  const UpdateActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), 
      appBar: AppBar(
        title: const Text("Options de modification", 
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
       
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(text: "Préparation des options...");
        }

        return Stack(
          children: [
            Positioned(
              top: -50, right: -50,
              child: CircleAvatar(radius: 100, backgroundColor: AppColors.generalColor.withOpacity(0.03)),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // En-tête textuel plus "Lifestyle"
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.generalColor.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(PhosphorIcons.gearSix(PhosphorIconsStyle.fill), 
                        color: AppColors.generalColor, size: 40),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      "Personnalisez votre commande",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF1A1A1A)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      "Modifiez vos articles ou ajustez les quantités avant la livraison.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.blueGrey, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Choix 1 : Changer la bouteille
                  _buildModernChoiceCard(
                    title: "Changer d'article",
                    subtitle: "Remplacer par un autre modèle",
                    icon: PhosphorIcons.shoppingCart(PhosphorIconsStyle.duotone),
                    color: AppColors.generalColor,
                    onTap: controller.chooseChangeBottle,
                  ),

                  const SizedBox(height: 20),

                  // Choix 2 : Modifier la quantité
                  _buildModernChoiceCard(
                    title: "Ajuster les quantités",
                    subtitle: "Ajouter ou retirer des unités",
                    icon: PhosphorIcons.plusMinus(PhosphorIconsStyle.duotone),
                    color: AppColors.generalColor,
                    onTap: controller.chooseChangeQuantity,
                  ),
                  
                  const Spacer(),
                  // Note d'aide en bas
                  Center(
                    child: Text(
                      "Une question ? Contactez le support",
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildModernChoiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Icône stylisée
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 20),
                // Textes
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, 
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF2D3436))
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle, 
                        style: const TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.w500)
                      ),
                    ],
                  ),
                ),
                // Flèche minimaliste
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}