import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../servicesApp/apiServices.dart';
import '../../../../loading/loading.dart';

class UpdateActivityController extends GetxController {
  final apiService = ApiService();
  late String orderId;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      orderId = Get.arguments.toString();
    }
    
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }

  void chooseChangeBottle() {
    Get.toNamed(Routes.CALALOG, arguments: orderId);
  }

  void chooseChangeQuantity() async {
    try {
      LoadingModal.show(text: "Récupération des infos...");
      
      final response = await apiService.fetchCommandeDetail(orderId);
      
      LoadingModal.hide();

      if (response != null && response['items'] != null && response['items'].isNotEmpty) {
        final productData = response['items'][0];

        Get.toNamed(Routes.CHECKOUT, arguments: {
          'orderId': orderId,
          'product': {
            'id': productData['produit'], 
          }
        });
      }
    } catch (e) {
      LoadingModal.hide();
      print("Erreur lors de la récupération : $e");
    }
  }
}