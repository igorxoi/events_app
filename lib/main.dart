import 'package:events_app/pages/event.dart';
import 'package:events_app/pages/explore.dart';
import 'package:events_app/pages/favorite.dart';
import 'package:events_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/explore': (context) => const ExplorePage(),
        '/favorite': (context) => const FavoritePage(),
        '/event': (context) => const EventPage(),
      },
    );
  }
}
