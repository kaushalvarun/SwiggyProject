import 'package:flutter/material.dart';
import 'package:swiggy/components/general_components/custom_loading_spinner.dart';
import 'package:swiggy/pages/restaurant_page.dart';
import 'package:video_player/video_player.dart';

class LoadingRest extends StatefulWidget {
  final String restaurantName;
  final String userAddress;
  const LoadingRest({
    super.key,
    required this.restaurantName,
    required this.userAddress,
  });

  @override
  State<LoadingRest> createState() => _LoadingRestState();
}

class _LoadingRestState extends State<LoadingRest> {
  @override
  void initState() {
    super.initState();
    // Add a delay of 2 seconds before showing the spinner
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RestaurantPage(
                    restaurantName: widget.restaurantName,
                    userAddress: widget.userAddress)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (Center(
        child: SizedBox(
            height: 250,
            width: 250,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: (CustomLoadingSpinner(
                videoPlayerController: VideoPlayerController.asset(
                    'lib/assets/videos/restaurantLoading.mp4'),
                looping: true,
                autoplay: true,
              )),
            )),
      )),
    );
  }
}
