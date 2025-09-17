import 'package:club_runner/view/splash_screen/SplashScreen.dart';
import 'package:get/get.dart';
import '../../view/main_page/MainScreen.dart';
import '../../view/screens/Results/EditRaceEventScreen.dart';
import '../../view/screens/Results/RaceResultScreen.dart';
import '../../view/screens/Results/results.dart';
import '../../view/screens/VideoView/VideoViewScreen.dart';
import '../../view/screens/countryPicker_screen/CountryPicker.dart';
import '../../view/screens/dash_board_screen/DashBoardScreen.dart';
import '../../view/screens/dash_board_screen/JoinClubScreen.dart';
import '../../view/screens/dash_board_screen/Login_PasswordScreen.dart';
import '../../view/screens/membership_screen/MemberShipTrainza.dart';
import '../../view/screens/membership_screen/ExitMembership.dart';
import '../../view/screens/dash_board_screen/SwitchProfile.dart';
import '../../view/screens/members/Deletemembership.dart';
import '../../view/screens/onBoarding_screen/OnBoardingScreen.dart';
import '../../view/screens/page_content/ContactUs.dart';
import '../../view/screens/page_content/PrivacyPolicy.dart';
import '../../view/screens/page_content/Terms&Conditions.dart';
import '../../view/screens/profile_screen/EditProfileScreen.dart';
import '../../view/screens/event_screen/EventDetailScreen.dart';
import '../../view/screens/event_screen/EventScreen.dart';
import '../../view/screens/members/MemberDetailScreen.dart';
import '../../view/screens/members/MembersScreen.dart';
import '../../view/screens/news_screen/NewsScreen.dart';
import '../../view/screens/news_screen/NewsDetailScreen.dart';
import '../../view/screens/notification_screen/Notifications.dart';
import '../../view/screens/pb_screens/EditPersonalBestScreen.dart';
import '../../view/screens/pb_screens/PersonalBestScreen.dart';
import '../../view/screens/profile_screen/FullProfileScreen.dart';
import '../../view/screens/profile_screen/ProfileScreen.dart';
import '../../view/screens/setting/SettingScreen.dart';
import '../../view/screens/training_screen/TrainingScreen.dart';
import '../../view/screens/training_screen/ViewRouteScreen.dart';
import '../../view/screens/workout_logbook/WorkoutLogbookScreen.dart';
import '../../view/singup_screen/OtpVerifyScreen.dart';
import '../../view/singup_screen/SingUpScreen.dart';
import '../../view/view_image_slider/FullScreenImagePreview.dart';
import '../../view/welcome_screen/Forget_Password.dart';
import '../../view/welcome_screen/PasswordReminderSucccess.dart';
import '../../view/welcome_screen/WelcomeScreen.dart';
import '../custom_view/country_pacakage/CountryPicker.dart';

class RouteHelper{

  static String splashScreen = "/SplashScreen";
  static String welcomeScreen = "/WelcomeScreen";
  static String singUpScreen = "/SingUpScreen";
  static String otpVerifyScreen = "/OtpVerifyScreen";
  static String mainScreen = "/MainScreen";
  static String dashBoardScreen = "/DashBoardScreen";
  static String newsScreen = "/NewsScreen";
  static String trainingScreen = "/TrainingScreen";
  static String settingScreen = "/SettingScreen";
  static String membersScreen = "/MembersScreen";
  static String memberDetailScreen = "/MemberDetailScreen";
  static String viewRouteScreen = "/ViewRouteScreen";
  static String workoutLogbookScreen = "/WorkoutLogbookScreen";
  static String profileScreen = "/ProfileScreen";
  static String newsDetails_Screen = "/NewsDetailsScreen";
  static String forgotPasswordScreen = "/ForgetPassswordScreen";
  static String passwordReminderSuccessScreen = "/PasswordReminderSuccessScreen";
  static String deleteMembershipScreen = "/DeleteMembership_Screen";
  static String termsConditions = "/TermsConditions";
  static String privacyPolicy = "/PrivacyPolicy";
  static String contactUs = "/ContactUs";


  ///Diksha
  static String editProfileScreen = "/EditProfileScreen";
  static String eventDetailScreen = "/EventDetailScreen";
  static String eventScreen = "/EventScreen";
  static String personalBestScreen = "/PersonalBest";
  static String editpersonalBestScreen = "/EditPersonalBest";
  static String membershipScreen = "/Membership";
  static String removemembershipScreen = "/ExitMembership";
  static String countryPickerScreen = "/CountryPickerPage";
  static String loginPasswordScreen = "/LoginPasswordScreen";
  static String fullProfileScreen = "/FullProfileScreen";
  static String viewVideoScreen = "/ViewVideoScreen";
  static String switchProfileScreen = "/SwitchProfile";
  static String notificationScreen = "/Notification_Screen";
  static String resultScreen = "/ResultScreen";
  static String raceresultScreen = "/RaceResultScreen";
  static String editRaceEventScreen = "/EditRaceEventScreen";
  static String fullScreenImagePreview = "/FullScreenImagePreview";
  static String countryPicker = "/CountryPicker";
  static String joinClubScreen = "/JoinClubScreen";
  static String onBoardingScreen = "/OnBoardingScreen";


  static String getSplashScreen() => splashScreen;
  static String getWelcomeScreen() => welcomeScreen;
  static String getSingUpScreen() => singUpScreen;
  static String getOtpVerifyScreen() => otpVerifyScreen;
  static String getMainScreen() => mainScreen;
  static String getDashBoardScreen() => dashBoardScreen;
  static String getEventScreen() => eventScreen;
  static String getNewsScreen() => newsScreen;
  static String getTrainingScreen() => trainingScreen;
  static String getSettingScreen() => settingScreen;
  static String getMembersScreen() => membersScreen;
  static String getMemberDetailScreen() => memberDetailScreen;
  static String getProfileScreen() => profileScreen;
  static String getEditProfileScreen() => editProfileScreen;
  static String getViewRouteScreen() => viewRouteScreen;
  static String getWorkoutLogbookScreen() => workoutLogbookScreen;
  static String getEventDetailScreen() => eventDetailScreen;
  static String getPersonalBestScreen() => personalBestScreen;
  static String getEditPersonalBestScreen() => editpersonalBestScreen;
  static String getNewsDetailsScreen() => newsDetails_Screen;
  static String getMembershipScreen() => membershipScreen;
  static String getremoveMembershipScreen() => removemembershipScreen;
  static String getforgotPasswordScreen() => forgotPasswordScreen;
  static String getCountryPickerScreen() => countryPickerScreen;
  static String getPasswordReminderSuccessScreen() => passwordReminderSuccessScreen;
  static String getLoginPasswordScreen() => loginPasswordScreen;
  static String getFullProfileScreen() => fullProfileScreen;
  static String getViewVideoScreen() => viewVideoScreen;
  static String getSwitchProfileScreen() => switchProfileScreen;
  static String getNotification_Screen() => notificationScreen;
  static String getResultScreen() => resultScreen;
  static String getRaceResultScreen() => raceresultScreen;
  static String getDeleteMembership_Screen() => deleteMembershipScreen;
  static String getEditRaceEventScreen() => editRaceEventScreen;
  static String getFullScreenImagePreview() => fullScreenImagePreview;
  static String getCountryPicker() => countryPicker;
  static String getTermsConditions() => termsConditions;
  static String getPrivacyPolicy() => privacyPolicy;
  static String getContactUs() => contactUs;
  static String getJoinClubScreen() => joinClubScreen;
  static String getOnBoardingScreen() => onBoardingScreen;


  static var pageList =[
    GetPage(name: splashScreen, page: ()=> SplashScreen()),
    GetPage(name: welcomeScreen, page: ()=>  WelcomeScreen()),
    GetPage(name: singUpScreen, page: ()=>  SingUpScreen()),
    GetPage(name: otpVerifyScreen, page: ()=>  OtpVerifyScreen()),
    GetPage(name: mainScreen, page: ()=>  MainScreen()),
    GetPage(name: dashBoardScreen, page: ()=>  DashBoardScreen()),
    GetPage(name: eventScreen, page: ()=>  EventScreen()),
    GetPage(name: newsScreen, page: ()=>  NewsScreen()),
    GetPage(name: trainingScreen, page: ()=>  TrainingScreen()),
    GetPage(name: settingScreen, page: ()=>  SettingScreen()),
    GetPage(name: membersScreen, page: ()=>  MembersScreen()),
    GetPage(name: memberDetailScreen, page: ()=>  MemberDetailScreen()),
    GetPage(name: profileScreen, page: ()=>  ProfileScreen()),
    GetPage(name: editProfileScreen, page: ()=>  EditProfileScreen()),
    GetPage(name: viewRouteScreen, page: ()=>  ViewRouteScreen()),
    GetPage(name: workoutLogbookScreen, page: ()=>  WorkoutLogbookScreen()),
    GetPage(name: eventDetailScreen, page: ()=>  EventDetailScreen()),
    GetPage(name: personalBestScreen, page: ()=>  PersonalBest()),
    GetPage(name: editpersonalBestScreen, page: ()=>  EditPersonalBest()),
    GetPage(name: newsDetails_Screen, page: ()=> NewsDetailsScreen()),
    GetPage(name: membershipScreen, page: ()=> Membership()),
    GetPage(name: removemembershipScreen, page: ()=> ExitMembership()),
    GetPage(name: forgotPasswordScreen, page: ()=> ForgetPassswordScreen()),
    GetPage(name: countryPickerScreen, page: ()=> CountryPickerPage()),
    GetPage(name: passwordReminderSuccessScreen, page: ()=> PasswordReminderSuccessScreen()),
    GetPage(name: loginPasswordScreen, page: ()=> LoginPasswordScreen()),
    GetPage(name: fullProfileScreen, page: ()=> FullProfileScreen()),
    GetPage(name: viewVideoScreen, page: ()=> VideoViewScreen()),
    GetPage(name: switchProfileScreen, page: ()=> SwitchProfile()),
    GetPage(name: notificationScreen, page: ()=> Notification_Screen()),
    GetPage(name: resultScreen, page: ()=> ResultScreen()),
    GetPage(name: raceresultScreen, page: ()=> RaceResultScreen()),
    GetPage(name: deleteMembershipScreen, page: ()=> DeleteMembership_Screen()),
    GetPage(name: editRaceEventScreen, page: ()=> EditRaceEventScreen()),
    GetPage(name: fullScreenImagePreview, page: ()=> FullScreenImagePreview()),
    GetPage(name: countryPicker, page: ()=> CountryPicker()),
    GetPage(name: termsConditions, page: ()=> TermsConditions()),
    GetPage(name: privacyPolicy, page: ()=> PrivacyPolicy()),
    GetPage(name: contactUs, page: ()=> ContactUs()),
    GetPage(name: joinClubScreen, page: ()=> JoinClubScreen()),
    GetPage(name: onBoardingScreen, page: ()=> OnBoardingScreen()),
  ];
}

