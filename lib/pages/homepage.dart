import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:inventory_1c/components/Instruction.dart';
import 'package:inventory_1c/components/ex.dart';
import 'package:inventory_1c/components/ListPageProduct.dart';
import 'package:inventory_1c/services/authFirebase.dart';
import 'package:repository/Warehouse_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/1cResponse.dart';
import '../components/scannerPage2.dart';

class HomePage extends StatefulWidget {
   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   int sectionIndex = 0;

  @override
  Widget build(BuildContext context) {
    
    return 
    Container(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Padding( padding: EdgeInsets.only(left: 10), child:Text(sectionIndex == 0 ? 'Склады из 1C' : 'Инструкция')),
     //   leading: SizedBox.shrink(),
        // Icon( sectionIndex == 0 ?
        //   Icons.room_preferences : Icons.integration_instructions,
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
      body: sectionIndex == 0 ? ExPage() : ActiveInstruction(),
      // bottomNavigationBar: CurvedNavigationBar(items: const<Widget >[
      //   Icon(Icons.home_filled ),
      //   Icon(Icons.integration_instructions )
      // ],
      // index: 0,
      // height: 50,
      // color: Colors.white.withOpacity(0.6),
      // buttonBackgroundColor: Colors.yellow,
      // backgroundColor: Colors.white.withOpacity(0.2),
      // animationCurve: Curves.easeInOut,
      // onTap: (int index){
      //    setState(() =>
      //      sectionIndex = index);} ,
      // ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white10,
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Меню',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Инструкция',
          )
        ],
        currentIndex: sectionIndex,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white30,
        onTap: (int index){
            setState(() =>
            sectionIndex = index);
        },
      ),
    ));
  }
}

