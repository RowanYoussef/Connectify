import 'package:Connectify/Routers/routeGen.dart';
import 'package:Connectify/themes/themeManager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
    runApp(ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, _)=>MaterialApp(
      title: 'Connectify',
      theme: themeManager.currentTheme,
      initialRoute: '/',
      onGenerateRoute: RouteGen.generateRoute
    ));
  }
}

