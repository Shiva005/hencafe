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
  static String UPDATE_SELL_EGG = '${BASE_URL}v1/egg-sale/update';
  static String SELL_CHICK = '${BASE_URL}v1/chick-sale/create';
  static String UPDATE_SELL_CHICK = '${BASE_URL}v1/chick-sale/update';
  static String SELL_CHICKEN = '${BASE_URL}v1/chicken-sale/create';
  static String UPDATE_SELL_CHICKEN = '${BASE_URL}v1/chicken-sale/update';
  static String EGG_PRICE_LIST = '${BASE_URL}v1/egg-sale?sale_from_date=';
  static String CHICK_PRICE_LIST = '${BASE_URL}v1/chick-sale?sale_from_date=';
  static String CHICKEN_PRICE_LIST =
      '${BASE_URL}v1/chicken-sale?sale_from_date=';
  static String LIFTING_PRICE_LIST =
      '${BASE_URL}v1/lifting-sale?sale_from_date=';
  static String CREATE_LIFTING_SALE = '${BASE_URL}v1/lifting-sale/create';
  static String UPDATE_LIFTING_SALE = '${BASE_URL}v1/lifting-sale/update';
  static String FORGET_PIN = '${BASE_URL}v1/user/forget-password';
  static String GET_SUPPLIES = '${BASE_URL}v1/supplies/';
  static String ATTACHMENT_UPLOAD = '${BASE_URL}v1/attachment/upload';
  static String ATTACHMENT_DELETE = '${BASE_URL}v1/attachment/delete';
  static String UPDATE_SUPPLY = '${BASE_URL}v1/supplies/supplies-mapping';
  static String CREATE_ADDRESS = '${BASE_URL}v1/address/create';
  static String UPDATE_ADDRESS = '${BASE_URL}v1/address/update';
  static String DELETE_ADDRESS = '${BASE_URL}v1/address/delete?address_uuid=';
}
