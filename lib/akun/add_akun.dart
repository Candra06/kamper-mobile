import 'package:flutter/material.dart';
import 'package:kamper/routes.dart';
import 'package:kamper/utils/config.dart';
import 'package:kamper/utils/fade_animation.dart';
import 'package:http/http.dart' as http;


class PageAddAkun extends StatefulWidget {
  @override
  _PageAddAkunState createState() => _PageAddAkunState();
}

class _PageAddAkunState extends State<PageAddAkun> {
  
 final _formKey = GlobalKey<FormState>();
  String token = '';
  String value = '';
  List tanaman1 = List();
  List<DropdownMenuItem<String>> menuItem = new List();

  TextEditingController txtnama = new TextEditingController();
  TextEditingController txtemail = new TextEditingController();
  TextEditingController txtpassword = new TextEditingController();

  

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Config.darkprimary,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: new Text(
          'Tambah Akun Admin',
          style: TextStyle(color: Config.darkprimary),
        ),
        flexibleSpace:
            new Container(decoration: new BoxDecoration(color: Colors.white)),
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
                margin: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 16),
                        child: new Text(
                          'Silahkan lengkapi data akun berikut dengan benar.',
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      
                      FadeAnimation(
                        1.8,
                        Container(
                          padding: EdgeInsets.all(8),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 0),
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  decoration: BoxDecoration(
                                    color: Config.textinput,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: TextFormField(
                                            controller: txtnama,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Masukkan Nama ",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none)),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),

                      FadeAnimation(
                        2.0,
                        Container(
                          padding: EdgeInsets.all(8),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 0),
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  decoration: BoxDecoration(
                                    color: Config.textinput,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: TextFormField(
                                            controller: txtemail,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Masukkan email",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none)),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),

                      FadeAnimation(
                        2.2,
                        Container(
                          padding: EdgeInsets.all(8),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 0),
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  decoration: BoxDecoration(
                                    color: Config.textinput,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: TextFormField(
                                            controller: txtpassword,
                                            
                                            obscureText: true,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Masukkan Password",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey),
                                                border: InputBorder.none)),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      
                      FadeAnimation(
                        3.0,
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          decoration: new BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Config.darkprimary,
                                Config.primary,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: FlatButton(
                            padding: EdgeInsets.only(top: 13, bottom: 13),
                            color: Colors.transparent,
                            onPressed: () {
                              if (txtnama.text == '') {
                                Config.alert(2, "Nama Masih kosong!");
                              } else if (txtemail.text == '') {
                                Config.alert(2, "Email Masih kosong!");
                              } else if (txtpassword.text == '') {
                                Config.alert(
                                    2, "Password penyakit Masih kosong!");
                              } else {
                                simpanData(context);
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              'Simpan',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
      }),
    );
  }

  simpanData(context) async {
    Config.loading(context);
    var body = new Map<String, dynamic>();
    body['name'] = txtnama.text;
    body['email'] = txtemail.text;
    body['password'] = txtpassword.text;

    var token = await Config.getToken();

    var res = await http.post(Uri.encodeFull(Config.ipWeb + "add"),
        body: body,
        headers: {
          'Authorization': 'Bearer $token',},);

    if (res.statusCode == 200) {
      Config.alert(1, "Berhasil menambahkan data");
   
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamed(context, Routes.AKUN);
      });
    } else {
      Config.alert(2, "Gagal menambahkan data, Silahkan periksa kembali data anda!");
      Navigator.pop(context);
    }
    return true;
  }

 
}