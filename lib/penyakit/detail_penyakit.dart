import 'package:flutter/material.dart';
import 'package:kamper/utils/config.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';


class PageDetailPenyakit extends StatefulWidget {
  String kode = '';
  PageDetailPenyakit(this.kode);
  @override
  _PageDetailPenyakitState createState() => _PageDetailPenyakitState(this.kode);
}

class _PageDetailPenyakitState extends State<PageDetailPenyakit> {
  String kode = '';
  _PageDetailPenyakitState(this.kode);

  String nama = '';
  String ciri= '';
  String deskripsi = '';
  String penanggulangan = '';
  String pencegahan = '';

  Map data;

  Future getDetail() async {
    http.Response res = await http.get(Config.ipWeb + 'viewDetailDesease/$kode');
    data = jsonDecode(res.body);
    print(data);
    setState(() {
      nama = data["data"][0]["nama_penyakit"];
      ciri = """data['data'][0]['ciri_penyakit']""";
      penanggulangan = """data["data"][0]["penanggulangan"]""";
      pencegahan = """data["data"][0]["pencegahan"]""";
      deskripsi = """$data['data'][0]['deskripsi']""";
    });
  }

  @override
  void initState() {
    print(kode);
    getDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Config.darkprimary,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Detail Penyakit',
            style: TextStyle(color: Config.darkprimary),
          ),
          flexibleSpace: new Container(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                margin: EdgeInsets.only(top: 4, bottom: 8),
                child: Center(
                  child: Text(nama,
                      style: TextStyle(
                          color: Config.darkprimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )),
                Container(
                  margin: EdgeInsets.only(bottom: 8, top: 8),
                  child: Text('Ciri-ciri', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: HtmlWidget(ciri, textStyle: TextStyle(color: Colors.black54),),
                 
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8, top: 8),
                  child: Text('Deskripsi', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: HtmlWidget(deskripsi)
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8, top: 8),
                  child: Text('Penanggulangan', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: HtmlWidget(penanggulangan)
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8, top: 8),
                  child: Text('Pencegahan', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),)
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  child: HtmlWidget(pencegahan)
                )
              ]
            ),
          ),
        ),
    );
  }
}