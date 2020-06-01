import 'package:flutter/material.dart';
import 'package:kamper/routes.dart';
import 'package:kamper/utils/config.dart';
import 'package:kamper/utils/fade_animation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html_editor/html_editor.dart';

class PageEditPenyakit extends StatefulWidget {
  String kode;
  PageEditPenyakit(this.kode);
  @override
  _PageEditPenyakitState createState() => _PageEditPenyakitState(this.kode);
}

class _PageEditPenyakitState extends State<PageEditPenyakit> {
  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  GlobalKey<HtmlEditorState> keyPenanggulangan = GlobalKey();
  GlobalKey<HtmlEditorState> keyPencegahan = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  String token = '';
  String value = '';
  String penanggulangan = '';
  String pencegahan = '';
  String _mySelection;
  String kode;
  List tanaman1 = List();
  List<DropdownMenuItem<String>> menuItem = new List();

  TextEditingController txtnama = new TextEditingController();
  TextEditingController txtciripenyakit = new TextEditingController();
  TextEditingController txttanaman = new TextEditingController();
  TextEditingController txtpencegahan = new TextEditingController();
  TextEditingController txtpenanggulangan = new TextEditingController();
  TextEditingController txtdeskripsi = new TextEditingController();

  _PageEditPenyakitState(this.kode);

  Future getTanaman() async {
    token = await Config.getToken();
    http.Response response = await http.get(
      Config.ipWeb + 'getPlants',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        tanaman1 = data["data"];
      });
    }
  }

  Future getDetail() async {
    token = await Config.getToken();
    http.Response response = await http.get(
      Config.ipWeb + 'getDetailDesease/$kode',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        txtnama.text = data['data'][0]['nama_penyakit'];
        txtdeskripsi.text = data['data'][0]['deskripsi'];
        value = data['data'][0]['ciri_penyakit'];
        pencegahan = data['data'][0]['pencegahan'];
        penanggulangan = data['data'][0]['penanggulangan'];
        _mySelection = data['data'][0]['id_tanaman'].toString();
      });
    }
  }

  @override
  void initState() {
    getTanaman();
    getDetail();
    print(kode);
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
          'Edit Penyakit',
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
                          'Silahkan lengkapi data penyakit/hama berikut dengan benar.',
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
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: Text('Pilih Tananaman'),
                                ),
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
                                        margin:
                                            EdgeInsets.only(top: 0, bottom: 0),
                                        padding:
                                            EdgeInsets.fromLTRB(20, 0, 20, 0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color.fromRGBO(
                                                      191, 191, 191, 1),
                                                  blurRadius: 3,
                                                  offset: Offset(0, 2))
                                            ]),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                                // color: Config.textinput,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child:
                                                    DropdownButtonHideUnderline(
                                                        child: ButtonTheme(
                                                  child: DropdownButton(
                                                    items: tanaman1.map((item) {
                                                      return new DropdownMenuItem(
                                                        child: new Text(item[
                                                            'nama_tanaman']),
                                                        value: item['id']
                                                            .toString(),
                                                      );
                                                    }).toList(),
                                                    value: _mySelection,
                                                    onChanged: (newVal) {
                                                      setState(() {
                                                        _mySelection = newVal;
                                                      });
                                                    },
                                                  ),
                                                )))
                                          ],
                                        ),
                                      ),
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
                                            controller: txtnama,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Masukkan Nama Penyakit/hama",
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
                                                    "Masukkan Deskripsi Penyakit",
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
                        2.4,
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
                                        child: HtmlEditor(
                                          hint: "Masukkan Ciri-Ciri Penyakit",
                                          value: value,
                                          key: keyEditor,
                                          
                                          height: 300,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      FadeAnimation(
                        2.6,
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
                                        child: HtmlEditor(
                                          hint: "Masukkan Cara Penanggulangan",
                                          value: penanggulangan,
                                          key: keyPenanggulangan,
                                          
                                          height: 300,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      FadeAnimation(
                        2.8,
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
                                        child: HtmlEditor(
                                          hint: "Masukkan Cara Pencegahan",
                                          value: pencegahan,
                                          key: keyPencegahan,
                                          
                                          height: 300,
                                        ),
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
                            onPressed: () async{
                              final ciri = await keyEditor.currentState.getText();
                              final penanggulangan = await keyPenanggulangan.currentState.getText();
                              final pencegahan = await keyPencegahan.currentState.getText();
                                setState(() {
                                  txtciripenyakit.text = ciri;
                                  txtpenanggulangan.text = penanggulangan;
                                  txtpencegahan.text = pencegahan;
                                  simpanData(context);
                                });
                              if (txtnama.text == '') {
                                Config.alert(2, "Nama Masih kosong!");
                              } else if (txtdeskripsi.text == '') {
                                Config.alert(2, "Deskripsi Masih kosong!");
                              } else if (txtciripenyakit.text == '') {
                                Config.alert(
                                    2, "Ciri-ciri penyakit Masih kosong!");
                              } else if (txtpenanggulangan.text == '') {
                                Config.alert(2, "Penanggulangan Masih kosong!");
                              } else if (txtpencegahan.text == '') {
                                Config.alert(2, "Pencegahan Masih kosong!");
                              } else if (_mySelection == '') {
                                Config.alert(2, "Harap pilih nama tanaman!");
                              } else {
                                
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
    body['nama_penyakit'] = txtnama.text;
    body['ciri_penyakit'] = txtciripenyakit.text;
    body['id_tanaman'] = _mySelection;
    body['deskripsi'] = txtdeskripsi.text;
    body['penanggulangan'] = txtpenanggulangan.text;
    body['pencegahan'] = txtpencegahan.text;

    var token = await Config.getToken();

    var res = await http.post(Uri.encodeFull(Config.ipWeb + "updateDesease/$kode"),
        body: body,
        headers: {
          'Authorization': 'Bearer $token',},);

    if (res.statusCode == 200) {
      Config.alert(1, "Berhasil mengubah data");
   
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushNamed(context, Routes.DASHBOARD, arguments: 2.toString());
      });
    } else {
      Config.alert(2, "Gagal menambahkan data, Silahkan periksa kembali data anda!");
      Navigator.pop(context);
    }
    return true;
  }
}
