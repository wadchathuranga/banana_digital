import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreference {

  static SharedPreferences? prefs;

  // initialize
  static Future init() async => prefs = await SharedPreferences.getInstance();

  // set token
  static Future setAccessToken(String token) async => await prefs!.setString('access_token', token);
  static String? getAccessToken() => prefs!.getString('access_token');

  // set username
  static Future setUserName(String username) async => await prefs!.setString('username', username);
  static String? getUserName() => prefs!.getString('username');

  // set email
  static Future setEmail(String email) async => await prefs!.setString('email', email);
  static String? getEmail() => prefs!.getString('email');

  // set firstname
  static Future setFirstName(String firstname) async => await prefs!.setString('firstname', firstname);
  static String? getFirstName() => prefs!.getString('firstname');

  // set lastname
  static Future setLastName(String lastname) async => await prefs!.setString('lastname', lastname);
  static String? getLastName() => prefs!.getString('lastname');

  // set lastname
  static Future setProPic(String proPic) async => await prefs!.setString('prop_ic', proPic);
  static String? getProPic() => prefs!.getString('prop_ic');



  static void userLogOut() async {
    prefs!.remove('username');
    prefs!.remove('access_token');
    prefs!.remove('email');
    prefs!.remove('firstname');
    prefs!.remove('lastname');
    prefs!.remove('prop_ic');
  }


}