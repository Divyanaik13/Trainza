import 'package:club_runner/util/custom_view/CustomView.dart';
import 'package:club_runner/util/my_color/MyColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/countries.dart';

class CountryPickerPage extends StatelessWidget {
  const CountryPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyColor.screen_bg,

      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            elevation: 0.0,
            centerTitle: true,
            title: CustomView.twotextView("Select ", FontWeight.w800, "Country",
                FontWeight.w300, 20, MyColor.app_black_color, 1.74),
            leading: GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.only(right: 3),
                margin: EdgeInsets.fromLTRB(25, 12, 0, 12),
                  decoration: BoxDecoration(
                    color: MyColor.app_black_color,
                    borderRadius: BorderRadius.circular(70)
                  ),
                  child: Icon(Icons.arrow_back_ios_new,color: MyColor.app_white_color,size: 20,)),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: CountryPickerWidget(
              onSelected: (country) => Get.back(result: country),
            ),
          ),
        ),
    );
  }
}

class CountryPickerWidget extends StatefulWidget {
  final Function(Country) onSelected;

  CountryPickerWidget({required this.onSelected});

  @override
  _CountryPickerWidgetState createState() => _CountryPickerWidgetState();
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  List<Country> _filteredCountries = countries;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = countries.where((country) {
        return country.name.toLowerCase().contains(query) ||
            country.dialCode.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search country',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              contentPadding: EdgeInsets.zero
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredCountries.length,
            itemBuilder: (context, index) {
              final country = _filteredCountries[index];

              return ListTile(
                leading: SizedBox(
                  width: 20,
                  child: Text(
                    country.flag, // Display the country flag as an emoji
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                        flex: 0,
                        child: Text('+${country.dialCode} ')),
                    Expanded(
                        flex: 1,
                        child: Text(country.name,overflow: TextOverflow.ellipsis,)),
                  ],
                ),
                onTap: () {
                  widget.onSelected(country); // Pass the selected country back
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
