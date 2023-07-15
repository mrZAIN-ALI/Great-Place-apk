import 'package:flutter/material.dart';
import 'package:great_place/provider/greatPlace.dart';
import 'package:provider/provider.dart';
//
import './screens/Places_List_Screen.dart';
import './screens/add_Place_Scren.dart';
import './screens/Place_details.dart';

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
      child: SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme:  ThemeData(
          
                  fontFamily: "TimesNewRoman",
          
                  colorScheme: ColorScheme(
                    brightness: Brightness.light,
                    primary: Color(0xFF4A55A2),
                    onPrimary: Color(0xFFA0BFE0),
                    secondary: Color(0xFF7895CB),
                    onSecondary: Color(0xFFC5DFF8),
                    error: Colors.red,
                    onError: Colors.black,
                    background: Colors.white,
                    onBackground: Colors.red.shade300,
                    surface: Colors.white,
                    onSurface: Color(0xFFC5DFF8),
                  ),
                  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          
                  textTheme: const TextTheme(
                    displayLarge: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 52.0,
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
      
          routes: {
            AddPlaceScreen.routeName:(context) => AddPlaceScreen(),
          },
        ),
      ),
    );
  }
}
