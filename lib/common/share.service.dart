import 'package:flutter_redux/flutter_redux.dart';
import 'package:hands2gether/firebase/services.dart';
import 'package:hands2gether/locator.dart';
import 'package:hands2gether/main.dart';
import 'package:hands2gether/model/categories.model.dart';
import 'package:hands2gether/model/listing.dart';
import 'package:hands2gether/redux/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareService {
  Api _apiCategories = locator<Api>(param1: 'categories');
  Api _apiListing = locator<Api>(param1: 'listing');

  /// ************* GET/SET Share Preference *************** */
  setStringData(key, value) async {
    var _prefs = await SharedPreferences.getInstance();
    var _key = key;
    _prefs.setString(_key, value);
  }

  getStringData(key) async {
    var _prefs = await SharedPreferences.getInstance();
    var _output = _prefs.getString(key) ?? false;
    return _output;
  }

  /// ************* Firebase to Redux *************** */
  getCategories(context) async {
    List temp = [];
    if (store.state.categoryModelList.length == 0) {
      var result = await _apiCategories.getDataCollection();
      for (var i in result.docs) {
        var cateModel = Categoriesmodel.fromMap(i.data());
        temp.add(cateModel);
      }
      StoreProvider.of<AppState>(context)
          .dispatch(Updatecategory(payload: temp));
      print("Categories Api Arr");
      print(temp);
      return temp;
    } else {
      for (var i in store.state.categoryModelList) {
        temp.add(i);
      }
      print("Categories Store Arr");
      print(temp);
      return temp;
    }
  }

  getListings(context) async {
    List temp = [];
    if (store.state.listingdModelList.length == 0) {
      var result = await _apiListing.getDataCollection();
      for (var i in result.docs) {
        var cateModel = Listingmodel.fromMap(i.data());
        temp.add(cateModel);
      }
      StoreProvider.of<AppState>(context)
          .dispatch(Updatelistings(payload: temp));
      print("Listing Api Arr");
      print(temp);
      return temp;
    } else {
      for (var i in store.state.listingdModelList) {
        temp.add(i);
      }
      print("Listing Store Arr");
      print(temp);
      return temp;
    }
  }
}
