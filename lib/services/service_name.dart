class ServiceNames {
  ServiceNames._();

  static const bool HTTPS = true;
  static String BASE_URL = 'https://api.svpfarms.in/';

  static String REGISTRATION_CHECK = '${BASE_URL}registration/v1.0/registration_check.php';
  static String REGISTRATION_CREATE = '${BASE_URL}registration/v1.0/registration_create.php';
  static String LOGIN_PIN_CHECK = '${BASE_URL}login/v1.0/login_check_password.php';
  static String OTP_GENERATE = '${BASE_URL}otp/v1.0/otp_generate.php';
  static String OTP_VALIDATE = '${BASE_URL}otp/v1.0/otp_validate.php';
  static String FORGET_PIN = '${BASE_URL}forget_pin/v1.0/forget_pin.php';
  static String STATE_LIST = '${BASE_URL}country_state_city/v1.0/state_list.php';
  static String GET_PROFILE = '${BASE_URL}user/v1.0/user_profile_list.php';
  static String UPDATE_FAV_STATE = '${BASE_URL}user/v1.0/user_favourite_state_update.php';
  static String EGG_PRICE_LIST = '${BASE_URL}eggprice/v1.0/eggprice_list.php';
  static String GET_BIRD_LIST = '${BASE_URL}birdbreed/v1.0/birdbreed_list.php';
  static String GET_FAV_STATE_LIST = '${BASE_URL}user/v1.0/user_favourite_state_list.php';

}
