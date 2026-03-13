import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../servicesApp/apiServices.dart';
import '../../../../alerte/alerte.dart';
import '../../../appColors/appColors.dart';
import '../../../../loading/loading.dart';

class AddressListController extends GetxController {
  final ApiService _apiService = ApiService();
  
  var addresses = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshAddresses();
  }
  
Future<void> refreshAddresses() async {
  try {
    isLoading.value = true;
    final List<dynamic> fetchedData = await _apiService.fetchLieuLivraison();
    
    if (fetchedData != null) {
      fetchedData.sort((a, b) => b['id'].compareTo(a['id']));
      addresses.assignAll(fetchedData);
    }
  } catch (e) {
    debugPrint('Erreur Refresh: $e');
  } finally {
    isLoading.value = false;
  }
}

  Future<void> removeAddress(int index) async {
    final String addressId = addresses[index]['id'].toString();
    final String addressName = addresses[index]['name'] ?? "l'adresse";

    try {
      LoadingModal.show();

      bool isDeleted = await _apiService.deleteLieuLivraison(addressId);

      if (isDeleted) {
        LoadingModal.hide();
        
        addresses.removeAt(index);

        Alerte.show(
          title: "Supprimé",
          message: "Lieu '$addressName' supprimé avec succès !",
          imagePath: "assets/images/succes.png", 
          color: AppColors.generalColor,
        );
      } else {
        LoadingModal.hide();
        Alerte.show(
          title: "Erreur",
          message: "Impossible de supprimer cette adresse.",
          imagePath: "assets/images/error.png",
          color: Colors.red,
        );
      }
    } catch (e) {
      LoadingModal.hide();
      debugPrint("Exception lors de la suppression : $e");
      Alerte.show(
        title: "Oups",
        message: "Une erreur est survenue lors de la suppression.",
        imagePath: "assets/images/error.png",
        color: Colors.red,
      );
    }
  }
}