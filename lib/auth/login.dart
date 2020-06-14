import 'package:flutter/material.dart';
import 'package:kamper/utils/config.dart';
import 'package:kamper/utils/fade_animation.dart';
import 'package:kamper/utils/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../routes.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  bool _isHidden = true;
  // name untuk form input
  TextEditingController txemail = new TextEditingController();
  TextEditingController txpassword = new TextEditingController();
  // method untuk show/hide password
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Config.darkprimary,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: new Text(
          'Login',
          style: TextStyle(color: Config.darkprimary),
        ),
        flexibleSpace:
            new Container(decoration: new BoxDecoration(color: Colors.white)),
      ),
      body: Stack(children: <Widget>[
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(5, 30, 5, 30),
                child: Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  FadeAnimation(
                    1.0,
                    Image(
                      image: AssetImage(
                        'assets/images/nature.png',
                      ),
                      height: 100.0,
                      width: 200.0,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Halo,",
                        style: kTitleStyleReguler,
                      )),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Selamat Datang",
                        style: kTitleStyle,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.5,
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            buildTextField(" Silahkan Masukkan Email", txemail),
                            SizedBox(
                              height: 20.0,
                            ),
                            buildTextField(" Password", txpassword),
                            SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                      1.5,
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                        decoration: new BoxDecoration(
                          gradient: LinearGradient(colors: <Color>[
                            Config.darkprimary,
                            Config.primary
                          ]),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FlatButton(
                          padding: EdgeInsets.only(top: 13, bottom: 13),
                          onPressed: () {
                            if (txemail.text.isEmpty) {
                              Config.alert(2, "Email Tidak Boleh Kosong");
                            } else if (txpassword.text.isEmpty) {
                              Config.alert(2, "Password Tidak Boleh Kosong");
                            } else {
                              showLoading(context);
                            }
                            // Navigator.pushNamed(context, Routes.DASHBOARD);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            'Masuk',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )),
                ]),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  // method untuk menampilkan loading dan request login
  showLoading(context) async {
    Config.loading(context);
    var body = new Map<String, dynamic>();
    body['email'] = txemail.text;
    body['password'] = txpassword.text;
    // request untuk login
    var res =
        await http.post(Uri.encodeFull(Config.ipWeb + "login"), body: body);
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var token = data['success']['token'].toString();
      print("tokennnya " + token);
      // request untuk mendapatkan info detail akun
      var info = await http.post(
        Config.ipWeb + 'details',
        headers: {
          'Authorization': "Bearer $token",
        },
      );
      print(info.body);
      var getInfo = json.decode(info.body);
      var nama = getInfo['data']['name'].toString();
      var email = getInfo['data']['email'].toString();
      var id = getInfo['data']['id'].toString();
      print('nama : ' +
          nama +
          ' email : ' +
          email +
          'id : ' +
          id);
      Config.alert(1, "Login Berhasil");
      // menyimpan data detail akun ke local storage
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString("token", token);
      await preferences.setString("name", nama);
      await preferences.setString("email", email);
      await preferences.setString("id", id);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamed(context, Routes.DASHBOARD, arguments: 0.toString());
      });
    } else {
      Config.alert(2, "Login Gagal. Silahkan Cek Kembali Email/Password Anda");
      Navigator.pop(context);
    }
    return true;
  }

  // widget untuk form input
  Widget buildTextField(String hintText, TextEditingController txparam) {
    return Container(
      margin: EdgeInsets.only(bottom: 0),
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
        color: Config.textinput,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        controller: txparam,
        keyboardType: hintText != " Password"
            ? TextInputType.emailAddress
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          border: InputBorder.none,
          prefixIcon: Container(
            margin: EdgeInsets.only(right: 3),
            child: new IconButton(
              icon: hintText != " Password"
                  ? Icon(
                      Icons.email,
                      color: Colors.grey,
                    )
                  : Icon(Icons.lock, color: Colors.grey),
              onPressed: () => {},
            ),
          ),
          //icon show/hide password
          suffixIcon: hintText == " Password"
              ? IconButton(
                  onPressed: _toggleVisibility, //memanggil method untuk show/hide password
                  icon: _isHidden
                      ? Icon(
                          Icons.visibility_off,
                          color: Config.primary,
                        )
                      : Icon(
                          Icons.visibility,
                          color: Config.primary,
                        ),
                )
              : null,
        ),
        obscureText: hintText == " Password" ? _isHidden : false, // menampilkan/menyembunyikan karakter password
      ),
    );
  }
}
