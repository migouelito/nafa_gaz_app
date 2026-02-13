import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../../../servicesApp/apiServices.dart';



class UpdateActivityController extends GetxController {
  final apiservices = ApiService();
  var isLoading = false.obs;
  Map<String, dynamic> orderData = {};
  String? orderId;

  @override
  void onInit() {
    super.onInit();
    orderId = Get.arguments as String?;
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    if (orderId == null) return;
    try {
      isLoading.value = true;
      final data = await apiservices.fetchCommandeDetail(orderId!);
      if (data != null) {
        orderData = data;
      }
    } finally {
      isLoading.value = false;
    }
  }

void chooseChangeQuantity() {
  if (orderData.isEmpty) return;

  List<String> productIds = [];

  if (orderData['items'] != null) {
    for (var item in orderData['items']) {
      String pId = "";
      
      if (item['produit'] is Map) {
        pId = item['produit']['id'].toString();
      } else {
        pId = item['produit'].toString();
      }
      
      if (pId.isNotEmpty && !productIds.contains(pId)) {
        productIds.add(pId);
      }
    }
  }

  Get.toNamed(Routes.CHECKOUT, arguments: {
    "orderId": orderId,
    "productIds": productIds, 
  });
}

  
  void chooseChangeBottle() {
    Get.toNamed(Routes.CALALOG, arguments: orderId);
  }
}