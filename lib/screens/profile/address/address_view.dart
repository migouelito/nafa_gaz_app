import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nafa_gaz_app/appColors/appColors.dart';
import 'address_controller.dart';

class AddAddressView extends GetView<AddAddressController> {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.generalColor,
        title: const Text(
          "Nouvelle Adresse",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Obx(() => FlutterMap(
                      mapController: controller.mapController,
                      options: MapOptions(
                          initialCenter: controller.center.value,
                          initialZoom: 15.0),
                      children: [
                        TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                      ],
                    )),
                const Center(
                    child: Icon(Icons.location_pin,
                        color: Color(0xFFFF5722), size: 50)),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Obx(() => FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: () =>
                            controller.checkAndGetLocation(() => _showGpsDialog(context)),
                        child: controller.gettingLocation.value
                            ? const Padding(
                                padding: EdgeInsets.all(15),
                                child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.gps_fixed, color: Colors.blue),
                      )),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: _buildForm(context),
          )
        ],
      ),
      // ⚡ LE BOUTON EST MAINTENANT FIXÉ EN BAS ICI
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () => Get.back(),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.generalColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          child: const Text("ENREGISTRER CETTE ADRESSE", 
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _showGpsDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text("GPS Requis"),
        content: const Text("Activez le GPS pour une livraison précise."),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Geolocator.openLocationSettings();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A86B),
                foregroundColor: Colors.white),
            child: const Text("ACTIVER"),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Confirmer la position",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
                controller: controller.nameController,
                decoration: const InputDecoration(
                    labelText: "Nom du lieu",
                    prefixIcon: Icon(Icons.bookmark_border),
                    border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(
                controller: controller.detailsController,
                decoration: const InputDecoration(
                    labelText: "Précisions",
                    prefixIcon: Icon(Icons.notes),
                    border: OutlineInputBorder())),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}