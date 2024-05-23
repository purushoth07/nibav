import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentFloor = 0;
  int _targetFloor = 0;
  Timer? _timer;
  bool _movingUp = false;
  final AudioPlayer _audioPlayer = AudioPlayer();



  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _moveToFloor(int floor) {
    _targetFloor = floor;
    if (_currentFloor != _targetFloor) {
      setState(() {
        _movingUp = _currentFloor < _targetFloor;
      });
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_currentFloor < _targetFloor) {
            _currentFloor++;
          } else if (_currentFloor > _targetFloor) {
            _currentFloor--;
          }
          if (_currentFloor == _targetFloor) {
            timer.cancel();
            playAudio(_currentFloor);
          }
        });
      });
    }
  }

  void playAudio(int floor) async{
    String audioFileName;
    switch (floor) {
      case 1:
        audioFileName = 'audio/1st_floor.mp3';
        break;
      case 2:
        audioFileName = 'audio/2nd_floor.mp3';
        break;
      case 3:
        audioFileName = 'audio/3rd_floor.mp3';
        break;
      case 4:
        audioFileName = 'audio/4th_floor.mp3';
        break;
      case 5:
        audioFileName = 'audio/5th_floor.mp3';
        break;
      case 6:
        audioFileName = 'audio/6th_floor.mp3';
        break;
      case 7:
        audioFileName = 'audio/7th_floor.mp3';
        break;
      case 8:
        audioFileName = 'audio/8th_floor.mp3';
        break;
      case 9:
        audioFileName = 'audio/9th_floor.mp3';
        break;
    // Add cases for other floors as needed
      default:
        audioFileName = 'audio/ground_floor.mp3'; // Default audio if floor is not specified
    }
    await _audioPlayer.play(AssetSource(audioFileName));  // Play the selected audio file
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedLiftIndicator(isMovingUp: !_movingUp),
                      LEDIndicator(floor: _currentFloor),
                      AnimatedLiftIndicator(isMovingUp: _movingUp),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildButtonRow(['9', '8', '7']),
                  buildButtonRow(['6', '5', '4']),
                  buildButtonRow(['3', '2', '1']),
                  buildButtonRow(['\u25B2', '0', '\u25BC']), // Unicode characters for lift open icons
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Image.asset(
                'assets/images/bg_logo.png', // Add your logo asset path
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((label) => buildElevatorButton(label)).toList(),
    );
  }

  Widget buildElevatorButton(String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          if (label == '\u25B2' || label == '\u25BC') return;
          _moveToFloor(int.parse(label));
        },
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(24),
          primary: Colors.white,
          shadowColor: Colors.black,
          elevation: 10,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Set text color to black
          ),
        ),
      ),
    );
  }
}

class LEDIndicator extends StatelessWidget {
  final int floor;

  LEDIndicator({required this.floor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: 150, // Set a fixed width for the LED indicator
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        floor.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 48,
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontFamily: 'Digital', // Use a digital-style font
        ),
      ),
    );
  }
}

class AnimatedLiftIndicator extends StatelessWidget {
  final bool isMovingUp;

  AnimatedLiftIndicator({required this.isMovingUp});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 80,
      child: Center(
        child: AnimatedRotation(
          turns: isMovingUp ? 0.5 : 0,
          duration: Duration(seconds: 1),
          child: Icon(
            Icons.arrow_drop_up,
            color: Colors.black,
            size: 50,
          ),
        ),
      ),
    );
  }
}

