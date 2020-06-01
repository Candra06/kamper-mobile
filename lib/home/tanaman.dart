import 'package:flutter/material.dart';
import 'package:kamper/routes.dart';
import 'package:kamper/utils/config.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class SideTanaman extends StatefulWidget {
  @override
  _SideTanamanState createState() => _SideTanamanState();
}

class _SideTanamanState extends State<SideTanaman> {
  TextEditingController search = TextEditingController();
  bool isSearch = false;
  bool loadPage = true;
  List dataTanaman = new List();
  List nama = new List();
  String _searchText = "";
  String token = "";
  GlobalKey<RefreshIndicatorState> refresh;

  Icon _searchIcon = new Icon(
    Icons.search,
    color: Config.darkprimary,
  );
  Widget _appBarTitle = new Text(
    'Tanaman',
    style: TextStyle(color: Config.darkprimary),
  );

  _SideTanamanState() {
    search.addListener(() {
      if (search.text.isEmpty) {
        setState(() {
          _searchText = "";
          dataTanaman = nama;
          print("belum mencari");
        });
      } else {
        setState(() {
          _searchText = search.text;
          print("mulai mencari");
        });
      }
    });
  }

  Future getData() async {
    setState(() {
      loadPage = true;
    });
    List tempList = new List();
    token = await Config.getToken();
    http.Response response = await http.get(
      Config.ipWeb + 'getPlants',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (int i = 0; i < data['data'].length; i++) {
        tempList.add(data['data'][i]);
      }
      setState(() {
        print(tempList);
        nama = tempList;
        nama.shuffle();
        dataTanaman = nama;
        loadPage = false;
      });
    } else {
      Config.alert(2, "Terjadi Kesalahan. Silahkan Coba Lagi");
      setState(() {
        loadPage = false;
      });
    }
  }

  Future deleteData(int id) async{
    token = await Config.getToken();
    http.Response response = await http.get(
      Config.ipWeb + 'deletePlants/'+id.toString(),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        Config.alert(1, "Berhasil menghapus data");
        loadPage = false;
        Navigator.pop(context);
        getData();
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
    } else if (dataTanaman == null) {
      return Config.panelkosong("Data Tanaman Kosong");
    } else {
      if (!(_searchText.isEmpty ?? true)) {
        List<dynamic> tempList = List();
        for (int i = 0; i < dataTanaman.length; i++) {
          if (dataTanaman[i]['nama_tanaman'].toLowerCase().contains(_searchText.toLowerCase())) {
            tempList.add(dataTanaman[i]);
            print(tempList);
          }
        }
        dataTanaman = tempList;
      }
      return Container(
        child: ListView.builder(
            itemCount: nama == null ? 0 : dataTanaman.length,
            itemBuilder: (BuildContext context, int i) {
              return item(i);
            }),
      );
    }
  }

  Widget item(index) {
    return Card(
          child: Container(
              margin: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(dataTanaman[index]["nama_tanaman"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        Container(
                          margin: EdgeInsets.only(top:8),
                          child: Text(dataTanaman[index]["nama_latin"], style: TextStyle(color: Colors.black45),)),
                      ],
                    )),
                  Container(
                      child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.EDIT_TANAMAN, arguments: dataTanaman[index]['id'].toString());
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            alertDialog(dataTanaman[index]["id"]);
                          }),
                    ],
                  ))
                ],
              )),
        );
  }

  Widget reloadPage() {
    return Container();
  }

  alertDialog(int id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Konfirmasi Hapus"),
            content: Text("Apakah anda ingin menghapus data tersebut?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Batal',
                    style: TextStyle(color: Colors.black45),
                  )),
              FlatButton(
                  onPressed: () {
                    deleteData(id);
                  },
                  child: Text('Hapus',
                      style: TextStyle(color: Config.darkprimary)))
            ],
          );
        });
  }

  Future<Null> reload() async {
    await Future.delayed(Duration(milliseconds: 1500));
    getData();
  }

  @override
  void initState() {
    super.initState();
    refresh = GlobalKey<RefreshIndicatorState>();
    getData();
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close, color: Colors.black54,);
        this._appBarTitle = new TextField(
          textInputAction: TextInputAction.search,
          controller: search,
          decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              icon: Icon(Icons.search, color: Config.darkprimary),
              hintText: "Cari nama tanaman"),
        );
      } else {
        
        this._searchIcon = new Icon(Icons.search, color: Config.darkprimary,);
        this._appBarTitle = new Text('Tanaman', style: TextStyle(color: Config.darkprimary));
        dataTanaman = nama;
        search.clear();
      }
    });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,
      
      title: _appBarTitle,
      flexibleSpace: new Container(color: Colors.white),
      actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 8),
              child: GestureDetector(
                  onTap: () {
                    _searchPressed();
                    setState(() {
                      isSearch = !isSearch;
                    });
                  },
                  child: !isSearch
                      ? Icon(Icons.search, color: Config.darkprimary)
                      : Icon(
                          Icons.close,
                          color: Config.darkprimary,
                        )))
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        margin: EdgeInsets.all(8),
        child: RefreshIndicator(
            key: refresh,
            onRefresh: () async {
              reload();
            },
            child: Container(margin: EdgeInsets.all(8), child: loadItem())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.ADD_TANAMAN);
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Config.darkprimary,
      ),
    );
  }
}
