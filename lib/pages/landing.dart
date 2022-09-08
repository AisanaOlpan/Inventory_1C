import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_1c/domain/AuthUser.dart';
import 'package:inventory_1c/pages/auth.dart';
import 'package:inventory_1c/pages/homepage.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthUser? user = Provider.of<AuthUser?>(context); 
    final bool isLoggedIn = user != null;
   //  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return isLoggedIn ? HomePage(): AuthorizationPage();
  }
}