import 'package:flutter/material.dart';
import 'package:kamper/routes.dart';
import 'package:kamper/utils/config.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class PageListTanaman extends StatefulWidget {
  @override
  _PageListTanamanState createState() => _PageListTanamanState();
}

class _PageListTanamanState extends State<PageListTanaman> {
  TextEditingController search = TextEditingController();
  bool isSearch = false;
  bool loadPage = true;
  String _searchText = "";
  // List<dynamic> dataTanaman;
  List dataNama = new List();
  List nama = new List();
  var items = List<String>();
  GlobalKey<RefreshIndicatorState> refresh;

  Icon _searchIcon = new Icon(
    Icons.search,
    color: Config.darkprimary,
  );
  Widget _appBarTitle = new Text(
    'Tanaman',
    style: TextStyle(color: Config.darkprimary),
  );

  _PageListTanamanState() {
    search.addListener(() {
      if (search.text.isEmpty) {
        setState(() {
          _searchText = "";
          dataNama = nama;
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
              hintText: "Cari nama tanaman"),
        );
      } else {
        
        this._searchIcon = new Icon(Icons.search, color: Config.darkprimary,);
        this._appBarTitle = new Text('Tanaman', style: TextStyle(color: Config.darkprimary));
        dataNama = nama;
        search.clear();
      }
    });
  }

  Future getData() async {
    setState(() {
      loadPage = true;
    });
    List tempList = new List();
    http.Response response = await http.get(
      Config.ipWeb + 'viewPlants',
    );
    print(response.body);
    if (response.statusCode == 200) {
      
      var data = json.decode(response.body);
      for (int i = 0; i < data['data'].length; i++) {
        tempList.add(data['data'][i]);
      }
      setState(() {
        print(tempList);
        nama = tempList;
        nama.shuffle();
        dataNama = nama;
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
    } else if (dataNama == null || dataNama.length == 0) {
      return Config.panelkosong("Data Tanaman Kosong");
    } else {
      if (!(_searchText.isEmpty ?? true)) {
        List<dynamic> tempList = List();
        for (int i = 0; i < dataNama.length; i++) {
          if (dataNama[i]['nama_tanaman'].toLowerCase().contains(_searchText.toLowerCase())) {
            tempList.add(dataNama[i]);
            print(tempList);
          }
        }
        dataNama = tempList;
      }
      return Container(
        child: ListView.builder(
            itemCount: nama == null ? 0 : dataNama.length,
            itemBuilder: (BuildContext context, int i) {
              return item(i);
            }),
      );
    }
  }

  Widget item(index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.DETAIL_TANAMAN,
            arguments: dataNama[index]['id'].toString());
      },
      child: Card(
        child: Container(
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dataNama[index]["nama_tanaman"],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    dataNama[index]["nama_latin"],
                    style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black45),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget reloadPage() {
    return Container();
  }

  Future<Null> reload() async {
    await Future.delayed(Duration(milliseconds: 1500));
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
  void initState() {
    getData();
    super.initState();
    refresh = GlobalKey<RefreshIndicatorState>();
    
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
    );
  }
}
