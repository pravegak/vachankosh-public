import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vachankosh/constants/app_colors.dart';
import 'package:vachankosh/locator.dart';
import 'package:vachankosh/ui/views/startup_view.dart';
import 'package:vachankosh/utils/router.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor:AppColors.primaryColor));
  //Register Services and ViewModel
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vachan Kosh',
      home: StartupView(),
      theme: ThemeData(
        accentColor: AppColors.accentColor,
        buttonColor: AppColors.primaryColor,
        bottomNavigationBarTheme:
            BottomNavigationBarThemeData(unselectedItemColor: Colors.blueGrey),
        scaffoldBackgroundColor: Colors.blueGrey[50],
        primaryColor: AppColors.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
