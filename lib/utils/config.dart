import 'package:flutter/material.dart';
import 'hex_color.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static Color primary = HexColor("#00E98C");
  static Color darkprimary = HexColor("#00CBB6");
  static final HexColor textinput = new HexColor("#EFEFEF");
  static final String ipServer = "http://kamper.evoindo.com/";
  static final String ipWeb = ipServer+"api/";
  static final String linkImage = ipServer+"storage/app/plants/";

  static newloader(pesan) {
    return Center(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitHourGlass(color: Config.darkprimary, size: 50.0),
          
          new Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: new Text(
                pesan,
                style: new TextStyle(color: Colors.black54, fontSize: 16.0),
              ),
            ),
          )
        ],
      ),
    );
  }
  
  static alert(tipe, pesan) {
    Fluttertoast.showToast(
        msg: pesan,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: (tipe == 1 ? Colors.green : Colors.red),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static panelkosong(pesan) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[new Text(pesan)],
      ),
    );
  }

  static loading(context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
              // backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 200.0,
                  width: 200.0,
                  padding: EdgeInsets.all(18),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Shimmer.fromColors(
                        baseColor: Config.darkprimary,
                        highlightColor: Colors.greenAccent,
                        child: Image(
                          image: AssetImage(
                            'assets/images/nature.png',
                          ),
                          height: 100.0,
                          width: 100.0,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Text(
                        "Silahkan Tunggu",
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )));
        });
  }

  // nama, email, id
  static getInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String nama = '';
    String email = '';
    String id = '';
    nama = preferences.getString('name');
     email = preferences.getString('email');
     id = preferences.getString('id');
    String data = nama + "#" + email + "#" + id+ "#";
    return data;
  }

  // token 
  static getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString('token');
    print(token);
    return token;
  }
}