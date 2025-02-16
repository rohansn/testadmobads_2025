import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:testadmobads_2025/second_screen.dart';
import 'app_open_ad_manager.dart';

class HomePage extends StatefulWidget {
  final AppOpenAdManager appOpenAdManager;

  const HomePage({super.key, required this.appOpenAdManager});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late BannerAd _bannerAd;
  // bool _isBannerAdLoaded = false;
  // AdSize? _adSize;
  // @override
  // void initState() {
  //   super.initState();
  //   // Show an ad when the app starts
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     widget.appOpenAdManager.showAdIfAvailable();
  //   });
  //   // widget.appOpenAdManager.showAdIfAvailable();
  //   _loadBannerAd();
  // }

  // void _loadBannerAd() {
  //   _bannerAd = BannerAd(
  //     adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ID
  //     size: AdSize.banner,
  //     request: const AdRequest(),
  //     listener: BannerAdListener(
  //       onAdLoaded: (_) {
  //         setState(() {
  //           _isBannerAdLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (ad, error) {
  //         ad.dispose();
  //         setState(() {
  //           _isBannerAdLoaded = false;
  //         });
  //       },
  //     ),
  //   );
  //   _bannerAd.load();
  // }

  // @override
  // void dispose() {
  //   _bannerAd.dispose();
  //   super.dispose();
  // }

  static const _insets = 16.0;
  BannerAd? _inlineAdaptiveAd;
  bool _isLoaded = false;
  AdSize? _adSize;
  late Orientation _currentOrientation;

  double get _adWidth => MediaQuery.of(context).size.width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentOrientation = MediaQuery.of(context).orientation;
    _loadAd();
  }

  void _loadAd() async {
    await _inlineAdaptiveAd?.dispose();
    setState(() {
      _inlineAdaptiveAd = null;
      _isLoaded = false;
    });

    // Get an inline adaptive size for the current orientation.
    // AdSize size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
    //   _adWidth.truncate(),
    // );

    AdSize size = AdSize.getInlineAdaptiveBannerAdSize(360,50);
    _inlineAdaptiveAd = BannerAd(
      // TODO: replace this test ad unit with your own ad unit.
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          print('Inline adaptive banner loaded: ${ad.responseInfo}');

          // After the ad is loaded, get the platform ad size and use it to
          // update the height of the container. This is necessary because the
          // height can change after the ad is loaded.
          BannerAd bannerAd = (ad as BannerAd);
          final AdSize? size = await bannerAd.getPlatformAdSize();
          if (size == null) {
            print('Error: getPlatformAdSize() returned null for $bannerAd');
            return;
          }

          setState(() {
            _inlineAdaptiveAd = bannerAd;
            _isLoaded = true;
            _adSize = size;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Inline adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    await _inlineAdaptiveAd!.load();
  }

  /// Gets a widget containing the ad, if one is loaded.
  ///
  /// Returns an empty container if no ad is loaded, or the orientation
  /// has changed. Also loads a new ad if the orientation changes.
  Widget _getAdWidget() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_currentOrientation == orientation &&
            _inlineAdaptiveAd != null &&
            _isLoaded &&
            _adSize != null) {
          return Align(
            child: Container(
              width: _adWidth,
              height: _adSize!.height.toDouble(),
              child: AdWidget(ad: _inlineAdaptiveAd!),
            ),
          );
        }
        // Reload the ad if the orientation changes.
        if (_currentOrientation != orientation) {
          _currentOrientation = orientation;
          _loadAd();
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log(MediaQuery.of(context).size.width.toString());
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 50,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SecondScreen(
                            appOpenAdManager: widget.appOpenAdManager,
                          ),
                    ),
                  );
                },
                child: const Text('Go to Second Screen'),
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: _getAdWidget(),
            // _isBannerAdLoaded
            //     ? Container(
            //       height: _bannerAd.size.height.toDouble(),
            //       width: double.maxFinite,
            //       color: Colors.white,
            //       child: AdWidget(ad: _bannerAd),
            //     )
            //     : SizedBox(),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.0,
        color: Colors.red,
        // height: 100,
        child: Column(
          children: [Container(height: 10.0, color: Colors.amberAccent)],
        ), // Space for BottomAppBar
      ),
      // bottomSheet:
      //     _isBannerAdLoaded
      //         ? Container(
      //           height: _bannerAd.size.height.toDouble(),
      //           width: _bannerAd.size.width.toDouble(),
      //           color: Colors.white,
      //           child: AdWidget(ad: _bannerAd),
      //         )
      //         : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _inlineAdaptiveAd?.dispose();
  }
}
