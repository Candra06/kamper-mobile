import 'package:flutter/material.dart';
import 'package:kamper/routes.dart';
import 'package:kamper/utils/config.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;


class PageListAkun extends StatefulWidget {
  @override
  _PageListAkunState createState() => _PageListAkunState();
}

class _PageListAkunState extends State<PageListAkun> {
  TextEditingController search = TextEditingController();
  bool isSearch = false;
  bool loadPage = true;
  String _searchText = "";
  List dataAkun = new List();
  List nama = new List();
  String token = "";
  GlobalKey<RefreshIndicatorState> refresh;

  Icon _searchIcon = new Icon(
    Icons.search,
    color: Config.darkprimary,
  );
  Widget _appBarTitle = new Text(
    'Akun',
    style: TextStyle(color: Config.darkprimary),
  );

  _PageListAkunState(){
    search.addListener(() {
      if (search.text.isEmpty) {
        setState(() {
          _searchText = "";
          dataAkun = nama;
        });
      } else {
        setState(() {
          _searchText = search.text;
        });
      }
    });
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
              icon: Icon(Icons.search, color: Colors.black38),
              hintText: "Cari nama akun"),
        );
      } else {
        
        this._searchIcon = new Icon(Icons.search, color: Config.darkprimary,);
        this._appBarTitle = new Text('Akun Admin', style: TextStyle(color: Config.darkprimary));
        dataAkun = nama;
        search.clear();
      }
    });
  }

  Future getData() async {
    setState(() {
      loadPage = true;
    });
    List tmpList = new List();
    token = await Config.getToken();
    http.Response response = await http.get(
      Config.ipWeb + 'getUser',
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (int i = 0; i < data['data'].length; i++) {
        tmpList.add(data['data'][i]);
      }
      setState(() {
        nama = tmpList;
        nama.shuffle();
        dataAkun = nama;
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
      Config.ipWeb + 'deleteUser/'+id.toString(),
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
    } else if (dataAkun == null) {
      return Config.panelkosong("Data Akun Kosong");
    } else {
      if (!(_searchText.isEmpty ?? true)) {
        List<dynamic> tempList = List();
        for (int i = 0; i < dataAkun.length; i++) {
          if (dataAkun[i]['name'].toLowerCase().contains(_searchText.toLowerCase())) {
            tempList.add(dataAkun[i]);
            print(tempList);
          }
        }
        dataAkun = tempList;
      }
      return Container(
        child: ListView.builder(
            itemCount: dataAkun == null ? 0 : dataAkun.length,
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
                        Text(dataAkun[index]["name"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        Container(
                          margin: EdgeInsets.only(top:8),
                          child: Text(dataAkun[index]["email"])),
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
                            Navigator.pushNamed(context, Routes.EDIT_AKUN, arguments: dataAkun[index]['id']);
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            alertDialog(dataAkun[index]["id"]);
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

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: false,
      automaticallyImplyLeading: true,
      leading: IconButton(icon: Icon(Icons.arrow_back, color: Config.darkprimary,), onPressed: (){Navigator.pop(context);}),
      title: _appBarTitle,
      flexibleSpace: new Container(color: Colors.white),
      actions: <Widget>[
        Container(
            margin: EdgeInsets.only(right: 8),
            child: GestureDetector(
                onTap: () {
                  _searchPressed();
                },
                child: _searchIcon))
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
          Navigator.pushNamed(context, Routes.ADD_AKUN);
        },
        child: Icon(Icons.add,),
        backgroundColor: Config.darkprimary,),
    );
  }
}