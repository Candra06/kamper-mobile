import 'package:flutter/material.dart';
import 'package:kamper/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes.dart';

class SideAkun extends StatefulWidget {
  @override
  _SideAkunState createState() => _SideAkunState();
}

class _SideAkunState extends State<SideAkun> {
  String nama = '';
  String email = '';
  String id = '';

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("token", '');
    Navigator.pushReplacementNamed(context, Routes.LOGIN);
  }

  Future<dynamic> getData() async {
    String data = await Config.getInfo();
    List<String> hasil = data.split("#");
    setState(() {
      nama = hasil[0];
      email = hasil[1];
      id = hasil[2];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                    Config.darkprimary,
                    Config.darkprimary,
                    Config.primary
                  ])),
              child: Column(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'Profile Anda',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(57.0),
                      child: Image.asset("assets/images/user.png", fit: BoxFit.fill,),
                     
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      nama,
                      // "Admin",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Text(
                      email,
                      // "admin@kamper.com",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )),
                
              ]),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: new Column(children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.EDIT_PROFIL, arguments: id.toString());
                  },
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: new Row(children: <Widget>[
                      new Container(
                          margin: EdgeInsets.fromLTRB(8, 8, 16, 8),
                          child: new Icon(
                            Icons.border_color,
                            color: Config.darkprimary,
                            size: 25.0,
                          )),
                      new Flexible(
                          child: Container(
                              width: double.infinity,
                              child: Text(
                                'Update Profile',
                                style: TextStyle(fontSize: 14),
                              ))),
                      new ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 25,
                          maxWidth: 110,
                        ),
                        child: Container(
                            child: new IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            // Navigator.pushNamed(context, Routes.EDIT_PROFILE);
                          },
                        )),
                      ),
                    ]),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.AKUN);
                  },
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: new Row(children: <Widget>[
                      new Container(
                          margin: EdgeInsets.fromLTRB(8, 8, 16, 8),
                          child: new Icon(
                            Icons.person,
                            color: Config.darkprimary,
                            size: 25.0,
                          )),
                      new Flexible(
                          child: Container(
                              width: double.infinity,
                              child: Text(
                                'Data Akun',
                                style: TextStyle(fontSize: 14),
                              ))),
                      new ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 25,
                          maxWidth: 110,
                        ),
                        child: Container(
                            child: new IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            // Navigator.pushNamed(context, Routes.EDIT_PASSWORD);
                          },
                        )),
                      ),
                    ]),
                  ),
                ),
                
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, Routes.TOS);
                  },
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: new Row(children: <Widget>[
                      new Container(
                          margin: EdgeInsets.fromLTRB(8, 8, 16, 8),
                          child: new Icon(
                            Icons.perm_device_information,
                            color: Config.darkprimary,
                            size: 25.0,
                          )),
                      new Flexible(
                          child: Container(
                              width: double.infinity,
                              child: Text(
                                'Tentang',
                                style: TextStyle(fontSize: 14),
                              ))),
                      new ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 25,
                          maxWidth: 110,
                        ),
                        child: Container(
                            child: new IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            // banned(context);
                          },
                        )),
                      ),
                    ]),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    logOut();
                  },
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: new Row(children: <Widget>[
                      new Container(
                          margin: EdgeInsets.fromLTRB(8, 8, 16, 8),
                          child: new Icon(
                            Icons.power_settings_new,
                            color: Config.darkprimary,
                            size: 25.0,
                          )),
                      new Flexible(
                          child: Container(
                              width: double.infinity,
                              child: Text(
                                'Keluar',
                                style: TextStyle(fontSize: 14),
                              ))),
                      new ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 25,
                          maxWidth: 110,
                        ),
                        child: Container(
                            child: new IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            // banned(context);
                          },
                        )),
                      ),
                    ]),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}