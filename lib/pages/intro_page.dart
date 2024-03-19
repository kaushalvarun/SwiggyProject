import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:swiggy/components/general_components/my_button.dart';
import 'package:swiggy/pages/auth.dart';
import 'package:video_player/video_player.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late VideoPlayerController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    _controller =
        VideoPlayerController.asset("lib/assets/videos/swiggyIntro.mp4");
    _controller.initialize().then((_) {
      _controller.setLooping(true);
      _controller.play();
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  Widget _getVideoBackground() {
    return _visible
        ? Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _getVideoBackground(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.black87,
            child: MyButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const AuthPage(),
                  ),
                );
              },
              msg: 'Get Started',
              buttonColor: Colors.deepOrange[600]!,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
