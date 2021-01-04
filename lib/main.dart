import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:hands2gether/route_generator.dart';

import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:hands2gether/locator.dart';
import 'package:hands2gether/redux/store.dart';

Store<AppState> store;
void main() async {
  /**
   * Locater setup
   */
  setupLocator();
  /**
   * Store Initialized
   */
  store = Store<AppState>(reducers, initialState: AppState.initial());

  WidgetsFlutterBinding.ensureInitialized();

  /**
   * FireBase Init
   */
  await Firebase.initializeApp();

  /**
   * Global Font licence setting
   */
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store store;
  const MyApp({Key key, this.store}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      // statusBarBrightness:
      //     Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Hands2Gether',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xffffca39),
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(TextTheme()),
          platform: TargetPlatform.iOS,
        ),
        // home: AuthService().handleAuth(),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
