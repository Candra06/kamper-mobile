import 'package:flutter/material.dart';
import 'package:kamper/akun/add_akun.dart';
import 'package:kamper/akun/edit_akun.dart';
import 'package:kamper/akun/edit_profil.dart';
import 'package:kamper/akun/list_akun.dart';
import 'package:kamper/auth/login.dart';
import 'package:kamper/auth/splash.dart';
import 'package:kamper/home.dart';
import 'package:kamper/home/dashboard.dart';
import 'package:kamper/penyakit/add_penyakit.dart';
import 'package:kamper/penyakit/detail_penyakit.dart';
import 'package:kamper/penyakit/edit_penyakit.dart';
import 'package:kamper/tanaman/add_tanaman.dart';
import 'package:kamper/tanaman/detail_tanaman.dart';
import 'package:kamper/tanaman/edit_tanaman.dart';
import 'package:kamper/tanaman/list_tanaman.dart';

class Routes {
  static const String HOME = '/';
  static const String SPLASH = '/splash_screen';
  static const String HOME_PAGE = '/home_page';
  static const String LOGIN = '/login';
  static const String DASHBOARD = '/dashboard';
  static const String ADD_TANAMAN = '/add_tanaman';
  static const String ADD_PENYAKIT = '/add_penyakit';
  static const String LIST_TANAMAN_ADM = '/list_tanaman_adm';
  static const String LIST_TANAMAN = '/list_tanaman';
  static const String LIST_PENYAKIT_ADM = '/list_penyakit_adm';
  static const String LIST_PENYAKIT = '/list_penyakit';
  static const String AKUN = '/akun';
  static const String EDIT_AKUN = '/edit_akun';
  static const String EDIT_PROFIL = '/edit_profil';
  static const String ADD_AKUN = '/add_akun';
  static const String ABOUT = '/about';
  static const String DETAIL_TANAMAN = '/detail_tanaman';
  static const String DETAIL_PENYAKIT = '/detail_penyakit';
  static const String EDIT_PENYAKIT = '/edit_penyakit';
  static const String EDIT_TANAMAN = '/edit_tanaman';

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch (settings.name) {
      case SPLASH:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case HOME_PAGE:
        return MaterialPageRoute(builder: (_) => HomePage());
      case LOGIN:
        return MaterialPageRoute(builder: (_) => PageLogin());
      case DASHBOARD:
        return MaterialPageRoute(builder: (_) => Dashoard(settings.arguments.toString()));
      case ADD_TANAMAN:
        return MaterialPageRoute(builder: (_) => PageAddTanaman());
      case ADD_PENYAKIT:
        return MaterialPageRoute(builder: (_) => PageAddPeyakit());
      case LIST_PENYAKIT:
        return MaterialPageRoute(builder: (_) => PageAddPeyakit());
      case LIST_PENYAKIT_ADM:
        return MaterialPageRoute(builder: (_) => PageAddPeyakit());
      case LIST_TANAMAN:
        return MaterialPageRoute(builder: (_) => PageListTanaman());
      case LIST_TANAMAN_ADM:
        return MaterialPageRoute(builder: (_) => PageAddPeyakit());
      case AKUN:
        return MaterialPageRoute(builder: (_) => PageListAkun());
      case ADD_AKUN:
        return MaterialPageRoute(builder: (_) => PageAddAkun());
      case ABOUT:
        return MaterialPageRoute(builder: (_) => PageAddPeyakit());
      case EDIT_AKUN:
        return MaterialPageRoute(builder: (_) => PageEditAkun(settings.arguments.toString()));
      case EDIT_PROFIL:
        return MaterialPageRoute(builder: (_) => PageEditProfil(settings.arguments.toString()));
      case EDIT_TANAMAN:
        return MaterialPageRoute(builder: (_) => PageEditTanaman(settings.arguments.toString()));
      case EDIT_PENYAKIT:
        return MaterialPageRoute(builder: (_) => PageEditPenyakit(settings.arguments.toString()));
      case DETAIL_TANAMAN:
        return MaterialPageRoute(builder: (_) => PageDetailTanaman(settings.arguments.toString()));
      case DETAIL_PENYAKIT:
        return MaterialPageRoute(builder: (_) => PageDetailPenyakit(settings.arguments.toString()));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Container())
          ));
    }

  }
}