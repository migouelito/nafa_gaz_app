import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'activity_detail_controller.dart'; 
import '../../../appColors/appColors.dart';
import '../../../questionModal/questionModal.dart';
import '../../../routes/app_routes.dart';

class ActivityDetailView extends GetView<ActivityDetailController> {
  const ActivityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text("Détails de la Commande", 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.order.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusHeader(),
              const SizedBox(height: 20),
              
              _buildSectionHeader("Articles commandés", PhosphorIcons.package()),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) => _buildProductItemCard(controller.items[index]),
                ),
              ),
              
              const SizedBox(height: 20),
              _buildSectionHeader("Récapitulatif financier", PhosphorIcons.creditCard()),
              _buildFinanceCard(),

              const SizedBox(height: 20),
              _buildSectionHeader("Informations de livraison", PhosphorIcons.mapPin()),
              _buildDeliveryCard(),
              const SizedBox(height: 10),
            ],
          ),
        );
      }),

      // BOUTONS FLOTTANTS (Style Mouvement)
      floatingActionButton: Obx(() {
        if (!controller.canModify) return const SizedBox.shrink();
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // BOUTON ANNULER (Rouge)
            FloatingActionButton(
              heroTag: "fabCancel",
              mini: true,
              backgroundColor: Colors.red,
              onPressed: () {
                DialogLogout.show(
                  title: "Annuler ?",
                  message: "Voulez-vous vraiment annuler cette commande ?",
                  imagePath: "assets/images/error.png",
                  color: Colors.red,
                  onConfirm: () => controller.cancelCommande(),
                );
              },
              child: Icon(PhosphorIcons.xCircle(), color: Colors.white, size: 20),
            ),
            const SizedBox(height: 12),
            // BOUTON MODIFIER (Bleu)
            FloatingActionButton(
              heroTag: "fabEdit",
              mini: true,
              backgroundColor: AppColors.generalColor,
              onPressed: () {
                final orderId = controller.order['id'];
                Get.toNamed(Routes.ACTIVITYUPDATE, arguments: orderId);
              },
              child: Icon(PhosphorIcons.pencilSimple(), color: Colors.white, size: 20),
            ),
          ],
        );
      }),
    );
  }

  // --- COMPOSANTS UI RÉVISÉS ---

  Widget _buildSectionHeader(String t, IconData i) => Padding(
    padding: const EdgeInsets.only(bottom: 10, left: 4),
    child: Row(children: [
      Icon(i, size: 14, color: Colors.blueGrey),
      const SizedBox(width: 6),
      Text(t.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.blueGrey))
    ]),
  );

  Widget _buildStatusHeader() {
    String etat = controller.order['etat'] ?? "INCONNU";
    Color statusColor = _getStatusColor(etat);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor, 
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: statusColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))]
      ),
      child: Column(
        children: [
          Text(etat.replaceAll("_", " "), 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 5),
          Text(controller.formattedDate, 
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildProductItemCard(Map<String, dynamic> item) {
    final double prixUnitaire = double.tryParse(item['prix_unitaire']?.toString() ?? "0") ?? 0;
    final int quantite = int.tryParse(item['quantity']?.toString() ?? "0") ?? 0;
    final double sousTotal = prixUnitaire * quantite;
    
    // Récupération et formatage du type de commerce
    final String typeCommerce = item['type_commerce']?.toString().toUpperCase() ?? "VENTE";

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icône avec badge de quantité
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 50, width: 50,
                decoration: BoxDecoration(
                  color: AppColors.generalColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(PhosphorIcons.package(), color: AppColors.generalColor),
              ),
              Positioned(
                top: -5, right: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                  child: Text("x$quantite", style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['produit_name'] ?? "Produit", 
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 4),
                                Row(
                  children: [
                    _buildTypeBadge(typeCommerce), // Notre nouveau badge
                    const SizedBox(width: 8),
                    Text("${prixUnitaire.toInt()} F / unité", 
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Text("${sousTotal.toInt()} F", 
              style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.generalColor, fontSize: 14)),
        ],
      ),
    );
  }

  // Widget pour afficher le petit badge (Vente, Recharge, etc.)
  Widget _buildTypeBadge(String type) {
    Color color;
    String label;

    switch (type) {
      case "RECHARGE":
        color = Colors.green;
        label = "RECHARGE";
        break;
      case "ECHANGE":
        color = Colors.orange;
        label = "ÉCHANGE";
        break;
      default:
        color = Colors.blue;
        label = "VENTE";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2))
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildFinanceCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildInfoRow(PhosphorIcons.truck(), "Frais de livraison", "${controller.order['prix_livraison']} F"),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("TOTAL À PAYER", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.blueGrey)),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildInfoRow(PhosphorIcons.user(), "Client", controller.order['customer_name']),
          const Divider(),
          _buildInfoRow(PhosphorIcons.mapPin(), "Adresse", "Livraison à domicile"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey.shade300, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
              Text(value ?? "N/A", style: const TextStyle(color: Color(0xFF2D3436), fontWeight: FontWeight.w700, fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String etat) {
    switch (etat) {
      case "EN_ATTENTE": return AppColors.generalColor;
      case "LIVRE": return AppColors.generalColor;
      case "ANNULE": return Colors.red;
      case "EN_COURS": return AppColors.generalColor;
      default: return Colors.grey;
    }
  }
}