import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kamper/home/akun.dart';
import 'package:kamper/home/home.dart';
import 'package:kamper/home/penyakit.dart';
import 'package:kamper/home/tanaman.dart';
import 'package:kamper/utils/config.dart';

class Dashoard extends StatefulWidget {
  String indexPage = '';
  Dashoard(this.indexPage);
  @override
  _DashoardState createState() => _DashoardState(this.indexPage);
}

class _DashoardState extends State<Dashoard> {
  String indexPage = '';
  _DashoardState(this.indexPage);


  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Apakah anda yakin?'),
            content: new Text('Ingin keluar dari aplikasi ini.'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Tidak'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Iya'),
              ),
            ],
          ),
        )) ??
        false;
  }
  void page(){
    setState(() {
      currentIndex = int.parse(indexPage);
    });
  }
  
  int currentIndex = 0, lasttab = 0;

  void incrementTab(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    page();
    super.initState();
  }

  final List<Widget> screens = [
    PageHome(),
    SideTanaman(),
    SidePenyakit(),
    SideAkun(),
  ];
  Widget currentScreen = PageHome();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
          child: new Scaffold(
          body: screens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            fixedColor: Config.darkprimary,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  title: new Text(
                    'Beranda',
                    style: TextStyle(),
                  )),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.local_florist,
                  ),
                  title: new Text('Tanaman')),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.bug_report,
                  ),
                  title: new Text('Penyakit')),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  title: new Text('Akun'))
            ],
            onTap: (index){
                setState(() {
                  lasttab = currentIndex;
                  currentIndex = index;
                  currentScreen = screens[index];
                });
            },
          )),
    );
  }
}
