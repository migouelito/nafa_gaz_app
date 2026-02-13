import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class AddAddressController extends GetxController {
  // Pas de position en dur : on attend le GPS
  var center = const LatLng(12.3714, -1.5197).obs; 
  var gettingLocation = false.obs;

  final MapController mapController = MapController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    gettingLocation.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        
        center.value = LatLng(position.latitude, position.longitude);
        
        // Zoom 18.5 est le point parfait pour voir les noms des boutiques et stations
        mapController.move(center.value, 18.5);
      }
    } catch (e) {
      debugPrint("Erreur GPS : $e");
    } finally {
      gettingLocation.value = false;
    }
  }

  void saveAddress() {
    if (nameController.text.isEmpty) {
      Get.snackbar("Oups", "Veuillez donner un nom à cette adresse",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    Get.back();
  }
}