import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'address_controller.dart';
import '../../../routes/app_routes.dart'; 
import '../../../appColors/appColors.dart';

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
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
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
        onPressed: () => Get.toNamed(Routes.ADDADDRESS),
        backgroundColor: primaryColor,
        elevation: 4,
        icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
        label: const Text("NOUVELLE ADRESSE", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
      ),
    );
  }

  Widget _buildAddressCard(Map<String, String> addr, int index, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            addr['type'] == 'Domicile' ? Icons.home_rounded : Icons.work_rounded, 
            color: primaryColor,
            size: 24,
          ),
        ),
        title: Text(
          addr['name']?.toUpperCase() ?? "", 
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5)
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            addr['details'] ?? "", 
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
          onPressed: () => _confirmDeletion(index),
        ),
      ),
    );
  }

  void _confirmDeletion(int index) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Supprimer ?", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Voulez-vous vraiment retirer cette adresse de votre liste ?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("ANNULER")),
          ElevatedButton(
            onPressed: () {
              controller.removeAddress(index);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("SUPPRIMER"),
          ),
        ],
      ),
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