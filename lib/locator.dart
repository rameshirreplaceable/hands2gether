import 'package:get_it/get_it.dart';
import 'package:hands2gether/common/share.service.dart';
import 'package:hands2gether/firebase/services.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactoryParam((param1, param2) => Api(param1));
  locator.registerFactoryParam((param1, param2) => ShareService());
}
