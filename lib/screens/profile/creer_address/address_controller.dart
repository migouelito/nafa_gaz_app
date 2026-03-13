import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:maps_toolkit/maps_toolkit.dart' as mp; 
import '../../../../loading/loading.dart';
import '../../../../servicesApp/apiServices.dart';
import '../../../../alerte/alerte.dart';
import '../../../appColors/appColors.dart';

class AddAddressController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // Variables réactives
  var center = const LatLng(12.3714, -1.5197).obs; 
  var gettingLocation = false.obs;
  var zonesList = [].obs; 
  var polygons = <Polygon>[].obs;
  var isFavorite = false.obs; 

  final MapController mapController = MapController();
  final TextEditingController nameController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    getCurrentLocation();
    fetchZonesData(); 
  }

  // --- RÉCUPÉRATION ET TRACÉ DES ZONES ---
  Future<void> fetchZonesData() async {
    try {
      LoadingModal.show();
      final data = await _apiService.fetchZones(); 
      if (data != null) {
        zonesList.value = data;
        _preparePolygons();
      }
    } catch (e) {
      debugPrint("Erreur récupération zones : $e");
    } finally {
      LoadingModal.hide();
    }
  }

  void _preparePolygons() {
    List<Polygon> temp = [];
    for (var zone in zonesList) {
      if (zone['polygon_geojson'] != null) {
        var coords = zone['polygon_geojson']['geometry']['coordinates'][0];
        List<LatLng> points = coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();
        temp.add(
          Polygon(
            points: points,
            color: _parseColor(zone['color']).withOpacity(zone['opacity'] ?? 0.5),
            borderColor: _parseColor(zone['color']),
            borderStrokeWidth: 3,
          ),
        );
      }
    }
    polygons.value = temp;
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) { 
      return Colors.blue; 
    }
  }

  // --- VÉRIFICATION ET RÉCUPÉRATION DE L'ID DE LA ZONE ---
  dynamic _getCurrentZoneId(LatLng point) {
    for (var zone in zonesList) {
      var coords = zone['polygon_geojson']['geometry']['coordinates'][0];
      List<mp.LatLng> mpPoints = coords.map<mp.LatLng>((c) => mp.LatLng(c[1], c[0])).toList();
      
      if (mp.PolygonUtil.containsLocation(
          mp.LatLng(point.latitude, point.longitude), mpPoints, false)) {
        return zone['id'];
      }
    }
    return null;
  }

  // --- GÉOLOCALISATION ---
  Future<void> getCurrentLocation() async {
    gettingLocation.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        center.value = LatLng(position.latitude, position.longitude);
        mapController.move(center.value, 18.5);
      }
    } catch (e) {
      debugPrint("Erreur GPS : $e");
    } finally {
      gettingLocation.value = false;
    }
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}');
      final response = await http.get(url, headers: {'User-Agent': 'nafa_gaz_app'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] ?? "Adresse inconnue";
      }
    } catch (e) {
      debugPrint("Erreur géocodage : $e");
    }
    return "Emplacement sélectionné";
  }

  Future<void> saveAddress() async {
    var zoneId = _getCurrentZoneId(center.value);

    if (zoneId == null) {
      Alerte.show(
        title: "Zone non desservie",
        message: "Veuillez vous placer dans une zone de livraison.",
        imagePath: "assets/images/error.png",
        color: Colors.red,
      );
      return;
    }

    if (nameController.text.isEmpty) {
      Alerte.show(
        title: "Oups",
        message: "Veuillez donner un nom à cette adresse",
        imagePath: "assets/images/error.png",
        color: Colors.red,
      );
      return;
    }

    try {
      LoadingModal.show();

      String streetAddress = await _getAddressFromLatLng(center.value);
      Map<String, dynamic> addressData = {
        "name": nameController.text,
        "zone_id": zoneId,
      "latitude": double.parse(center.value.latitude.toStringAsFixed(6)),
      "longitude": double.parse(center.value.longitude.toStringAsFixed(6)),
      "address": streetAddress, 
      "is_default": isFavorite.value,
      };

      bool success = await _apiService.lieuLivraison(addressData);
      if (success) {
        LoadingModal.hide();
        await Alerte.show(
          title: "Succès",
          message: "Adresse enregistrée avec succès !",
          imagePath: "assets/images/succes.png", 
        color: AppColors.generalColor
        );
      }
      Get.back(result: true);
    } catch (e) {
      debugPrint("Erreur lors de l'enregistrement : $e");
      await Alerte.show(
        title: "Erreur",
        message: "Impossible d'enregistrer l'adresse.",
        imagePath: "assets/images/error.png",
        color: Colors.red,
      );
    } finally {
      LoadingModal.hide();
    }
  }
}