import 'package:get/get.dart';

class AddressListController extends GetxController {
  // Liste réactive d'adresses
  var addresses = <Map<String, String>>[
    {"name": "Maison", "details": "Patte d'oie, Rue 14.55, Porte 200", "type": "Domicile"},
    {"name": "Bureau", "details": "Ouaga 2000, Av. Pascal Zagré", "type": "Travail"},
  ].obs;

  void removeAddress(int index) {
    addresses.removeAt(index);
    Get.snackbar(
      "Suppression", 
      "Adresse supprimée avec succès",
      snackPosition: SnackPosition.BOTTOM
    );
  }
}