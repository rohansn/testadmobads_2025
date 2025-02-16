import 'package:flutter/material.dart';
import 'app_open_ad_manager.dart';

class SecondScreen extends StatefulWidget {
  final AppOpenAdManager appOpenAdManager;

  const SecondScreen({super.key, required this.appOpenAdManager});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    super.initState();
    // Show ad when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appOpenAdManager.showAdIfAvailable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: const Center(
        child: Text('This is the second screen'),
      ),
    );
  }
}
