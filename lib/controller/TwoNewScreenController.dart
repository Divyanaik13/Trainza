

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TwoNewScreenController extends GetxController
{
   var selectedVotersList = Rxn<int>();
   var selectedVotersOptions = Rxn<int>();
   var selectMainList = Rxn<int>();
   var isGiveVote = false.obs;




   showVendors(int index,int  indexparent){

      if(index!=selectedVotersList.value)
         {
            selectedVotersList.value=index;
            selectMainList.value=indexparent;
         }
      else
         {
            selectedVotersList.value=-1;
         }

   }

   selectOption(int index,int parentIndex){
      selectedVotersOptions.value=index;
      selectMainList.value=parentIndex;
   }

   Future<void> launchUrlweb(String _url) async {
      if (!await launchUrl(Uri.parse(_url))) {
         throw Exception('Could not launch $_url');
      }
   }

   btnVote(){

      if(isGiveVote.value)
         {
            isGiveVote.value=false;
         }
      else
         {
            isGiveVote.value=true;
         }

      print("GGGGG "+isGiveVote.value.toString());
   }
}