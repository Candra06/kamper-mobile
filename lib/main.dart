import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kamper/routes.dart';
import 'package:kamper/utils/config.dart';

import 'auth/app_config.dart';

void main(){
  MyApp.initSystemDefault();

    runApp(
      AppConfig(
        appName: "Kamper Dev",
        flavorName: "dev",
        initialRoute: Routes.SPLASH,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var initialRoute = AppConfig.of(context).initialRoute;
    return MaterialApp(
      theme: ThemeData(
        accentColor: Colors.green,
        fontFamily: 'Robot'
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: initialRoute,
      title: 'Kamus Pintar Pertanian',
    );
  }

  static void initSystemDefault() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Config.primary,
      ),
    );
  }
}

