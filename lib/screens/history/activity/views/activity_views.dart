import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // N'oublie pas l'import
import '../controllers/activity_controller.dart';
import '../../../../appColors/appColors.dart';
import '../../../../routes/app_routes.dart';

class ActivityScreen extends GetView<ActivityController> {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: controller.fetchOrders() est déjà dans le onInit du controller
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFD),
        appBar: AppBar(
          title: const Text(
            "Mes Commandes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade100, width: 1)),
              ),
              child: TabBar(
                labelColor: AppColors.generalColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.generalColor,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                tabs: const [
                  Tab(text: "En cours"),
                  Tab(text: "Historique"),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Get.toNamed(Routes.CALALOG),
          backgroundColor: AppColors.generalColor,
          icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
          label: const Text("Commander", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Obx(() => FutureBuilder<List<dynamic>?>(
          future: controller.futureCommandes.value,
          builder: (context, snapshot) {
            // ===== INTÉGRATION DU SPINKIT ICI =====
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitThreeBounce(
                      color: AppColors.generalColor,
                      size: 30,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Chargement des commandes...",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError || snapshot.data == null) {
              return _buildErrorState();
            }

            final allOrders = snapshot.data!;
            final activeOrders = allOrders.where((cmd) => 
              cmd['etat'] == "EN_ATTENTE" || cmd['etat'] == "EN_COURS").toList();
            
            final historyOrders = allOrders.where((cmd) => 
              cmd['etat'] == "LIVRE" || cmd['etat'] == "ANNULE").toList();

            return TabBarView(
              children: [
                _buildOrderList(activeOrders, true),
                _buildOrderList(historyOrders, false),
              ],
            );
          },
        )),
      ),
    );
  }

  // --- Tes méthodes existantes (Inchangées) ---
  Widget _buildOrderList(List<dynamic> orders, bool isActiveTab) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 60, color: Colors.grey.shade200),
            const SizedBox(height: 15),
            Text(
              isActiveTab ? "Aucune commande active" : "Historique vide",
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: controller.handleRefresh,
      color: AppColors.generalColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: orders.length,
        itemBuilder: (context, index) => _buildOrderCard(context, orders[index], isActiveTab),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> cmd, bool isActive) {
    String dateStr = cmd['created'] ?? DateTime.now().toIso8601String();
    String formattedDate = DateFormat('dd MMM yyyy • HH:mm').format(DateTime.parse(dateStr));
    List items = cmd['items'] ?? [];
    String produitName = items.isNotEmpty ? (items[0]['produit_name'] ?? "Bouteille de gaz") : "Bouteille de gaz";
    int quantite = items.isNotEmpty ? (items[0]['quantity'] ?? 0) : 0;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.ACTIVITYDETAIL, arguments: cmd),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 55, width: 55,
                  decoration: BoxDecoration(color: const Color(0xFF003317).withOpacity(0.06), borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.propane_tank, color: Color(0xFF003317), size: 28),
                ),
                Positioned(
                  top: -5, right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: AppColors.generalColor, shape: BoxShape.circle),
                    child: Text("x$quantite", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(produitName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                  Text(formattedDate, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text("${cmd['montant_total']} F CFA", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.generalColor)),
                ],
              ),
            ),
            _buildStatusBadge(cmd['etat']),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String etat) {
    Color color;
    switch (etat) {
      case "EN_ATTENTE": color = Colors.orange; break;
      case "LIVRE": color = const Color(0xFF00A86B); break;
      case "ANNULE": color = Colors.red; break;
      case "EN_COURS": color = Colors.blue; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
      child: Text(etat, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 10)),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.redAccent),
          const SizedBox(height: 10),
          const Text("Impossible de charger les commandes"),
          TextButton(onPressed: controller.handleRefresh, child: const Text("Réessayer"))
        ],
      ),
    );
  }
}