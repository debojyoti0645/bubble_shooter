import 'package:bubble_shooter/screens/home_screen.dart';
import 'package:bubble_shooter/services/points_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  
  // Check and award welcome bonus
  await PointsService.claimWelcomeBonus();
  
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
// Banner 2 Ad Unit ID = ca-app-pub-7104002362240268/9413256865
// Interstitial Ad Unit ID = ca-app-pub-7104002362240268/5522915649
// Rewarded Ad Unit ID = ca-app-pub-7104002362240268/1729357907
// Native Ad Unit ID = ca-app-pub-7104002362240268/9594022595
// Native 2 Ad Unit ID = ca-app-pub-7104002362240268/8048204307