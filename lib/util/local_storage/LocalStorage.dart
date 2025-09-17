import 'package:get_storage/get_storage.dart';

import '../../models/AcceptInvitation_Model.dart';

class LocalStorage {

  static final localStorage = GetStorage();

  //Keys
  String signupType = "signupType";
  String authToken = "token";
  String userfirstName = "firstName";
  String userlastName = "lastName";
  String useremail = "email";
  String isEmailPubliclyShared = "isEmailPubliclyShared";
  String isNumberPubliclyShared = "isNumberPubliclyShared";
  String userprofilePicture = "profilePicture";
  String currentClubData_logo = "appLogoFilename";
  String currentClubData_clubName = "clubName";
  String currentClubData_canViewOtherMembers = "canViewOtherMembers";
  String phoneNumber = "phoneNumber";
  String phoneCountryCode = "phoneCountryCode";
  String phoneDialCode = "phoneDialCode";
  String notification_enable = "notification_enable";
  String currentClubData_btnTxtColor = "btnTxtColor";
  String currentClubData_btnBgColor = "btnBgColor";
  String currentClubData_txtColor = "txtColor";
  String isMembershipExpire = "isMembershipExpire";
  String isMembershipActive = "isMembershipActive";
  String isMembershipFinal = "isMembershipFinal";
  String notificationUnreadCount = "notificationUnreadCount";
  String havePassword = "havePassword";
  String isOnboardingStep = "isOnboardingStep";

  String fontSizeType = "fontSizeType";
  String deviceToken = "deviceToken";
  String deviceType = "deviceType";
  String deviceId = "deviceId";

  String isRemember = "isRemember";
  String loginTypeRemember = "loginTypeRemember";
  String emailRemember = "emailRemember";
  String dialcodeReminder = "dialcodeReminder";
  String countryflag = "countryflag";
  String countryname = "countryname";
  String countrycode = "countrycode";
  String phoneReminder = "phoneReminder";
  String passwordRemember = "passwordRemember";
  String appleFirstName = "appleFirstName";
  String appleLastName = "appleLastName";
  String appleEmail = "appleEmail";
  String appleId = "appleId";



  //For Storing String value
  static void setStringValue(String key, String value){
    localStorage.write(key, value);
  }

  static String getStringValue(String key){
    return localStorage.read(key)??"";
  }
  //For Storing Bool value
  static void setBoolValue(String key, bool value){
    localStorage.write(key, value);
  }

  static bool getBoolValue(String key){
    return localStorage.read(key)?? false;
  }

  //For Storing Integer value
  static void setNumValue(String key, String value){
    localStorage.write(key, value);
  }

  static int getNumValue(String key){
    return localStorage.read(key);
  }


  //For Storing String value
  static void setListValue(String key, List<dynamic> value){
    localStorage.write(key, value);
  }

  static List<dynamic> getListValue(String key){
    return localStorage.read(key)?? [];
  }


  //For Clear the GetStorage
  static void clearLocalStorage(){
    localStorage.erase();
    print("clearLocalStorage");
  }
}