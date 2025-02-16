


import 'package:flutter/material.dart';
import 'package:testadmobads_2025/second_screen.dart';
import 'app_open_ad_manager.dart';

class HomePage extends StatefulWidget {
  final AppOpenAdManager appOpenAdManager;

  const HomePage({super.key, required this.appOpenAdManager});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Show an ad when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appOpenAdManager.showAdIfAvailable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SecondScreen(appOpenAdManager: widget.appOpenAdManager),
              ),
            );
          },
          child: const Text('Go to Second Screen'),
        ),
      ),
    );
  }
}

