import 'package:bubble_shooter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Ball Sort',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// App Ad Unit ID = ca-app-pub-7104002362240268~3062604967
// Banner Ad Unit ID = ca-app-pub-7104002362240268/6147965125
// Interstitial Ad Unit ID = ca-app-pub-7104002362240268/5522915649
// Rewarded Ad Unit ID = ca-app-pub-7104002362240268/1729357907
// Native Ad Unit ID = ca-app-pub-7104002362240268/9594022595