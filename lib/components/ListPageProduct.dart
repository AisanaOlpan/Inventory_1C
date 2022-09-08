import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:inventory_1c/components/scannerPage2.dart';
import 'package:inventory_1c/pages/homepage.dart';
import 'package:models/models.dart';
import 'package:models/tmz_models.dart';
import 'package:repository/TMZ_repository.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../services/authFirebase.dart';

class Listpage extends StatefulWidget {
  final String WarehouseCode;
  final bool TMZ;
  @override
  Listpage({Key? key, required this.WarehouseCode, required this.TMZ})
      : super(key: key);

  State<Listpage> createState() => _Listpage();
}

class _Listpage extends State<Listpage> {
  
  var tmzLists;
  Future functionForBuilder() async {
    // setState(() {
    tmzLists =  await tmzRepository().getAllTMZ(widget.WarehouseCode);
    return tmzLists;
    //   });
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    setState(() {
      // Listpage(WarehouseCode: widget.WarehouseCode, TMZ: widget.TMZ)
      //     .createState();
      tmzLists = functionForBuilder();
    });
    super.initState();

    //Restart.restartApp(webOrigin: '[your main route]');
  }

  @override
  void dispose() {
    super.dispose();
  }
  sendTMZData() async {
    String username = 'Администратор'; //_emailInputText;
    String password = '  '; //_pwdInputText;
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var url =
        'http://1c.vct.kz:1998/Demo_buh_Aisana/hs/MobileIntegrate/create_doc/';

    var bodyresponse =
        ''; //tmzRepository().getAllTMZjson(widget.WarehouseCode) ;
    var json = tmzLists.map((e) => e.toJson()).toString();
    // var json = jsonEncode(tmzLists, toEncodable: (e) => e.toJsonAttr());
    final response = await post(Uri.parse(url),
        body: json, headers: <String, String>{'authorization': basicAuth});

    if (response.statusCode == 200) {
      String result = response.body;
      setState(() {
        tmzRepository().deleteAllTMZ(widget.WarehouseCode);
        Fluttertoast.showToast(
            msg: result,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            // timeInSecForIosWeb: 1, для ios
            backgroundColor: Colors.yellow,
            textColor: Colors.white,
            fontSize: 16.0);
      });

      print(response.body);
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    String _selectedMenu = '';
    var warehousesList = Expanded(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(widget.TMZ ? 'Товары' : 'Основные средства')),
        // leading: Icon(
        //   Icons.production_quantity_limits,
        //   color: Colors.white,
        // ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                AuthService().logOut();
              },
              icon: Icon(
                Icons.supervised_user_circle,
                color: Colors.white54,
              ),
              label: SizedBox
                  .shrink()) //SizedBox.shrink( )- просто занимает место и заполняет обязательный параметр
        ],
      ),
      body: FutureBuilder(
        future:  tmzRepository().getAllTMZ(widget.WarehouseCode),//tmzLists, //this.functionForBuilder(), //:osRepository().getAllOS(widget.WarehouseCode),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // if(widget.TMZ){
          final ListProduct = snapshot.data as List<tmz_Model>;
          if (ListProduct.length == 0) {}
          return buildTMZList(ListProduct);
          // }
          // else{
          //    final ListProduct = snapshot.data as List<Model>;
          //    return buildOSList(ListProduct);
          // }
        },
      ),
      floatingActionButton: SpeedDial(
        //Speed dial menu
        //marginBottom: 10, //margin bottom
        icon: Icons.menu, //icon on Floating action button
        activeIcon: Icons.close, //icon when menu is expanded on button
        backgroundColor: Colors.yellow, //background color of button
        foregroundColor: Colors.white, //font color, icon color in button
        activeBackgroundColor:
            Colors.deepPurpleAccent, //background color when menu is expanded
        activeForegroundColor: Colors.white,
        buttonSize: Size(50.5, 50.5), //button size
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'), // action when menu opens
        onClose: () => print('DIAL CLOSED'), //action when menu closes
        //   childMargin: EdgeInsets.only(top:103),
        elevation: 8.0, //shadow elevation of button
        //  shape: CircleBorder(), //shape of button

        children: [
          SpeedDialChild(
            //speed dial child

            child: Icon(Icons.qr_code_scanner),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Сканировать',
            labelStyle: TextStyle(fontSize: 14.0, color: Colors.white),
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ScanPage2(WarehouseCode: widget.WarehouseCode)))
                  .then((value) => setState(() {}));
              print('FIRST CHILD');
            },
            onLongPress: () => print('FIRST CHILD LONG PRESS'),
            labelBackgroundColor: Colors.white12,
            shape: CircleBorder(),
          ),
          SpeedDialChild(
            child: Icon(Icons.document_scanner),
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.white,
            label: 'Создать документ',
            labelStyle: TextStyle(fontSize: 14.0, color: Colors.white),
            onTap: () {
              sendTMZData();
              print('SECOND CHILD');
            },
            onLongPress: () => print('SECOND CHILD LONG PRESS'),
            labelBackgroundColor: Colors.white12,
            shape: CircleBorder(),
          ),
          SpeedDialChild(
            child: Icon(Icons.home),
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            labelBackgroundColor: Colors.white12,
            shape: CircleBorder(),
            label: 'Главное меню',
            labelStyle: TextStyle(fontSize: 14.0, color: Colors.white),
            onTap: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()))
                  .then((value) => setState(() {}));
              print('THIRD CHILD');
            },
            onLongPress: () => print('THIRD CHILD LONG PRESS'),
          ),

          //add more menu item childs here
        ],
      ),
    ));

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                this.functionForBuilder();
              });
            },
            backgroundColor: Colors.yellow,
            color: Colors.white,
            child: Column(
              children: <Widget>[warehousesList],
            )));
  }

  Widget buildOSList(List<Model> osl) => ListView.builder(
        itemCount: osl.length,
        itemBuilder: (context, index) {
          final os = osl[index];

          return Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: Card(
                        color: Colors.white12,
                        child: ListTile(
                          title: Text(os.title),
                          subtitle: Text(
                            os.code,
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        },
      );

  Widget buildTMZList(List<tmz_Model> tmzl) => ListView.builder(
        itemCount: tmzl.length,
        itemBuilder: (context, index) {
          final tmz = tmzl[index];

          return Dismissible(
              key: UniqueKey(),
              background: Container(color: Colors.red),
              onDismissed: (direction) {
                tmzRepository().deleteTMZ(tmz);
              },
              child: Container(
                 margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 90,
                          child: Card(
                            color: Colors.white12,
                            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(

                              title: Padding(child: Text(tmz.title), padding: EdgeInsets.only(top:10),),
                              subtitle: Column(children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    tmz.code,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      tmz.quantity.toString() + 'шт',
                                      style: TextStyle(color: Colors.white),
                                    ))
                              ]),
                              // trailing: IconButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       tmzRepository().deleteTMZ(tmz);
                              //     });
                              //   },
                              //   icon: const Icon(Icons.delete, color: Colors.red),
                              // ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScanPage2(
                                            WarehouseCode: widget.WarehouseCode,
                                            tmz: tmz))).then(
                                    (value) => setState(() {}));
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )));
        },
      );



}
