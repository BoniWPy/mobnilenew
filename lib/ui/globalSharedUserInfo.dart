import 'package:shared_preferences/shared_preferences.dart';

String getToken;
String getName;
String getCompanyName;
int getCompanyId;
int getEmployeeId;
int getUserId;

class globalSharedUserInfo {
  functionSetStringSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', getToken);
    prefs.setInt('userid', getUserId);
    prefs.setString('name', getName);
    prefs.setString('company_name', getCompanyName);
    prefs.setInt('company_id', getCompanyId);
    prefs.setInt('employee_id', getEmployeeId);
  }

  functionGetStringSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('token');
    prefs.getInt('userid');
    prefs.getString('name');
    prefs.getString('company_name');
    prefs.getInt('company_id');
    prefs.getInt('employee_id');
    prefs.getInt('employee_employ_id');
  }
}
