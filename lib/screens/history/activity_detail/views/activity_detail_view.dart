import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/activity_detail_controller.dart'; 
import '../../../../appColors/appColors.dart';
import '../../../../questionModal/questionModal.dart';
import '../../../../routes/app_routes.dart';

class ActivityDetailView extends GetView<ActivityDetailController> {
  const ActivityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFD),
      appBar: AppBar(
        title: const Text("Détail de la Commande", 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          // CRAYON DE MODIFICATION (visible seulement si EN_ATTENTE)
          Obx(() => controller.canModify 
            ? IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey),
                onPressed: () {
                  final orderId=controller.order['id'];
                  Get.toNamed(Routes.ACTIVITYUPDATE,arguments: orderId);
                },
              ) 
            : const SizedBox()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.order.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchCommandeDetail(),
                color: AppColors.generalColor,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusHeader(),
                      const SizedBox(height: 25),
                      
                      _buildSectionTitle("Détails des articles"),
                      ...controller.items.map((item) => _buildProductItemCard(item)).toList(),
                      
                      const SizedBox(height: 25),
                      
                      _buildSectionTitle("Récapitulatif financier"),
                      _buildFinanceCard(),

                      const SizedBox(height: 25),
                      
                      _buildSectionTitle("Informations de livraison"),
                      _buildDeliveryCard(),
                    ],
                  ),
                ),
              ),
            ),
            // BOUTON ANNULER EN BAS (visible seulement si EN_ATTENTE)
            _buildCancelButton(),
          ],
        );
      }),
    );
  }

  // --- COMPOSANTS UI ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, 
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
    );
  }

  Widget _buildStatusHeader() {
    String etat = controller.order['etat'] ?? "INCONNU";
    Color statusColor = _getStatusColor(etat);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(etat.replaceAll("_", " "), 
            style: TextStyle(color: statusColor, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 5),
          Text(controller.formattedDate, 
            style: const TextStyle(color: Colors.blueGrey, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildProductItemCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF003317).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.propane_tank, color: Color(0xFF003317), size: 28),
              ),
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.generalColor, 
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "x${item['quantity'] ?? 0}",
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['produit_name'] ?? "Produit", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  "Prix unitaire : ${item['prix_unitaire']} F", 
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildRow("Prix Livraison", "${controller.order['prix_livraison']} F"),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Payé", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              Text("${controller.order['montant_total']} F CFA", 
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          const Icon(Icons.person_pin_circle, color: Color(0xFFFF5722), size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.order['customer_name'] ?? "Client", 
                  style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text("Adresse de livraison par défaut", 
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildCancelButton() {
    return Obx(() {
      // On affiche le bouton uniquement si la commande est modifiable (EN_ATTENTE)
      if (!controller.canModify) return const SizedBox.shrink();
      
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          // Optionnel : petite bordure haute pour séparer du reste
          border: Border(top: BorderSide(color: Color(0xFFF1F1F1), width: 1)),
        ),
        child: SizedBox(
          height: 55,
          child: OutlinedButton.icon(
            onPressed: () {
              DialogLogout.show(
                title: "Annuler la commande ?",
                message: "Voulez-vous vraiment annuler cette commande ?",
                imagePath: "assets/images/error.png",
                color: Colors.red,
                onConfirm: () => controller.cancelCommande(),
              );
            },
            // LA CROIX ROUGE
            icon: const Icon(Icons.close_rounded, color: Colors.red, size: 22),
            // LE TEXTE ROUGE
            label: const Text(
              "ANNULER LA COMMANDE", 
              style: TextStyle(
                color: Colors.red, 
                fontWeight: FontWeight.w900, 
                fontSize: 13,
                letterSpacing: 0.8
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white, // FOND BLANC
              side: const BorderSide(color: Colors.red, width: 1.5), // BORDURE ROUGE
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
      ],
    );
  }

  Color _getStatusColor(String etat) {
    switch (etat) {
      case "EN_ATTENTE": return Colors.orange;
      case "LIVRE": return Colors.green;
      case "ANNULE": return Colors.red;
      case "EN_COURS": return Colors.blue;
      default: return Colors.grey;
    }
  }
}