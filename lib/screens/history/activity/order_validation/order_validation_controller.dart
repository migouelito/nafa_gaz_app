import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../servicesApp/apiServices.dart';
import '../../../../loading/loading.dart';
import '../../../../alerte/alerte.dart';
import '../../../../appColors/appColors.dart';
import 'package:get/get.dart';

class OrderValidationController extends GetxController {
  final apiservices = ApiService(); 
  
  var selectedProducts = <Map<String, dynamic>>[].obs;
  var allAvailableProducts = <Map<String, dynamic>>[].obs;
  var isProductLoading = true.obs;
  var exchangeSelection = <String, RxString>{}.obs;
  
  // --- GESTION DES ADRESSES RÉCUPÉRÉES VIA API ---
  var addresses = <dynamic>[].obs;
  var selectedAddressId = "".obs;
  var isAddressLoading = false.obs;

  // Suppression de la liste "locations" en dur
  final int deliveryFee = 1500;
  var totalGlobal = 0.obs;
  int? typeSelection; 

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    
    typeSelection = args['number'];

    final List<Map<String, dynamic>> productsBase = args['products'] != null 
        ? List<Map<String, dynamic>>.from(args['products']) 
        : [];
    
    _initializeData(productsBase);
    
    refreshAddresses(); 
  }

  Future<void> _initializeData(List<Map<String, dynamic>> itemsBase) async {
    try {
      isProductLoading.value = true;
      final productsFromApi = await apiservices.getProduits();
      if (productsFromApi != null) {
        allAvailableProducts.assignAll(List<Map<String, dynamic>>.from(productsFromApi));
      }
      await _loadFullDetails(itemsBase);
    } catch (e) {
      debugPrint("Erreur initialisation produits: $e");
    } finally {
      isProductLoading.value = false;
    }
  }

  Future<void> _loadFullDetails(List<Map<String, dynamic>> itemsBase) async {
    List<Map<String, dynamic>> fullProducts = [];

    for (var item in itemsBase) {
      final String productId = item['id'].toString();
      final details = await apiservices.getProduitDetail(productId);
      
      if (details != null) {
        var genericTarifs = details['tarifs'] ?? (details['tarif'] != null ? [details['tarif']] : []);
        
        RxInt qV = 0.obs; 
        RxInt qR = 0.obs; 
        RxInt qE = 0.obs;

        if (typeSelection == 1) qV.value = 1;     
        else if (typeSelection == 2) qR.value = 1; 
        else if (typeSelection == 3) qE.value = 1; 

        RxString selectedExchangeId = "".obs;
        exchangeSelection[productId] = selectedExchangeId;
        
        fullProducts.add({
          ...details,
          'tarifs': genericTarifs, 
          "qty_vente": qV, 
          "qty_recharge": qR, 
          "qty_echange": qE,
        });
      }
    }
    selectedProducts.assignAll(fullProducts);
    _calculateTotalGlobal();
  }

  void _calculateTotalGlobal() {
    int sum = 0;
    for (var p in selectedProducts) {
      var tarifsList = p['tarifs'] as List;
      if (tarifsList.isEmpty) continue;
      var tarif = tarifsList[0];
      sum += (double.parse(tarif['price_vente']?.toString() ?? '0').toInt() * (p['qty_vente'] as RxInt).value) +
             (double.parse(tarif['price_recharge']?.toString() ?? '0').toInt() * (p['qty_recharge'] as RxInt).value) +
             (double.parse(tarif['price_echange']?.toString() ?? '0').toInt() * (p['qty_echange'] as RxInt).value);
    }
    totalGlobal.value = (sum > 0) ? sum + deliveryFee : 0;
  }

  void updateQty(int index, String type, bool increase) {
    var p = selectedProducts[index];
    RxInt q = p['qty_$type'];
    if (increase) q.value++; else if (q.value > 0) q.value--;
    _calculateTotalGlobal();
  }

  Map<String, dynamic> _mapItem(Map p, String type, int qty) {
    var tarif = (p['tarifs'] as List)[0];
    String prix = tarif['price_$type']?.toString() ?? "0";
    String productId = p['id'].toString();
    String? prodEchanger = exchangeSelection[productId]?.value;
    if (prodEchanger == "") prodEchanger = null;

    return {
      "type_commerce": type,
      "produit": productId, 
      "produit_echanger": prodEchanger, 
      "quantity": qty,
      "prix_unitaire": prix,
    };
  }

  Future<bool> validerCommande() async {
    if (totalGlobal.value == 0) return false; 

    if (selectedAddressId.value.isEmpty) {
      Alerte.show(
        title: "Lieu de livraison", 
        message: "Veuillez sélectionner une adresse enregistrée",
        imagePath: "assets/images/error.png", 
        color: Colors.red
      );
      return false;
    }

    for (var p in selectedProducts) {
      if (p['qty_echange'].value > 0 && 
         (exchangeSelection[p['id'].toString()]?.value == "" || exchangeSelection[p['id'].toString()]?.value == null)) {
        Alerte.show(
          title: "Échange", 
          message: "Choisissez la bouteille à rendre pour ${p['name']}",
          imagePath: "assets/images/error.png", 
          color: Colors.red
        );
        return false;
      }
    }

    try {
      LoadingModal.show(text: "Validation...");
      List itemsFinal = [];
      for (var p in selectedProducts) {
        if (p['qty_vente'].value > 0) itemsFinal.add(_mapItem(p, "vente", p['qty_vente'].value));
        if (p['qty_recharge'].value > 0) itemsFinal.add(_mapItem(p, "recharge", p['qty_recharge'].value));
        if (p['qty_echange'].value > 0) itemsFinal.add(_mapItem(p, "echange", p['qty_echange'].value));
      }
      
      bool success = await apiservices.createCommande({
        "lieu_livraison": selectedAddressId.value, 
        "prix_livraison": deliveryFee.toString(), 
        "items": itemsFinal
      });

      LoadingModal.hide();
      if (success) { 
        await Alerte.show(
          title: "Succès", message: "Commande confirmée",
          imagePath: "assets/images/succes.png", color: AppColors.generalColor
        ); 
      }
       return true;
    } catch (e) { 
      LoadingModal.hide(); 
      debugPrint("Erreur validation commande: $e");
      return false;
    }
  }

  // --- MÉTHODE DE RÉCUPÉRATION DYNAMIQUE DES ADRESSES ---
  Future<void> refreshAddresses() async {
    try {
      isAddressLoading.value = true;
      final List<dynamic> fetchedData = await apiservices.fetchLieuLivraison();
      
      if (fetchedData != null) {
        // Tri : les plus récentes en premier
        fetchedData.sort((a, b) => b['id'].compareTo(a['id']));
        addresses.assignAll(fetchedData);
        
        var defaultAddr = addresses.firstWhere(
          (element) => element['is_default'] == true || element['is_default'] == 1,
          orElse: () => addresses.isNotEmpty ? addresses[0] : null,
        );
        
        if (defaultAddr != null) {
          selectedAddressId.value = defaultAddr['id'].toString();
        }
      }
    } catch (e) {
      debugPrint('Erreur lors de la récupération des adresses: $e');
    } finally {
      isAddressLoading.value = false;
    }
  }




}