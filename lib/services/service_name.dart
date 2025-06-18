class ServiceNames {
  ServiceNames._();

  static const bool HTTPS = true;
  static String BASE_URL = 'http://pyapi.svpfarms.in:9000/api/';

  static String REGISTRATION_CHECK = '${BASE_URL}v1/user/exists?';
  static String OTP_VALIDATE = '${BASE_URL}v1/otp/verify-otp';
  static String OTP_GENERATE = '${BASE_URL}v1/otp/send-otp';
  static String LOGIN_PIN_CHECK = '${BASE_URL}v1/auth/';
  static String GET_STATE_LIST = '${BASE_URL}v1/locations/countries';
  static String REGISTRATION_CREATE = '${BASE_URL}v1/user/register';
  static String GET_PROFILE = '${BASE_URL}v1/user';
  static String UPDATE_FAV_STATE = '${BASE_URL}v1/user/favourite-states';
  static String GET_FAV_STATE_LIST = '${BASE_URL}v1/user';
  static String GET_BIRD_BREED_LIST = '${BASE_URL}v1/birdbreed/';
  static String GET_COMPANY_LIST = '${BASE_URL}v1/company/';
  static String SELL_EGG = '${BASE_URL}v1/egg-sale/create';
  static String SELL_CHICK = '${BASE_URL}v1/chick-sale/create';
  static String SELL_CHICKEN = '${BASE_URL}v1/chicken-sale/create';
  static String EGG_PRICE_LIST = '${BASE_URL}v1/egg-sale?sale_from_date=';
  static String CHICK_PRICE_LIST = '${BASE_URL}v1/chick-sale?sale_from_date=';
  static String CHICKEN_PRICE_LIST = '${BASE_URL}v1/chicken-sale?sale_from_date=';
  static String GET_ADDRESS = '${BASE_URL}v1/address?reference_from=USER&reference_uuid=';
  static String FORGET_PIN = '${BASE_URL}v1/user/forget-password';
  static String GET_SUPPLIES = '${BASE_URL}v1/supplies/';
  static String ATTACHMENT_UPLOAD = '${BASE_URL}v1/attachment/upload';
  static String ATTACHMENT_DELETE = '${BASE_URL}v1/attachment/delete';

}
