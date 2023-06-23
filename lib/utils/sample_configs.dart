// Chat service urls
String CHAT_BASE_URL = "https://api.openai.com/v1";
String OPENAI_API_KEY = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

// Weather API secrets
String WEATHER_API = 'https://weatherapi-com.p.rapidapi.com/current.json';
String X_API_KEY = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
String X_API_HOST = 'xxxxxxxxxxxxxxxxxxxxxxxxxxx';

// Soil Moisture API secrets
String SOIL_MOISTURE_API_KEY = 'xxxxxxxxxxxxxxxx';
String SOIL_MOISTURE_API = 'https://api.thingspeak.com/channels/2160765/feeds.json?api_key=$SOIL_MOISTURE_API_KEY&results=3';

// Application
String CLIENT_ID = "xxxxxxxxxxxx";
String CLIENT_SECRET = "xxxxxxxxxxxxxxxxxxxxxxxx";

String GRANT_TYPE = "password";
String GRANT_TYPE_SOCIAL = "convert_token";
String BACKEND_GOOGLE = 'google-oauth2';
String BACKEND_FACEBOOK = 'facebook';


// Authentication & Profile
String API_VERSION = 'api/v1';
String BASE_URL = 'http://xxxxxxxxxxxxxxxxxxx';
String BASE_URI = '$BASE_URL/$API_VERSION';
String USER_SIGN_IN = '$BASE_URL/auth/token';
String USER_SIGN_UP = '$BASE_URI/profile/create';
String USER_PROFILE_GET = '$BASE_URI/profile';
String USER_PROFILE_UPDATE = '$BASE_URI/profile';
String USER_SIGNIN_WITH_SOCIAL = '$BASE_URL/auth/convert-token';

// Harvest component
String HARVEST_PREDICTION = '$BASE_URI/harvest';
String HARVEST_PREDICTION_HISTORIES = '$BASE_URI/harvest/prediction-history?limit=5';
String HARVEST_PREDICTION_GET_ALL_VARITIES = '$BASE_URI/banana-variety/all';
String HARVEST_PREDICTION_DAYS = '$BASE_URI/harvest/data';

// Disease detection component
String DISEASE_DETECTION = '$BASE_URI/disease/detect';
String DISEASE_DETECTION_HISTORIES = '$BASE_URI/disease/prediction-history?limit=5';

// Watering plan
String WATERING_PLAN = '$BASE_URI/watering-plan/predict';
String WATERING_PLAN_HISTORY = '$BASE_URI/watering-plan/prediction-history?limit=5';

// Fertilizer plan
String FERTILIZER_PLAN = '$BASE_URI/fertilizer-plan/predict';
String FERTILIZER_PLAN_HISTORY = '$BASE_URI/fertilizer-plan/prediction-history?limit=5';


// change file name from "sample_configs.dart" to "app_configs.dart"
// then add your secret here before run the project