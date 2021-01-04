import 'package:hands2gether/redux/theme.model.dart';

class AppState {
  ThemeModel theme;
  String mydata;
  List categoryModelList;
  List listingdModelList;

  AppState(
      {this.theme,
      this.mydata,
      this.categoryModelList,
      this.listingdModelList});

  factory AppState.initial() {
    return AppState(
      theme: ThemeModel(
        bgColor: "0xffffffff",
        primaryColor: "0xffffca39",
        secoundaryColor: "0xff00b3b0",
        theme: "yellow",
      ),
      mydata: 'ramesh',
      categoryModelList: List.empty(),
      listingdModelList: List.empty(),
    );
  }

  AppState copyWith(
      {AppState prev,
      ThemeModel theme,
      String mydata,
      List categoryModelList,
      List listingdModelList}) {
    return AppState(
      theme: theme ?? prev.theme,
      mydata: mydata ?? prev.mydata,
      categoryModelList: categoryModelList ?? prev.categoryModelList,
      listingdModelList: listingdModelList ?? prev.listingdModelList,
    );
  }
}

// Action
class UpdateSearch {
  String payload;
  UpdateSearch({
    this.payload,
  });
}

class Updatecategory {
  List payload;
  Updatecategory({
    this.payload,
  });
}

class Updatelistings {
  List payload;
  Updatelistings({
    this.payload,
  });
}

// Reducer
AppState reducers(AppState prevState, dynamic action) {
  AppState newState;
  if (action is UpdateSearch) {
    if (action.payload == 'yellow') {
      newState = AppState().copyWith(
          prev: prevState,
          theme: ThemeModel(
              bgColor: "0xffffffff",
              primaryColor: "0xffffca39",
              secoundaryColor: "0xff00b3b0",
              theme: "yellow"));
    } else if (action.payload == 'cyan') {
      newState = AppState().copyWith(
          prev: prevState,
          theme: ThemeModel(
              bgColor: "0xffffffff",
              primaryColor: "0xff00b3b0",
              secoundaryColor: "0xffffca39",
              theme: "cyan"));
    }
  }
  if (action is Updatecategory) {
    newState =
        AppState().copyWith(prev: prevState, categoryModelList: action.payload);
  }
  if (action is Updatelistings) {
    newState =
        AppState().copyWith(prev: prevState, listingdModelList: action.payload);
  }

  return newState;
}
