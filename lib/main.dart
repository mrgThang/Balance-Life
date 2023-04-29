import 'package:flutter/material.dart';
import 'package:app/screens/login_page.dart';
import 'package:camera/camera.dart';
import 'package:app/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.camera});

  final CameraDescription camera;

  final Map<int, Color> color = {
    50: const Color.fromRGBO(4, 131, 184, .1),
    100: const Color.fromRGBO(4, 131, 184, .2),
    200: const Color.fromRGBO(4, 131, 184, .3),
    300: const Color.fromRGBO(4, 131, 184, .4),
    400: const Color.fromRGBO(4, 131, 184, .5),
    500: const Color.fromRGBO(4, 131, 184, .6),
    600: const Color.fromRGBO(4, 131, 184, .7),
    700: const Color.fromRGBO(4, 131, 184, .8),
    800: const Color.fromRGBO(4, 131, 184, .9),
    900: const Color.fromRGBO(4, 131, 184, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // primarySwatch: MaterialColor(APP_COLORS.GRAY, color),
          // fontFamily: 'Signika',
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            elevation: 0.0,
            backgroundColor: Colors.white10,
            iconTheme: IconThemeData(color: Color(APP_COLORS.GRAY)),
            foregroundColor: Color(APP_COLORS.GRAY),
          )),
      home: LoginPage(title: 'Login', camera: camera),
    );
  }
}
