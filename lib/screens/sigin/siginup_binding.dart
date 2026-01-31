import 'package:get/get.dart';
import 'siginup_controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    // lazyPut charge le contrôleur uniquement quand la vue est affichée
    Get.lazyPut<SignupController>(() => SignupController());
  }
}