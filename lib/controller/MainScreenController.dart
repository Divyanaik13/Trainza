import 'package:get/get.dart';

class MainScreenController extends GetxController{

  var selectedTab = 0.obs;
  var previousIndex = 0.obs;

  //for Event Detail Page
  var dateSend = Rxn<DateTime>();
  var eventId = "".obs;
}