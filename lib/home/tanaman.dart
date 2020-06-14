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
  TextEditingController search = TextEditingController(); // name untuk text input pencarian
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

  //default appbar title
  Widget _appBarTitle = new Text(
    'Tanaman',
    style: TextStyle(color: Config.darkprimary),
  );

  // constructor
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

  // ngambil data dari server
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

  // request untuk menghapus data
  Future deleteData(int id) async{
    token = await Config.getToken();
    // request ke server untuk manggil method hapus data bedasarkan id tanamana(id.toString)
    http.Response response = await http.get(
      Config.ipWeb + 'deletePlants/'+id.toString(),
      headers: {
        'Authorization': 'Bearer $token', // authentifikasi berdasarkan token, jika token == '' gk bisa ngirim request
      },
    ); 
    if (response.statusCode == 200) { // ketika request berhasil statusCode== 200
      setState(() {
        Config.alert(1, "Berhasil menghapus data"); // 
        loadPage = false;
        Navigator.pop(context);
        getData(); // memanggil method getData
      });
    } else { // ketika request merespon "Gagal"
      Config.alert(2, "Terjadi Kesalahan. Silahkan Coba Lagi");
      setState(() {
        loadPage = false;
      });
    }
  }

  // widget untuk load item
  Widget loadItem() {
    if (loadPage) {
      return Config.newloader("Memuat Data"); // menampilkan loading
    } else if (dataTanaman == null || dataTanaman.length == 0) {
      return Config.panelkosong("Data Tanaman Kosong"); // menampilkan jika tanaman kosong
    } else {
      if (!(_searchText.isEmpty ?? true)) { //jika text pencarian diisi
        List<dynamic> tempList = List();
        for (int i = 0; i < dataTanaman.length; i++) {
          if (dataTanaman[i]['nama_tanaman'].toLowerCase().contains(_searchText.toLowerCase())) { // menampilkan data tanaman berdasarkan text input
            tempList.add(dataTanaman[i]);
          }
        }
        dataTanaman = tempList;
      }
      return Container( // menampilkan data tanaman secara keseluruhan
        child: ListView.builder(
            itemCount: nama == null ? 0 : dataTanaman.length,
            itemBuilder: (BuildContext context, int i) {
              return item(i); // menampilkan data tanaman secara keseluruhan dengan card view index ke i
            }),
      );
    }
  }

  Widget item(index) { // menampilkan data tanaman secara keseluruhan dengan card view
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
                        Text(dataTanaman[index]["nama_tanaman"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),), // menampilkan nama tanaman
                        Container(
                          margin: EdgeInsets.only(top:8),
                          child: Text(dataTanaman[index]["nama_latin"], style: TextStyle(color: Colors.black45),)),  // menampilkan nama latin tanaman
                      ],
                    )),
                  Container(
                      child: Row(
                    children: <Widget>[
                      IconButton(  // icon untuk edit
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.EDIT_TANAMAN, arguments: dataTanaman[index]['id'].toString());  // menampilkan halaman edit dengan parameter id
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            alertDialog(dataTanaman[index]["id"]); // menampilkan alert konfirmasi penghapusan data berdasarkan id
                          }),
                    ],
                  ))
                ],
              )),
        );
  }

  // alert dialog konfirmasi hapus data
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
                    deleteData(id); // memanggil method hapus data berdasarkan id tanaman
                  },
                  child: Text('Hapus',
                      style: TextStyle(color: Config.darkprimary)))
            ],
          );
        });
  }

  // pull to refresh
  Future<Null> reload() async {
    await Future.delayed(Duration(milliseconds: 1500));
    getData();
  }

  @override
  void initState() { // method yang pertama kali dipanggil ketika page ditampilkan
    super.initState();
    refresh = GlobalKey<RefreshIndicatorState>();
    getData(); // memanggil method get data
  }

  // method ketika icon search di klik
  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) { // ketika variable _search icon == cari 
        this._searchIcon = new Icon(Icons.close, color: Colors.black54,); // variable _searchIcon menjadi icon close untuk membatakan pencarian
        this._appBarTitle = new TextField( // menampilkan text input pencarian
          textInputAction: TextInputAction.search,
          controller: search,
          decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              icon: Icon(Icons.search, color: Config.darkprimary),
              hintText: "Cari nama tanaman"),
        );
      } else {
        // menampilkan default appBar dengan judul Tanaman
        this._searchIcon = new Icon(Icons.search, color: Config.darkprimary,);
        this._appBarTitle = new Text('Tanaman', style: TextStyle(color: Config.darkprimary));
        dataTanaman = nama;
        search.clear();
      }
    });
  }

  // Widget untuk menampilkan appbar
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
                  onTap: () { //ketika icon search ditekan/diklik
                    _searchPressed();
                    setState(() {
                      isSearch = !isSearch; // isSearch menjadi true/false
                    });
                  },
                  child: !isSearch // isSearch == false maka akan menampikan icon cari
                      ? Icon(Icons.search, color: Config.darkprimary)
                      : Icon( // isSearch == true maka akan menampilkan icon X
                          Icons.close,
                          color: Config.darkprimary,
                        )))
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context), // memanggil widget AppBar
      body: Container(
        margin: EdgeInsets.all(8),
        child: RefreshIndicator( // widget untuk pull refresh
            key: refresh,
            onRefresh: () async {
              reload(); // memanggil method reload
            },
            child: Container(margin: EdgeInsets.all(8), child: loadItem())),
      ),
      floatingActionButton: FloatingActionButton( // floating action button dengan icon +
        onPressed: () {
          Navigator.pushNamed(context, Routes.ADD_TANAMAN); // pindah page ke Add data tanaman
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Config.darkprimary,
      ),
    );
  }
}
