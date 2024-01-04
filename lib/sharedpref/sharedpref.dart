import 'package:shared_preferences/shared_preferences.dart';

dynamic sharedPref;

getSharedPref() async {
  sharedPref = await SharedPreferences.getInstance();
}

//save data in local

setLocalData(key, value) async {
  if (sharedPref == null) {
    await getSharedPref();
  }
  sharedPref.setString(key, value);
}

//get data from local

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

//remove data from local

removeLocalData(key) async {
  if (sharedPref == null) {
    await getSharedPref();
  }
  sharedPref.remove(key);
}
