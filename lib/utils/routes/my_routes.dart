
import 'package:flutter/material.dart';

import '../../screen/home/view/home_screen.dart';
import '../../screen/splash/view/splash_screen.dart';

Map<String,WidgetBuilder> myAppRoutes={
  "/":(context)=> SplashScreen(),
  "home":(context)=> HomeScreen(),
};