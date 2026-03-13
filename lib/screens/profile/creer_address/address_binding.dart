import 'package:get/get.dart';
import 'address_controller.dart';

class AddAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAddressController>(() => AddAddressController());
  }
}