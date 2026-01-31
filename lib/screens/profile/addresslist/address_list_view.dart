import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'address_controller.dart';
import '../../../routes/app_routes.dart'; 
import '../../../appColors/appColors.dart';

class AddressListView extends GetView<AddressListController> {
  const AddressListView({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor =AppColors.generalColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Adresses", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() => controller.addresses.isEmpty 
        ? _buildEmptyState() 
        : ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: controller.addresses.length,
            itemBuilder: (context, index) {
              final addr = controller.addresses[index];
              return _buildAddressCard(addr, index, primaryColor);
            },
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.ADDADDRESS), // Utilisation de Get.toNamed
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add_location_alt, color: Colors.white),
        label: const Text("Ajouter une adresse", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAddressCard(Map<String, String> addr, int index, Color primaryColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: primaryColor.withOpacity(0.1),
          child: Icon(
            addr['type'] == 'Domicile' ? Icons.home_rounded : Icons.work_rounded, 
            color: primaryColor
          ),
        ),
        title: Text(addr['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(addr['details']!, style: TextStyle(color: Colors.grey.shade600)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
          onPressed: () => controller.removeAddress(index),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 15),
          const Text("Aucune adresse enregistrée", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}