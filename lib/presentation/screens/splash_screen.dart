import 'package:flutter/material.dart';
import 'package:nibav/presentation/screens/home_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _leftDoorAnimation;
  late Animation<double> _rightDoorAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController with a 2-second duration
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    // Define animations to move the doors off-screen
    _leftDoorAnimation = Tween<double>(begin: 0.0, end: -1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rightDoorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start the animation after a 1-second delay
    Future.delayed(Duration(seconds: 1), () {
      _animationController.forward();
      _playLiftOpenSound();
    });

    // Navigate to the home screen when the animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  void _playLiftOpenSound() async {
    await _audioPlayer.play(AssetSource('audio/door.mp3'));  // Play the audio file
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Left door animation
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_leftDoorAnimation.value * screenWidth, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: screenWidth / 2,
                    height: screenHeight,
                    child: Image.asset('assets/images/door1.png', fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
          // Right door animation
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_rightDoorAnimation.value * screenWidth, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: screenWidth / 2,
                    height: screenHeight,
                    child: Image.asset('assets/images/door2.png', fit: BoxFit.cover),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

