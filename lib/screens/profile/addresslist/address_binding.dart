import 'package:get/get.dart';
import 'address_controller.dart';

class AddressListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressListController>(() => AddressListController());
  }
}