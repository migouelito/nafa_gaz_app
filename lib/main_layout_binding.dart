import 'package:get/get.dart';
import 'main_layout_controller.dart'; 

class HomeBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<HomeController>(() => HomeController());
  }
}