import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class AddAddressController extends GetxController {
  // Variables réactives
  var center = const LatLng(12.3714, -1.5197).obs;
  var gettingLocation = false.obs;

  final MapController mapController = MapController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  Future<void> checkAndGetLocation(Function showGpsDialog) async {
    gettingLocation.value = true;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      gettingLocation.value = false;
      showGpsDialog(); 
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        gettingLocation.value = false;
        Get.snackbar("Erreur", "Permission refusée");
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      center.value = LatLng(position.latitude, position.longitude);
      mapController.move(center.value, 16.0);
      Get.snackbar("Succès", "Position trouvée !", backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Erreur", e.toString());
    } finally {
      gettingLocation.value = false;
    }
  }
}