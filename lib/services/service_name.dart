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
  static String UPDATE_BASIC_DETAILS = '${BASE_URL}v1/user/';
  static String UPDATE_MOBILE_NUMBER = '${BASE_URL}v1/user/';
  static String GET_PROFILE = '${BASE_URL}v1/user';
  static String GET_USERS = '${BASE_URL}v1/user/users-list?promotion_status=';
  static String GET_REFERRALS_LIST = '${BASE_URL}v1/user/';
  static String DELETE_PROFILE = '${BASE_URL}v1/user';
  static String UPDATE_FAV_STATE = '${BASE_URL}v1/user/favourite-states';
  static String GET_FAV_STATE_LIST = '${BASE_URL}v1/user';
  static String GET_BIRD_BREED_LIST = '${BASE_URL}v1/birdbreed/';
  static String GET_COMPANY_LIST = '${BASE_URL}v1/company/';
  static String GET_COMPANY_PROVIDERS_LIST =
      '${BASE_URL}v1/company?company_uuid=';
  static String SELL_EGG = '${BASE_URL}v1/egg-sale/create';
  static String UPDATE_SELL_EGG = '${BASE_URL}v1/egg-sale/update';
  static String SELL_CHICK = '${BASE_URL}v1/chick-sale/create';
  static String UPDATE_SELL_CHICK = '${BASE_URL}v1/chick-sale/update';
  static String SELL_CHICKEN = '${BASE_URL}v1/chicken-sale/create';
  static String UPDATE_SELL_CHICKEN = '${BASE_URL}v1/chicken-sale/update';
  static String EGG_PRICE_LIST = '${BASE_URL}v1/egg-sale?sale_from_date=';
  static String GET_ADDRESS_LIST = '${BASE_URL}v1/address?reference_from=';
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
  static String CHANGE_PASSWORD = '${BASE_URL}v1/user/';
  static String UPDATE_COMPANY = '${BASE_URL}v1/company/update';
  static String GET_MEDICINE = '${BASE_URL}v1/medicine?medicine_id=';
  static String CREATE_CONTACT_SUPPORT = '${BASE_URL}v1/communication/create';
  static String GET_CONTACT_HISTORY =
      '${BASE_URL}v1/communication?communication_type=';
  static String DELETE_CONTACT_RECORD =
      '${BASE_URL}v1/communication/delete?communication_uuid=';
  static String DELETE_EGG_SALE = '${BASE_URL}v1/egg-sale/delete?eggsale_uuid=';
  static String DELETE_CHICK_SALE =
      '${BASE_URL}v1/chick-sale/delete?chicksale_uuid=';
  static String DELETE_CHICKEN_SALE =
      '${BASE_URL}v1/chicken-sale/delete?chickensale_uuid=';
  static String DELETE_LIFTING_SALE =
      '${BASE_URL}v1/lifting-sale/delete?liftingsale_uuid=';
  static String START_APP_SESSION = '${BASE_URL}v1/session-track/start';
  static String END_APP_SESSION = '${BASE_URL}v1/session-track/end';
  static String GET_PLAY_STORE_APP_VERSION = '${BASE_URL}v1/app-version?app_name=HENCAFE';
  static String USER_INSTALLED_VERSION = '${BASE_URL}v1/app-version/user-use-version/create';
}
