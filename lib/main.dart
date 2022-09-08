// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventory_1c/pages/landing.dart';
import 'package:inventory_1c/services/authFirebase.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/1cResponse.dart';
import 'package:inventory_1c/domain/AuthUser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance(); // Хранилище
  bool firstTime = (prefs.getBool('firstTime')); // Получаем значение, если пустое ставим true
  if (firstTime == null) {
    loadData2();
    prefs.setBool('firstTime', true);
  }
  runApp(InventoryApp());
}

class InventoryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthUser>.value(
      value: AuthService().currentUser,
      initialData: null,
      child: MaterialApp(
          title: 'Inventory 1C',
          theme: ThemeData(
            primaryColor: Color.fromARGB(255, 33, 33, 33),
            textTheme: TextTheme(
              titleMedium: TextStyle(color: Colors.white),
            ),
          ),
          home: LandingPage() // zdes nachinaetsya stranitsa
          ),
    );
  }
}
