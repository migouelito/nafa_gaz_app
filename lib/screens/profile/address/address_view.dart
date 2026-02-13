import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'address_controller.dart';
import 'package:nafa_gaz_app/appColors/appColors.dart';

class AddAddressView extends GetView<AddAddressController> {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showBeautifulGpsSheet();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Précisez votre emplacement", 
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Obx(() => FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    initialCenter: controller.center.value,
                    initialZoom: 18.0,
                    maxZoom: 20,
                    onPositionChanged: (MapCamera camera, bool hasGesture) {
                      if (hasGesture) controller.center.value = camera.center;
                    },
                  ),
                  children: [
                    TileLayer(
                      // Utilisation des tuiles Google Roadmap pour une précision maximale sur les commerces/POI
                      urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                      userAgentPackageName: 'com.example.nafa_gaz_app',
                    ),
                  ],
                )),
                
                // Pin central avec label dynamique
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)]),
                          child: const Text("DÉPOSER ICI",
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 2),
                        Icon(Icons.location_on, color: AppColors.generalColor, size: 55),
                      ],
                    ),
                  ),
                ),

                // Bouton Ma Position
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    elevation: 4,
                    onPressed: () => controller.getCurrentLocation(),
                    child: Obx(() => controller.gettingLocation.value
                        ? const CircularProgressIndicator(strokeWidth: 2)
                        : Icon(Icons.my_location, color: AppColors.generalColor)),
                  ),
                ),
              ],
            ),
          ),
          
          // Formulaire de détails
          Expanded(
            flex: 2,
            child: _buildForm(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15)],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Informations de livraison",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
            const SizedBox(height: 20),
            _inputField(controller.nameController, "Nom du lieu", Icons.home_filled, "Maison, Boutique, Pharmacie..."),
            const SizedBox(height: 15),
            _inputField(controller.detailsController, "Précisions importantes", Icons.info_outline, "À côté de la station, porte bleue..."),
          ],
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController ctrl, String label, IconData icon, String hint) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        prefixIcon: Icon(icon, color: AppColors.generalColor),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: AppColors.generalColor)),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () => controller.saveAddress(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.generalColor,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text("ENREGISTRER CETTE POSITION",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showBeautifulGpsSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.gps_fixed_rounded, size: 50, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text("Localisation précise", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text("Veuillez activer votre GPS pour voir les stations et boutiques autour de vous.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Geolocator.openLocationSettings();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.generalColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("ACTIVER MAINTENANT", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}