import 'package:shared_preferences/shared_preferences.dart';

dynamic sharedPref;

getSharedPref() async {
  sharedPref = await SharedPreferences.getInstance();
}

setLocalData(key, value) async {
  if (sharedPref == null) {
    await getSharedPref();
  }
  sharedPref.setString(key, value);
}

getLocalData(key) async {
  dynamic data;
  if (sharedPref == null) {
    await getSharedPref();
  }
  if (sharedPref.containsKey(key)) {
    data = sharedPref.getString(key);
  } else {
    data = null;
  }
  return data;
}

removeLocalData(key) async {
  if (sharedPref == null) {
    await getSharedPref();
  }
  sharedPref.remove(key);
}
