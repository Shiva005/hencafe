class ServiceNames {
  ServiceNames._();

  static const bool HTTPS = true;
  static String BASE_URL = 'http://pyapi.svpfarms.in:9000/api/';

  static String REGISTRATION_CHECK = '${BASE_URL}v1/user/exists?';
  static String OTP_VALIDATE = '${BASE_URL}v1/otp/verify-otp';
  static String OTP_GENERATE = '${BASE_URL}v1/otp/send-otp';
  static String LOGIN_PIN_CHECK = '${BASE_URL}v1/auth/';
  static String GET_STATE_LIST = '${BASE_URL}v1/locations/countries';



  static String REGISTRATION_CREATE = '${BASE_URL}registration/v1.0/registration_create.php';
  static String FORGET_PIN = '${BASE_URL}forget_pin/v1.0/forget_pin.php';
  static String GET_PROFILE = '${BASE_URL}user/v1.0/user_profile_list.php';
  static String UPDATE_FAV_STATE = '${BASE_URL}user/v1.0/user_favourite_state_update.php';
  static String EGG_PRICE_LIST = '${BASE_URL}eggprice/v1.0/eggprice_list.php';
  static String GET_BIRD_LIST = '${BASE_URL}birdbreed/v1.0/birdbreed_list.php';
  static String GET_COMPANY_LIST = '${BASE_URL}company/v1.0/company_list.php';
  static String GET_FAV_STATE_LIST = '${BASE_URL}user/v1.0/user_favourite_state_list.php';
  static String SELL_EGG = '${BASE_URL}eggprice/v1.0/eggprice_create.php';

}
