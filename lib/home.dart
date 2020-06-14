import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kamper/routes.dart';
import 'package:kamper/utils/config.dart';
import 'package:kamper/utils/fade_animation.dart';
import 'package:kamper/utils/hex_color.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token = '';
  void getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString('token');
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Apakah anda yakin?'),
            content: new Text('Ingin keluar dari aplikasi ini.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Tidak'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Iya'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FadeAnimation(
                  1.8,
                  Center(
                    child: new Container(
                        margin: EdgeInsets.fromLTRB(16, 32, 16, 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Selamat Datang di,',
                                style: TextStyle(
                                    color: HexColor('#312E34'),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                                child: Text(
                                  "KAMPER",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: HexColor('#22CBA7')),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                'Kamus Pertanian',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45),
                              )
                            ])),
                  ),
                ),
                FadeAnimation(
                  2.0,
                  new Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      margin: EdgeInsets.all(16),
                      child: Image(
                        image: AssetImage('assets/images/plant.png'),
                      )),
                ),
                FadeAnimation(
                  2.2,
                  new Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(16, 32, 16, 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(colors: <Color>[
                          HexColor("#00CBB6"),
                          HexColor("#00E98C"),
                        ])),
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.LIST_TANAMAN);
                        },
                        child: Text('Kamus Pertanian',
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
                FadeAnimation(
                  2.4,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: OutlineButton(
                      padding: EdgeInsets.only(top: 13, bottom: 13),
                      color: HexColor('#00CBB6'),
                      borderSide: BorderSide(
                          color: HexColor("#00CBB6"),
                          style: BorderStyle.solid,
                          width: 1),
                      onPressed: () {
                       
                          if (token == null) {
                            Navigator.pushNamed(context, Routes.LOGIN);
                            print('Login dulu');
                          } else {
                            Navigator.pushNamed(context, Routes.DASHBOARD, arguments: 0.toString());
                            print('Dashboard dulu');
                          }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'Login',
                        style:
                            TextStyle(color: HexColor('#00CBB6'), fontSize: 14),
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
