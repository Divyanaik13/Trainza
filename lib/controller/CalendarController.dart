import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController{
  var message = "Today".obs;



   updateText(Rx<DateTime> _selectedDay)
  {
    print("_selectedDay : ${_selectedDay.value}  ${_selectedDay.value.month}  ${_selectedDay.value.year}");
    print("DateTime : ${DateTime.now().day} ${DateTime.now().month} ${DateTime.now().year}");
    if((_selectedDay.value.day==DateTime.now().day)&&(_selectedDay.value.month==DateTime.now().month)&&(_selectedDay.value.year==DateTime.now().year))
    {
      print(" Today" );
      message.value="TODAY";
    }
    else if((_selectedDay.value.day==DateTime.now().day-1)&&(_selectedDay.value.month==DateTime.now().month)&&(_selectedDay.value.year==DateTime.now().year))
    {
      print(" YesterDay");
      message.value="YESTERDAY";
    }
    else if((_selectedDay.value.day==DateTime.now().day+1)&&(_selectedDay.value.month==DateTime.now().month)&&(_selectedDay.value.year==DateTime.now().year))
    {
      print(" TMORROW");
      message.value="TOMORROW";
    }
    else
      {
        String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDay.value);
        print(" Date "+formattedDate);
        message.value=formattedDate;
      }
  }
}