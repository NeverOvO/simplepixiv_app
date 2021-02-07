import 'package:shared_preferences/shared_preferences.dart';

LocalStorageWrite(String flag,String message) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(flag, message);
}

LocalStorageRead(String flag) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(flag);
}

LocalStorageRemove(String flag) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove(flag);
}

