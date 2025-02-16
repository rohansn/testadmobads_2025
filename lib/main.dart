

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'home.dart';
import 'app_open_ad_manager.dart';
import 'app_lifecycle_reactor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

   SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky, // Hides status bar & navigation buttons
  );

  // Initialize the App Open Ad Manager
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  appOpenAdManager.loadAd();

  // Listen for app foreground events
  AppLifecycleReactor(appOpenAdManager: appOpenAdManager)
      .listenToAppStateChanges();

  runApp(MyApp(appOpenAdManager: appOpenAdManager));
}

class MyApp extends StatelessWidget {
  final AppOpenAdManager appOpenAdManager;

  const MyApp({super.key, required this.appOpenAdManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Ads Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.indigo,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(appOpenAdManager: appOpenAdManager),
    );
  }
}

