import 'package:flutter/material.dart';
import 'package:hencafe/responsive_scaffold.dart';
import 'package:hencafe/screens/chick_price_screen.dart';
import 'package:hencafe/screens/chick_sell_create_screen.dart';
import 'package:hencafe/screens/chicken_price_screen.dart';
import 'package:hencafe/screens/chicken_sell_create_screen.dart';
import 'package:hencafe/screens/create_address_screen.dart';
import 'package:hencafe/screens/dahboard_screen.dart';
import 'package:hencafe/screens/egg_price_screen.dart';
import 'package:hencafe/screens/egg_sell_create_screen.dart';
import 'package:hencafe/screens/lifting_price_screen.dart';
import 'package:hencafe/screens/lifting_sell_create_screen.dart';
import 'package:hencafe/screens/login_screen_mobile.dart';
import 'package:hencafe/screens/login_screen_otp.dart';
import 'package:hencafe/screens/login_screen_pin.dart';
import 'package:hencafe/screens/my_profile.dart';
import 'package:hencafe/screens/register_basic_details.dart';
import 'package:hencafe/screens/register_create_pin.dart';
import 'package:hencafe/screens/sale_details_screen.dart';
import 'package:hencafe/screens/state_selection_screen.dart';
import 'package:hencafe/screens/upload_file_screen.dart';
import 'package:hencafe/screens/welcome_screen.dart';

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
      default:
        return getRoute(widget: const InvalidRoute());
    }
  }
}
