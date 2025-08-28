import 'package:flutter/material.dart';
import 'package:hencafe/responsive_scaffold.dart';
import 'package:hencafe/screens/addresss_details_screen.dart';
import 'package:hencafe/screens/change_mobile_screen.dart';
import 'package:hencafe/screens/change_password_screen.dart';
import 'package:hencafe/screens/chick_price_screen.dart';
import 'package:hencafe/screens/chick_sell_create_screen.dart';
import 'package:hencafe/screens/chicken_price_screen.dart';
import 'package:hencafe/screens/chicken_sell_create_screen.dart';
import 'package:hencafe/screens/company_details_screen.dart';
import 'package:hencafe/screens/contact_us_screen.dart';
import 'package:hencafe/screens/create_address_screen.dart';
import 'package:hencafe/screens/dahboard_screen.dart';
import 'package:hencafe/screens/delete_account_screen.dart';
import 'package:hencafe/screens/egg_price_screen.dart';
import 'package:hencafe/screens/egg_sell_create_screen.dart';
import 'package:hencafe/screens/fragments/company_list_fragment.dart';
import 'package:hencafe/screens/fragments/sellers_list_fragment.dart';
import 'package:hencafe/screens/image_preview_screen.dart';
import 'package:hencafe/screens/lifting_price_screen.dart';
import 'package:hencafe/screens/lifting_sell_create_screen.dart';
import 'package:hencafe/screens/login_screen_mobile.dart';
import 'package:hencafe/screens/login_screen_otp.dart';
import 'package:hencafe/screens/login_screen_pin.dart';
import 'package:hencafe/screens/faq_screen.dart';
import 'package:hencafe/screens/my_profile.dart';
import 'package:hencafe/screens/notifiaction_screen.dart';
import 'package:hencafe/screens/referral_bonus_screen.dart';
import 'package:hencafe/screens/register_basic_details.dart';
import 'package:hencafe/screens/register_create_pin.dart';
import 'package:hencafe/screens/sale_details_screen.dart';
import 'package:hencafe/screens/state_selection_screen.dart';
import 'package:hencafe/screens/update_company_details.dart';
import 'package:hencafe/screens/upload_file_screen.dart';
import 'package:hencafe/screens/video_player_screen.dart';
import 'package:hencafe/screens/welcome_screen.dart';
import 'package:hencafe/widget/docs_preview_widget.dart';

import 'invalid_route.dart';
import 'values/app_routes.dart';

class Routes {
  const Routes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    Route<dynamic> getRoute({
      required Widget widget,
      bool fullscreenDialog = false,
    }) {
      return MaterialPageRoute<void>(
        builder: (context) => widget,
        settings: settings,
        fullscreenDialog: fullscreenDialog,
      );
    }

    switch (settings.name) {
      case AppRoutes.welcome:
        return getRoute(widget: const WelcomePage());
      case AppRoutes.loginMobile:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const LoginPageMobile(),
            tablet: LoginPageMobile(),
            desktop: LoginPageMobile(),
          ),
        );
      case AppRoutes.loginPin:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const LoginPagePin(),
            tablet: LoginPagePin(),
            desktop: LoginPagePin(),
          ),
        );
      case AppRoutes.loginOtp:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const LoginPageOtp(),
            tablet: LoginPageOtp(),
            desktop: LoginPageOtp(),
          ),
        );
      case AppRoutes.registerBasicDetails:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const RegisterBasicDetails(),
            tablet: RegisterBasicDetails(),
            desktop: RegisterBasicDetails(),
          ),
        );
      case AppRoutes.registerCreatePin:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const RegisterCreatePin(),
            tablet: RegisterCreatePin(),
            desktop: RegisterCreatePin(),
          ),
        );
      case AppRoutes.stateSelection:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const StateSelectionPage(),
            tablet: StateSelectionPage(),
            desktop: StateSelectionPage(),
          ),
        );
      case AppRoutes.eggPriceScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const EggPriceScreen(),
            tablet: EggPriceScreen(),
            desktop: EggPriceScreen(),
          ),
        );
      case AppRoutes.chickPriceScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const ChickPriceScreen(),
            tablet: ChickPriceScreen(),
            desktop: ChickPriceScreen(),
          ),
        );
      case AppRoutes.chickenPriceScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const ChickenPriceScreen(),
            tablet: ChickenPriceScreen(),
            desktop: ChickenPriceScreen(),
          ),
        );
      case AppRoutes.liftingPriceScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const LiftingPriceScreen(),
            tablet: LiftingPriceScreen(),
            desktop: LiftingPriceScreen(),
          ),
        );
      case AppRoutes.companyListScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const CompanyListFragment(
                pageType: AppRoutes.companyListScreen),
            tablet: CompanyListFragment(pageType: AppRoutes.companyListScreen),
            desktop: CompanyListFragment(pageType: AppRoutes.companyListScreen),
          ),
        );
      case AppRoutes.sellersListScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const SellerListFragment(
                pageType: AppRoutes.sellersListScreen),
            tablet: SellerListFragment(pageType: AppRoutes.sellersListScreen),
            desktop: SellerListFragment(pageType: AppRoutes.sellersListScreen),
          ),
        );
      case AppRoutes.companyDetailsScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: const CompanyDetailsScreen(),
            tablet: CompanyDetailsScreen(),
            desktop: CompanyDetailsScreen(),
          ),
        );
      case AppRoutes.dashboardScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: DashboardScreen(),
            tablet: DashboardScreen(),
            desktop: DashboardScreen(),
          ),
        );
      case AppRoutes.sellEggScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: EggSellCreateScreen(),
            tablet: EggSellCreateScreen(),
            desktop: EggSellCreateScreen(),
          ),
        );
      case AppRoutes.sellChickScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: ChickSellCreateScreen(),
            tablet: ChickSellCreateScreen(),
            desktop: ChickSellCreateScreen(),
          ),
        );
      case AppRoutes.sellChickenScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: ChickenSellCreateScreen(),
            tablet: ChickenSellCreateScreen(),
            desktop: ChickenSellCreateScreen(),
          ),
        );
      case AppRoutes.sellLiftingScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: LiftingSellCreateScreen(),
            tablet: LiftingSellCreateScreen(),
            desktop: LiftingSellCreateScreen(),
          ),
        );
      case AppRoutes.myProfileScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: MyProfileScreen(),
            tablet: MyProfileScreen(),
            desktop: MyProfileScreen(),
          ),
        );
      case AppRoutes.addressDetailsScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: AddressDetailsScreen(),
            tablet: AddressDetailsScreen(),
            desktop: AddressDetailsScreen(),
          ),
        );
      case AppRoutes.uploadFileScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: UploadFileScreen(),
            tablet: UploadFileScreen(),
            desktop: UploadFileScreen(),
          ),
        );
      case AppRoutes.saleDetailsScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: SaleDetailsScreen(),
            tablet: SaleDetailsScreen(),
            desktop: SaleDetailsScreen(),
          ),
        );
      case AppRoutes.createAddressScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: CreateAddressScreen(),
            tablet: CreateAddressScreen(),
            desktop: CreateAddressScreen(),
          ),
        );
      case AppRoutes.contactUsScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: ContactUsScreen(),
            tablet: ContactUsScreen(),
            desktop: ContactUsScreen(),
          ),
        );
      case AppRoutes.changePassword:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: ChangePasswordScreen(),
            tablet: ChangePasswordScreen(),
            desktop: ChangePasswordScreen(),
          ),
        );
      case AppRoutes.faqScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: FaqScreen(),
            tablet: FaqScreen(),
            desktop: FaqScreen(),
          ),
        );
      case AppRoutes.notificationsScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: NotificationScreen(),
            tablet: NotificationScreen(),
            desktop: NotificationScreen(),
          ),
        );
      case AppRoutes.deleteAccountScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: DeleteAccountScreen(),
            tablet: DeleteAccountScreen(),
            desktop: DeleteAccountScreen(),
          ),
        );
      case AppRoutes.referralBonusScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: ReferralBonusScreen(),
            tablet: ReferralBonusScreen(),
            desktop: ReferralBonusScreen(),
          ),
        );
      case AppRoutes.changeMobileScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: ChangeMobileScreen(),
            tablet: ChangeMobileScreen(),
            desktop: ChangeMobileScreen(),
          ),
        );
      case AppRoutes.updateCompanyDetailsScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: UpdateCompanyDetailsScreen(),
            tablet: UpdateCompanyDetailsScreen(),
            desktop: UpdateCompanyDetailsScreen(),
          ),
        );
      case AppRoutes.imagePreviewScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: ImagePreviewScreen(),
            tablet: ImagePreviewScreen(),
            desktop: ImagePreviewScreen(),
          ),
        );
      case AppRoutes.videoPlayerScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: VideoPlayerScreen(),
            tablet: VideoPlayerScreen(),
            desktop: VideoPlayerScreen(),
          ),
        );
      case AppRoutes.docPreviewScreen:
        return getRoute(
          widget: ResponsiveScaffold(
            mobile: DocumentPreviewScreen(),
            tablet: DocumentPreviewScreen(),
            desktop: DocumentPreviewScreen(),
          ),
        );
      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
