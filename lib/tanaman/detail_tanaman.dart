import 'package:flutter/material.dart';
import 'package:kamper/utils/config.dart';
import 'package:kamper/utils/hex_color.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import '../routes.dart';

class PageDetailTanaman extends StatefulWidget {
  String kode;
  PageDetailTanaman(this.kode);
  @override
  _PageDetailTanamanState createState() => _PageDetailTanamanState(this.kode);
}

class _PageDetailTanamanState extends State<PageDetailTanaman> {
  String kode = '';
  bool loadPage = true;
  _PageDetailTanamanState(this.kode);

  String nama = '';
  String namaLlatin = '';
  String ordo = '';
  String kingdom = '';
  String asal = '';
  String deskripsi = """""";
  String foto = '';

  String namaPenyakit = "";
  String idPenyakit = "";
  List<dynamic> listPenyakit;

  Map data;
  Map dataPenyakit;

  Future getDetail() async {
    http.Response res = await http.get(Config.ipWeb + 'viewDetailPlants/$kode');
    data = jsonDecode(res.body);
    setState(() {
      nama = data["data"][0]["nama_tanaman"];
      namaLlatin = data["data"][0]["nama_latin"];
      ordo = data["data"][0]["ordo"];
      kingdom = data["data"][0]["kingdom"];
      asal = data["data"][0]["asal"];
      deskripsi = data["data"][0]["deskripsi"];
      foto = data["data"][0]["foto"].toString();
      print(Config.ipWeb+foto.toString());
    });
  }

  Future getPenyakit() async {
    setState(() {
      loadPage = true;
    });
    http.Response res = await http.get(Config.ipWeb + 'viewDesease/$kode');
    data = jsonDecode(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      setState(() {
        listPenyakit = data["data"];
        loadPage = false;
      });
    } else {
      Config.alert(2, "Terjadi Kesalahan. Silahkan Coba Lagi");
      setState(() {
        loadPage = false;
      });
    }
  }

  Widget loadItem() {
    if (loadPage) {
      return Config.newloader("Memuat Data");
    } else if (listPenyakit == null) {
      return Config.panelkosong("Data Tanaman Kosong");
    } else {
      return Container(
        child: ListView.builder(
            itemCount: listPenyakit == null ? 0 : listPenyakit.length,
            itemBuilder: (BuildContext context, int i) {
              return item(i);
            }),
      );
    }
  }

  Widget item(index) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.DETAIL_PENYAKIT,
              arguments: listPenyakit[index]['id'].toString());
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top: 4, bottom: 4),
            child: Text(
              listPenyakit[index]["nama_penyakit"],
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ));
  }

  @override
  void initState() {
    getDetail();
    super.initState();
    getPenyakit();
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
            'Detail Tanaman',
            style: TextStyle(color: Config.darkprimary),
          ),
          flexibleSpace: new Container(color: Colors.white),
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxHeight: 150.0),
                child: Material(
                  color: HexColor('#fffff'),
                  child: TabBar(
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle:
                        TextStyle(fontWeight: FontWeight.normal),
                    indicatorColor: Config.darkprimary,
                    labelColor: Config.darkprimary,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: 'Detail'),
                      Tab(text: 'Penyakit'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [detail(), penyakit()],
                ),
              ),
            ],
          ),
        ));
  }

  detail() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
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
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: foto == '' ? Config.newloader("Memuat Data") : CachedNetworkImage(
                imageUrl: Config.ipServer + foto.toString(),
                height: 110,
                width: 110,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    CircularProgressIndicator(value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              //  Image.network(
              //   Config.ipServer+foto.toString(),
              //   fit: BoxFit.fill,
              // ),
            ),
            Container(
                margin: EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Nama latin ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      namaLlatin,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Ordo ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      ordo,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Kingdom ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      kingdom,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Asal ',
                      style: TextStyle(color: Colors.black54),
                    ),
                    Text(
                      asal,
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Deskripsi ',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                )),
            Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        """$deskripsi""",
                        style: TextStyle(color: Colors.black54),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  penyakit() {
    return Container(margin: EdgeInsets.all(10), child: loadItem());
  }
}
