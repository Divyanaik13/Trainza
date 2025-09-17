class WebServices {

  static const version = "v1";

  // static var BASE_URL = "https://api.trainza.co.za";
  //
  // static var club_url = "https://api.trainza.co.za/branding";

  //Dev server
  static var club_url = "https://dev.api.trainza.mindiii.in";
  static var BASE_URL = "https://dev.api.trainza.mindiii.in";

  static const signUp = "/member/$version/signup";
  static const verifyCodes = "/member/$version/verifyCodes";
  static const forgotPassword = "/member/$version/forgotPassword";
  static const resendOtp = "/member/$version/resendOtp";
  static const login = "/member/$version/login";
  static const delete_account = "/member/$version/deleteAccount";
  static const invitation = "/member/$version/invitation";
  static const acceptInvitation = "/member/$version/invitation/accept";
  static const declineInvitation = "/member/$version/invitation/decline";
  static const joinedClubs = "/member/$version/membership/joinedClubs";
  static const switchClub = "/member/$version/membership/switchClub";
  static const event = "/member/$version/event";
  static const fetchNewList = "/member/$version/news";
  static const trainingList = "/member/$version/training";
  static const fetchNewDetail = "/member/$version/news/";

  static const addVote = "/member/$version/news/";
  static const cancelVote = "/member/$version/news/";
  static const viewVoterListNews = "/member/$version/news/";
  static const logbook_workoutType = "/member/$version/logbook/workoutType";
  static const logbook_save_workout = "/member/$version/logbook/workout";
  static const logbook_user_workoutList = "/member/$version/logbook/workout/";
  static const personalBest = "/member/$version/personalBest";
  static const DeletePersonalBest = "/member/$version/personalBest/";
  static const distanceMeta = "/superAdmin/distanceMeta";
  static const personalBestdistanceMeta = "/superAdmin/personalBestDistanceMeta";
  static const savePersonalBest = "/member/$version/personalBest";
  static const deleteWorkout = "/member/$version/logbook/workout/";
  static const userprofile = "/member/$version/profile";
  static const notificationStatus = "/member/$version/setting/notificationStatus";
  static const changePassword = "/member/$version/setting/changePassword";
  static const clubMemberFetchList = "/member/$version/clubMembers";
  static const notificationList = "/member/$version/notificationList";
  static const notificationReadStatus = "/member/$version/notification";
  static const notificationDelete = "/member/$version/notification";
  static const membership = "/member/$version/membership";
  static const exitMembership = "/member/$version/membership/exitMembership";
  static const membershiploginresponse = "/member/$version/currentLoginResponse";
  static const socialAuthentication = "/member/$version/socialAuthentication";
  static const resultList = "/member/$version/result";
  static const resultEventsDistanceData = "/member/$version/result/eventsDistanceData";
  static const logout = "/member/$version/logout";
  static const resultDetail = "/member/$version/result";
  static const changeclubdata = "/member/$version/currentLoginResponse";
  static const deleteEventresult = "/member/$version/result/";
  static const countryList = "/superAdmin/countryMeta";
  static const stateList = "/superAdmin/stateMeta";
  static const heightList = "/superAdmin/heightMeta";
  static const weightList = "/superAdmin/weightMeta";
  static const privacyPolicy_termConditions = "/superAdmin/pageContent";
  static const socialTempData = "/member/$version/auth/socialTempData";
  static const clubList = "/member/v1/membership/clubList";
  static const memberJoinRequest = "/member/v1/membership/memberJoinRequest";
  static const cancelJoinRequest = "/member/v1/membership/memberJoinRequest";

  static const onboardingStepApi = "/member/$version/profile/onboardingStep";
  static const skipOnboardingStep = "/member/$version/skipOnboardingStep";
}