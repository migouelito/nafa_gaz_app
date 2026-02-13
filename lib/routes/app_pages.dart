import 'package:get/get.dart';
import 'package:nafa_gaz_app/screens/password_forget/password_forget_controller.dart';
import '../routes/app_routes.dart';
import '../screens/auth/bindings/auth_binding.dart';
import '../screens/auth/views/login_view.dart';
import '../screens/password_forget/password_forget_binding.dart';
import '../screens/password_forget/password_forget_view.dart';
import '../screens/sigin/siginup_binding.dart';
import '../screens/sigin/siginup_view.dart';
import '../screens/home/bindings/dashboardBindings.dart';
import '../screens/otpsiginup/otp_binding.dart';
import '../screens/otpsiginup/otp_view.dart';
import '../screens/home/views/dashboard_view.dart';
import '../screens/order/catalog/catalog_bindings.dart';
import '../screens/order/catalog/catalog_view.dart';
import '../screens/order/checkout/checkout_binding.dart';
import '../screens/order/checkout/checkout_view.dart';
import '../main_layout_binding.dart';
import '../main_layout.dart';
import '../screens/history/activity_detail/activity_detail_binding.dart';
import '../screens/history/activity_detail/activity_detail_view.dart';
import '../screens/history/activity/update_activity/update_activity_binding.dart';
import '../screens/history/activity/update_activity/update_activity_view.dart';
import '../screens/notifications/notification_view.dart';
import '../screens/notifications/notification_binding.dart';
import '../screens/profile/address/address_binding.dart';
import '../screens/profile/address/address_view.dart';
import '../screens/profile/addresslist/address_binding.dart';
import '../screens/profile/addresslist/address_list_view.dart';
import '../screens/profile/edit_profile/edit_profil_binding.dart';
import '../screens/profile/edit_profile/edit_profil_view.dart';
import '../screens/order/detail_produit/detail_produit_binding.dart';
import '../screens/order/detail_produit/detail_produit_view.dart';
import '../screens/history/activity/buy/buy_view.dart';
import '../screens/history/activity/buy/buy_binding.dart';
import '../screens/history/activity/change/change_view.dart';
import '../screens/history/activity/change/change_binding.dart';
import '../screens/history/activity/recharge/recharge_view.dart';
import '../screens/history/activity/recharge/recharge_binding.dart';
import '../screens/history/activity/order_validation/order_validation_view.dart';
import '../screens/history/activity/order_validation/order_validation_binding.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
        GetPage(name: Routes.LOGIN, page: () => const LoginView(), binding: AuthBinding()),
        GetPage(name: Routes.SIGNINUP, page: () => const SignupView(), binding: SignupBinding()),
        GetPage(name: Routes.PASSWORDFORGET, page: () => const PasswordForgetView(), binding: PasswordForgetBinding()),
        GetPage(name: Routes.SIGNINOTP, page: () => const OtpView(), binding: OtpBinding()),
        GetPage(name: Routes.HOME, page: () => const DashboardView(), binding: DashboardBinding()),
        GetPage(name: Routes.HOMEMAIN, page: () =>  HomePage(), binding: HomeBinding()),
        GetPage(name:Routes.CALALOG,page: () => const CatalogView(),binding: CatalogBinding()),
        GetPage(name: Routes.CHECKOUT,page: ()=> const CheckoutView(),binding: CheckoutBinding()),
        GetPage(name: Routes.ACTIVITYDETAIL,page: ()=> const ActivityDetailView(),binding: ActivityDetailBinding()),
        GetPage(name: Routes.ACTIVITYUPDATE,page: ()=> const UpdateActivityView(),binding: UpdateActivityBinding()),
        GetPage(name: Routes.NOTIFICATION,page: ()=> const NotificationView(),binding: NotificationBinding()),
        GetPage(name: Routes.ADDRESSLIST,page: ()=> const AddressListView(),binding: AddressListBinding()),
        GetPage(name: Routes.ADDADDRESS,page: ()=> const AddAddressView(),binding: AddAddressBinding()),
        GetPage(name: Routes.EDITPROFILE,page: ()=> const EditProfileView(),binding: EditProfileBinding()),
        GetPage(name: Routes.DETAILPRODUIT, page: () => const ProduitDetailView(), binding:ProduitDetailBinding()),
        GetPage(name: Routes.BUY, page: () => const BuyView(), binding:BuyBinding()),
        GetPage(name: Routes.CHANGE, page: () => const ChangeView(), binding:ChangeBinding()),
        GetPage(name: Routes.RECHARGE, page: () => const RechargeView(), binding:RechargeBinding()),
        GetPage(name: Routes.ORDERVALIDATION, page: () => const OrderValidationView(), binding:OrderValidationBinding()),




  ];
}
