import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_random_color_pallete_generator/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shake/shake.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/font/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color pallete generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int palleteLength = 5;
  late List<Color> _pallete = ColorUtils.generateRandomPallete(palleteLength);
  late ShakeDetector _shakeDetector;

  @override
  void initState() {
    super.initState();
    ShakeDetector.autoStart(
      onPhoneShake: () {
        setState(() {
          _pallete = ColorUtils.generateRandomPallete(palleteLength);
        });
      },
    );
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Color Palette Generator",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pallete.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            String hexColor =
                                _pallete[index].toString().substring(10, 16);
                            Clipboard.setData(ClipboardData(text: hexColor));
                            Fluttertoast.showToast(
                              msg: "Color #$hexColor copied to your clipboard",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              fontSize: 16.0,
                            );
                          },
                          child: Ink(
                            height: MediaQuery.of(context).size.height / 9,
                            decoration: BoxDecoration(
                              color: _pallete[index],
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Center(
                              child: Text(
                                '#${_pallete[index].toString().substring(10, 16)}',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              height: 55,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _pallete =
                          ColorUtils.generateRandomPallete(palleteLength);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Generate",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Or just shake your phone to generate new palettes.",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
