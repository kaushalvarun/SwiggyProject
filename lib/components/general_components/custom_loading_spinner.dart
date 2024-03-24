import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomLoadingSpinner extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;
  const CustomLoadingSpinner({
    super.key,
    required this.videoPlayerController,
    required this.looping,
    required this.autoplay,
  });

  @override
  State<CustomLoadingSpinner> createState() => _CustomLoadingSpinnerState();
}

class _CustomLoadingSpinnerState extends State<CustomLoadingSpinner> {
  late ChewieController chewieController;
  bool _showSpinner = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _showSpinner = true;
    });

    chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      autoInitialize: true,
      autoPlay: widget.autoplay,
      looping: widget.looping,
      showControls: false,
      errorBuilder: (context, errorMessage) {
        return const Center(
          child: Text("Something went wrong"),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showSpinner
        ? Chewie(
            controller: chewieController,
          )
        : const SizedBox();
  }
}
