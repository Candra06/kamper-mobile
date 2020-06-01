import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:kamper/routes.dart';
import 'package:kamper/utils/config.dart';
import 'package:kamper/utils/fade_animation.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'dart:async';

class PageEditTanaman extends StatefulWidget {
  String kode;
  PageEditTanaman(this.kode);
  @override
  _PageEditTanamanState createState() => _PageEditTanamanState(this.kode);
}

class _PageEditTanamanState extends State<PageEditTanaman> {
  final _formKey = GlobalKey<FormState>();
  String fileName = '';
  Future<File> foto;
  File tmpfile;
  String base64;
  String kode = '';
  String image = '';

  String token = '';
  _PageEditTanamanState(this.kode);
  Map data;

  TextEditingController txtnama = new TextEditingController();
  TextEditingController txtnamalatin = new TextEditingController();
  TextEditingController txtordo = new TextEditingController();
  TextEditingController txtkingdom = new TextEditingController();
  TextEditingController txtasaltanaman = new TextEditingController();
  TextEditingController txtdeskripsi = new TextEditingController();

  Future<dynamic> getDetail() async {
    token = await Config.getToken();
    print(Config.ipWeb + 'getDetailPlants/$kode');
    http.Response res =
        await http.get(Config.ipWeb + 'getDetailPlants/$kode', headers: {
      'Authorization': 'Bearer $token',
    });
    data = jsonDecode(res.body);
    setState(() {
      txtnama.text = data["data"][0]["nama_tanaman"];
      txtnamalatin.text = data["data"][0]["nama_latin"];
      txtordo.text = data["data"][0]["ordo"];
      txtasaltanaman.text = data["data"][0]["asal"];
      txtdeskripsi.text = data["data"][0]["deskripsi"];
      txtkingdom.text = data["data"][0]["kingdom"];
      image = Config.ipServer + data["data"][0]["foto"];
      print('imagenya '+image);
    });
  }

  getImage(context) async {
    final imgSrc = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Pilih akses gambar"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Camera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Gallery"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            ));

    if (imgSrc != null) {
      setState(() {
        foto = ImagePicker.pickImage(source: imgSrc);
        String image = foto.toString();
        print('fotonya ' + image);
        print(foto);
      });
    }
  }

  Widget showImage() {
    return Container(
      child: FutureBuilder<File>(
        future: foto,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            tmpfile = snapshot.data;
            base64 = base64Encode(snapshot.data.readAsBytesSync());
            print(base64);
            return Container(
              margin: EdgeInsets.all(8),
              child: Image.file(snapshot.data, fit: BoxFit.fill),
            );
          } else if (snapshot.error != null) {
            return const Text(
              'Error saat memilih foto!',
              textAlign: TextAlign.center,
            );
          } else {
            return Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.all(8),
                    width: foto.toString() == '' ? 0 : 170,
                    height: foto.toString() == '' ? 0 : 170,
                    child: ClipRRect(
                        child: CachedNetworkImage(
                          imageUrl:
                              image.toString(),
                          height: 110,
                          width: 110,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                                      value: downloadProgress.progress),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        )),
                Text('Pilih foto anda')
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    getDetail();
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
          'Edit Tanaman',
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
                          'Silahkan lengkapi data tanaman berikut dengan benar.',
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
                                            // validator: (value) {
                                            //   if (!value.contains('@')) {
                                            //     return 'Email tidak valid!';
                                            //   }
                                            //   return null;
                                            // },
                                            controller: txtnama,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Masukkan Nama Tanaman",
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
                                            controller: txtnamalatin,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Masukkan Nama Latin",
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
                                            controller: txtordo,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Masukkan Ordo Tanaman",
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
                                            controller: txtkingdom,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                // prefixIcon: Icon(Icons.phone),
                                                hintText:
                                                    "Masukkan Kingom Tanaman",
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
                                            controller: txtasaltanaman,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                // prefixIcon: Icon(Icons.phone),
                                                hintText:
                                                    "Masukkan Asal Tanaman",
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
                                            maxLines: 6,
                                            controller: txtdeskripsi,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                // prefixIcon: Icon(Icons.),
                                                hintText:
                                                    "Masukkan Deskripsi Tanaman",
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
                      FadeAnimation(2.6, showImage()),
                      FadeAnimation(
                        2.8,
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
                              getImage(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.file_upload,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    ' Upload Foto tanaman',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ]),
                          ),
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
                                Config.alert(2, "Nama tanaman tidak valid!");
                              } else if (txtnamalatin.text == '') {
                                Config.alert(2, "Nama Latin tidak valid!");
                              } else if (txtkingdom.text == '') {
                                Config.alert(2, "Kingdom tidak valid!");
                              } else if (txtordo.text == '') {
                                Config.alert(2, "Ordo tidak valid!");
                              } else if (txtasaltanaman.text == '') {
                                Config.alert(2, "Asal tanaman tidak valid!");
                              } else if (txtdeskripsi.text == '') {
                                Config.alert(2, "deskripsi tidak sesuai!");
                              } else if (foto == null) {
                                Config.alert(2, "Foto masih kosong");
                              } else {
                                // Scaffold.of(context).showSnackBar(success);
                                simpanData(context);
                              }
                              // simpanData(context);
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
    body['nama_tanaman'] = txtnama.text;
    body['nama_latin'] = txtnamalatin.text;
    body['ordo'] = txtordo.text;
    body['kingdom'] = txtkingdom.text;
    body['asal'] = txtasaltanaman.text;
    body['deskripsi'] = txtdeskripsi.text;
    body['foto'] = 'data:image/png;base64,' + base64;

    var token = await Config.getToken();
    var res = await http.post(
      Uri.encodeFull(Config.ipWeb + "updatePlants/$kode"),
      body: body,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      Config.alert(1, "Berhasil mengubah data");

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamed(context, Routes.DASHBOARD, arguments: 1.toString());
      });
    } else {
      Config.alert(
          2, "Gagal mengubah data, Silahkan periksa kembali data anda!");
      Navigator.pop(context);
    }
    return true;
  }
}
