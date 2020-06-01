import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kamper/utils/config.dart';
import 'package:http/http.dart' as http;
import 'package:kamper/utils/fade_animation.dart';

class PageHome extends StatefulWidget {
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {

  String nama = '';
  int plant = 0;
  int user = 0;
  int desease = 0;
  String token = '';

  Future<dynamic> getData() async {
    String data = await Config.getInfo();
    List<String> hasil = data.split("#");
    setState(() {
      nama = hasil[0];
      
    });
  }

  Future<dynamic> countPlant() async{
    token = await Config.getToken();
    http.Response res = await http.get(
      Config.ipWeb + 'countPlant',
      headers: {
        'Authorization': 'Bearer $token',
      },);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print(res.body);
        setState(() {
          plant = data['data'];
        });
      } else {
        Config.alert(2, "Terjadi Kesalahan. Silahkan Coba Lagi");
      }
  }
  Future<dynamic> countDesease() async{
    token = await Config.getToken();
    http.Response res = await http.get(
      Config.ipWeb + 'countDesease',
      headers: {
        'Authorization': 'Bearer $token',
      },);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        print(res.body);
        setState(() {
          desease = data['data'];
        });
      } else {
        Config.alert(2, "Terjadi Kesalahan. Silahkan Coba Lagi");
      }
  }
  Future<dynamic> countUser() async{
    token = await Config.getToken();
    http.Response res = await http.get(
      Config.ipWeb + 'countUser',
      headers: {
        'Authorization': 'Bearer $token',
      },);
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        setState(() {
          user = data['data'];
        });
      } else {
        Config.alert(2, "Terjadi Kesalahan. Silahkan Coba Lagi");
      }
  }

  @override
  void initState() {
    getData();
    countDesease();
    countPlant();
    countUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width;
    return new SafeArea(
        child: new Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          FadeAnimation(1.4,
                       new Container(
              height: 300,
              child: Stack(
                children: <Widget>[
                  FadeAnimation(1.2, 
                    new Container(
                    width: cWidth,
                    padding: EdgeInsets.only(right: 16, left: 16, top: 20),
                    height: 200,
                    decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                            bottomLeft: Radius.circular(35),
                            bottomRight: Radius.circular(35)),
                        gradient: new LinearGradient(
                          colors: <Color>[Config.darkprimary, Config.primary],
                          end: Alignment(1.5, 0.0),
                        )),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Selamat Datang",
                          style: new TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        new Text(
                          nama,
                          style: new TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: new Container(
                          decoration: new BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              color: Colors.transparent,
                              borderRadius: new BorderRadius.circular(20.0)),
                          width: cWidth,
                          margin: EdgeInsets.only(right: 16, left: 16),
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Text(plant.toString(),
                                            style: TextStyle(
                                                color: Config.darkprimary,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        child: Text('Data Tanaman',
                                            style:
                                                TextStyle(color: Colors.black45)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8, bottom: 8),
                                  height: 50,
                                  child: VerticalDivider(
                                    color: Colors.black45,
                                    width: 10,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Text(desease.toString(),
                                            style: TextStyle(
                                                color: Config.darkprimary,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        child: Text('Data Penyakit',
                                            style:
                                                TextStyle(color: Colors.black45)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 8, bottom: 8),
                                  height: 50,
                                  child: VerticalDivider(
                                    color: Colors.black45,
                                    width: 10,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Text(user.toString(),
                                            style: TextStyle(
                                                color: Config.darkprimary,
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Container(
                                        child: Text(
                                          'Data Akun',
                                          style: TextStyle(color: Colors.black45),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
