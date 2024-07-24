import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pawlly/modules/auth/model/about_data_model.dart';
import 'package:pawlly/modules/auth/model/app_configuration_res.dart';
import 'package:pawlly/modules/auth/model/login_response.dart';
import 'package:pawlly/modules/auth/model/order_status_data_model.dart';
import 'package:pawlly/modules/auth/model/sistem_model.dart';
import 'package:pawlly/modules/auth/model/status_model.dart';

import '../configs.dart';
import 'constants.dart';

bool isIqonicProduct = DOMAIN_URL.contains("apps.iqonic.design");

RxString selectedLanguageCode = DEFAULT_LANGUAGE.obs;
RxBool isLoggedIn = false.obs;
RxString playerId = "".obs;
Rx<UserData> loginUserData = UserData().obs;
RxBool isDarkMode = false.obs;

Rx<Currency> appCurrency = Currency().obs;
Rx<ConfigurationResponse> appConfigs = ConfigurationResponse(
  currency: Currency(),
  onesignalCustomerApp: OnesignalCustomerApp(),
  razorPay: RazorPay(),
  stripePay: StripePay(),
  customerAppUrl: CustomerAppUrl(),
  paystackPay: PaystackPay(),
  paypalPay: PaypalPay(),
  flutterwavePay: FlutterwavePay(),
  airtelMoney: AirtelMoney(),
  phonepe: Phonepe(),
  midtransPay: MidtransPay(),
  zoom: ZoomConfig(),
).obs;

//DashBoard var
Rx<SystemModel> currentSelectedService = SystemModel().obs;
RxList<SystemModel> serviceList = RxList();
RxList<StatusModel> allStatus = RxList();
RxList<OrderStatusDataModel> allOrderStatus = RxList();
RxList<AboutDataModel> aboutPages = RxList();

//endregion

// Currency position common
bool get isCurrencyPositionLeft =>
    appCurrency.value.currencyPosition ==
    CurrencyPosition.CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight =>
    appCurrency.value.currencyPosition ==
    CurrencyPosition.CURRENCY_POSITION_RIGHT;

bool get isCurrencyPositionLeftWithSpace =>
    appCurrency.value.currencyPosition ==
    CurrencyPosition.CURRENCY_POSITION_LEFT_WITH_SPACE;

bool get isCurrencyPositionRightWithSpace =>
    appCurrency.value.currencyPosition ==
    CurrencyPosition.CURRENCY_POSITION_RIGHT_WITH_SPACE;
//endregion

RxBool updateUi = false.obs;

//ORDER MOUDLE
RxInt cartItemCount = 0.obs;
//ORDER Success
RxString orderID = "".obs;
//
