import 'package:flutter_redux/flutter_redux.dart';
import 'package:hands2gether/firebase/services.dart';
import 'package:hands2gether/locator.dart';
import 'package:hands2gether/main.dart';
import 'package:hands2gether/model/categories.model.dart';
import 'package:hands2gether/model/listing.dart';
import 'package:hands2gether/model/user.model.dart';
import 'package:hands2gether/redux/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareService {
  Api _apiCategories = locator<Api>(param1: 'categories');
  Api _apiListing = locator<Api>(param1: 'listing');
  Api _apiUser = locator<Api>(param1: 'users');

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
  getUserById(context, id) async {
    dynamic temp;
    if (store.state.userModelList.length == 0) {
      var result = await _apiUser.getDocumentById(id);
      var cateModel = Usermodel.fromMap(result.data());
      temp = cateModel ;
      try{
        StoreProvider.of<AppState>(context)
          .dispatch(UpdateUser(payload: temp));
      }catch(err){

      }
      print("////////////////////////////////////////////");
      print("User Api Arr");
      print(temp);
      print("////////////////////////////////////////////");
      return temp;
    }else{
      for (var i in store.state.userModelList) {
        temp.add(i);
      }
      print("////////////////////////////////////////////");
      print("User Store Arr");
      print(temp[0]);
      print("////////////////////////////////////////////");
      return temp[0];
    }
    
  }
  
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
      print("////////////////////////////////////////////");
      print("Categories Api Arr");
      print(temp);
      print("////////////////////////////////////////////");
      return temp;
    } else {
      for (var i in store.state.categoryModelList) {
        temp.add(i);
      }
      print("////////////////////////////////////////////");
      print("Categories Store Arr");
      print(temp);
      print("////////////////////////////////////////////");
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
      print("////////////////////////////////////////////");
      print("Listing Api Arr");
      print(temp);
      print("////////////////////////////////////////////");
      return temp;
    } else {
      for (var i in store.state.listingdModelList) {
        temp.add(i);
      }
      print("////////////////////////////////////////////");
      print("Listing Store Arr");
      print(temp);
      print("////////////////////////////////////////////");
      return temp;
    }
  }

  getNewListings(context) async {
    List temp = [];
    var result = await _apiListing.getDataCollection();
    for (var i in result.docs) {
      var cateModel = Listingmodel.fromMap(i.data());
      temp.add(cateModel);
    }
    StoreProvider.of<AppState>(context).dispatch(Updatelistings(payload: temp));
    print("////////////////////////////////////////////");
    print("New Listing Api Arr");
    print(temp);
    print("////////////////////////////////////////////");
    return temp;
  }
}
