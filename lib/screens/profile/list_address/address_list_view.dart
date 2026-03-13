import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'address_controller.dart';
import '../../../routes/app_routes.dart'; 
import '../../../appColors/appColors.dart';
import '../../../loading/loading.dart';
import '../../../questionModal/questionModal.dart'; 
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddressListView extends GetView<AddressListController> {
  const AddressListView({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.generalColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("Mes Adresses", 
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(text: "Chargement des lieux de livraison...");
        }

        return controller.addresses.isEmpty 
          ? _buildEmptyState() 
          : RefreshIndicator(
              onRefresh: controller.refreshAddresses,
              color: primaryColor,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.addresses.length,
                itemBuilder: (context, index) {
                  final addr = controller.addresses[index];
                  return _buildAddressCard(addr, index, primaryColor);
                },
              ),
            );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var result = await Get.toNamed(Routes.ADDADDRESS);
          if (result == true) {
            controller.refreshAddresses();
          }
        },
        backgroundColor: primaryColor,
        elevation: 4,
        icon: Icon(
      PhosphorIcons.mapPinPlus(PhosphorIconsStyle.regular), 
      color: Colors.white,
    ),
        label: const Text("NOUVELLE ADRESSE", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
      ),
    );
  }

  Widget _buildAddressCard(dynamic addr, int index, Color primaryColor) {
    final String name = addr['name'] ?? "Sans nom";
    final String details = addr['address'] ?? "Aucune adresse précisée";
    final bool isDefault = addr['is_default'] == 1 || addr['is_default'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDefault ? Border.all(color: primaryColor.withOpacity(0.5), width: 1.5) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDefault ? primaryColor : primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
         child: Icon(
          PhosphorIcons.mapPin(PhosphorIconsStyle.regular), 
          color: isDefault ? Colors.white : primaryColor,
          size: 24,
        ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                name.toUpperCase(), 
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5)
              ),
            ),
            if (isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                child: Text("DÉFAUT", style: TextStyle(color: primaryColor, fontSize: 8, fontWeight: FontWeight.bold)),
              )
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            details, 
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            PhosphorIcons.trash(PhosphorIconsStyle.regular), 
            color: Colors.redAccent,
          ), 
         onPressed: () => _confirmDeletion(index, name),
        ),
      ),
    );
  }

  // --- INTEGRATION DE VOTRE DIALOGLOGOUT ---
    void _confirmDeletion(int index, String name) {
      DialogLogout.show(
        title: "Supprimer l'adresse ?",
        message: "Voulez-vous vraiment retirer $name de vos lieux de livraison ?",
        color: AppColors.generalColor,
        imagePath: "assets/images/logout.png",
        onConfirm: () {
          controller.removeAddress(index);
        },
      );
    }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: Icon(Icons.map_outlined, size: 60, color: Colors.grey[400]),
          ),
          const SizedBox(height: 20),
          const Text("Aucune adresse enregistrée", 
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          const Text("Ajoutez une adresse pour faciliter vos livraisons", 
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}