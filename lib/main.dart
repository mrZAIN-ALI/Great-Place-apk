import 'package:flutter/material.dart';
import 'package:great_place/provider/greatPlace.dart';
import 'package:provider/provider.dart';
//
import './screens/Places_List_Screen.dart';

void main() {
  //asdasdasd
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlace(),
      //
      child: MaterialApp(
        title: 'Flutter Demo',
        theme:  ThemeData(
    
                fontFamily: "TimesNewRoman",
    
                colorScheme: ColorScheme(
                  brightness: Brightness.light,
                  primary: Colors.purple.shade400,
                  onPrimary: Color.fromARGB(255, 255, 255, 255),
                  secondary: Colors.purple.shade900,
                  onSecondary: Colors.purple.shade300,
                  error: Colors.red,
                  onError: Colors.black,
                  background: Colors.white,
                  onBackground: Colors.red.shade300,
                  surface: Colors.white,
                  onSurface: Color.fromARGB(255, 238, 155, 82),
                ),
                // colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
    
                textTheme: const TextTheme(
                  displayLarge: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 72.0,
                      fontWeight: FontWeight.bold),
                  titleLarge: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 36.0,
                      fontWeight: FontWeight.normal),
                  bodyMedium: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 25.0,
                      fontWeight: FontWeight.normal),
                  bodySmall: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal),
                ),
              ),
        home: PlaceListScreen(),
      ),
    );
  }
}
