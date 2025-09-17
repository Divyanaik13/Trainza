import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/EditProfileController.dart';
import '../../../controller/ProfileController.dart';
import '../../../models/CountryList_Model.dart';
import '../../../util/custom_view/CustomView.dart';
import '../../../util/custom_view/SearchBar.dart';

class CountryPicker extends StatefulWidget {
  @override
  State<CountryPicker> createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  TextEditingController searchController = TextEditingController();
  final controller = EditProfileController();
  ProfileController ps_controller = Get.put(ProfileController());

  @override
  void initState() {
    var context = this.context;

    controller.countryList_Api().then((value) {
      if(ps_controller.memberInfo.value!.country==""){
        for (var country in controller.countryList) {
          if (country.name == "South Africa") {
            print("South Africa");
            controller.countryName.value = country.name;
            controller.countryMeta.value = country.id;
            controller.stateList_Api(controller.countryMeta.value);
            break;
          }
        }
      }
    });
    super.initState();
  }

  List<CountryMeta> filtercountries(String query) {
    if (query.isEmpty) {
      print("cntry countryList:-- ${controller.countryList}");
      return controller.countryList;
    }

    query = query.toLowerCase();

    return controller.countryList.where((cntry) {
      print("cntry:-- ${cntry.name.toLowerCase().contains(query)}");
      return cntry.name.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,
      child: SafeArea(
        child:  Scaffold(
          body:  SingleChildScrollView(physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: CustomView.customAppBar(
                      "Country", " Picker", () {
                    Get.back();
                  }),
                ),
                SearchTextBar(
                  searchController: searchController,
                  onChanged: ((value) {
                    setState(() {
                      filtercountries(value);
                    });
                  }),
                  margin: const EdgeInsets.all(20),
                ),
                Obx(() {
                  return Container(
                      margin: EdgeInsets.all(10),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: filtercountries(searchController.text).length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var country =
                            filtercountries(searchController.text)[index];
                            var countryname = country.name;
                            var countryid = country.id;
                            //  var countryflag = country.flag;

                            return Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Map<String, dynamic> selectedCountry = {
                                    "name": countryname,
                                    "id": countryid,
                                  };
                                  // Navigator.pop(context, selectedCountry);
                                  Get.back(result: selectedCountry);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Text(
                                    countryname,
                                    style: TextStyle(fontSize: 15,color: MyColor.app_white_color),
                                  ),
                                ),
                              ),
                            );
                          }));
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
