// ignore_for_file: constant_identifier_names

const APP_NAME = 'Fideo App';
const APP_LOGO_URL = '$DOMAIN_URL/img/logo/mini_logo.png';
const DEFAULT_LANGUAGE = 'es';
const GREEK_LANGUAGE = 'el';
const DASHBOARD_AUTO_SLIDER_SECOND = 5;

// Live Url
// const DOMAIN_URL = "http://localhost:8000";
const DOMINIO_LOCAL = "https://7841-190-120-252-210.ngrok-free.app";
const DOMINIO_PRUEBA = "https://balance.healtheworld.com.co";
const DOMINIO_PRODUCTION = "";
const DOMINIO = "http://admin.myfidoapp.com";
const DOMAIN_URL =
    DOMINIO_PRUEBA; // DOMINIO_PRUEBA; //DOMINIO_LOCAL; //aqui va la url
// const DOMAIN_URL = "http://10.0.2.2:8000";

const BASE_URL = '$DOMAIN_URL/api/';

//Airtel Money Payments
///It Supports ["UGX", "NGN", "TZS", "KES", "RWF", "ZMW", "CFA", "XOF", "XAF", "CDF", "USD", "XAF", "SCR", "MGA", "MWK"]
const airtel_currency_code = "MWK";
const airtel_country_code = "MW";
const AIRTEL_BASE = 'https://openapiuat.airtel.africa/'; //Test Url
// const AIRTEL_BASE = 'https://openapi.airtel.africa/'; // Live Url

//region STRIPE
const STRIPE_URL = 'https://api.stripe.com/v1/payment_intents';
const STRIPE_merchantIdentifier = "merchant.flutter.stripe.test";
//endregion

const APP_PLAY_STORE_URL =
    'https://play.google.com/store/apps/details?id=com.fidoapp.newcustomer';
const APP_APPSTORE_URL = 'https://apps.apple.com/in/app/pawlly/id6458044939';

const TERMS_CONDITION_URL = '$DOMAIN_URL/page/terms-conditions';
const PRIVACY_POLICY_URL = '$DOMAIN_URL/page/privacy-policy';
const INQUIRY_SUPPORT_EMAIL = 'demo@gmail.com';

/// You can add help line number here for contact. It's demo number
const HELP_LINE_NUMBER = '+15265897485';
const DEFAULT_ANCHO_CONTAINER = 300;
const DEFAULT_ALTO_CONTAINER = 54;
