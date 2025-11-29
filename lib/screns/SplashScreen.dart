import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'NoteListScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _anim1, _anim2, _anim3, _anim4, _anim5, _anim6, _anim7 ;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3));

    _anim1 = Tween<Offset>(
      begin: Offset(-1.0, -1.0),
      end: Offset(0.4, 0.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _anim2 = Tween<Offset>(
      begin: Offset(-1.0, -1.0),
      end: Offset(1.0, 0.1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

    _anim3 = Tween<Offset>(
      begin: Offset(-1.0, -1.0),
      end: Offset(-0.5, 0.6),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart));

    _anim4 = Tween<Offset>(
      begin: Offset(-1.0, -1.0),
      end: Offset(0.3, 0.2),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

    _anim5 = Tween<Offset>(
      begin: Offset(-1.0, -1.0),
      end: Offset(-0.2, 0.1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart));

    _anim6 = Tween<Offset>(
      begin: Offset(-1.0, -1.0),
      end: Offset(3.0, 0.1),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

    _anim7 = Tween<Offset>(
      begin: Offset(-1.0, -1.0),
      end: Offset(-0.8, 0.6),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuart));

    _controller.forward();

    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NotesListScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          SlideTransition(
            position: _anim1,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.35, left: size.width * 0.00775),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepPurple],
                ),
              ),
              child: Icon(Icons.edit, size: 100, color: Colors.white70),
            ),
          ),
          SlideTransition(
            position: _anim2,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.35, left: size.width * 0.43),
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [Colors.orange, Colors.deepOrangeAccent],
                ),
              ),
              child: Icon(Icons.menu_book, size: 100, color: Colors.white70),
            ),
          ),
          SlideTransition(
            position: _anim3,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.24, left: size.width * 0.25),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.blueAccent],
                ),
              ),
              child: Icon(Icons.note_alt, size: 80, color: Colors.white70),
            ),
          ),
          SlideTransition(
            position: _anim4,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.35, left: size.width * 0.00775),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepPurple],
                ),
              ),
              child: Icon(Icons.edit, size: 100, color: Colors.white70),
            ),
          ),
          SlideTransition(
            position: _anim5,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.35, left: size.width * 0.00775),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.deepPurple],
                ),
              ),
              child: Icon(Icons.edit, size: 100, color: Colors.white70),
            ),
          ),
          SlideTransition(
            position: _anim6,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.35, left: size.width * 0.00775),
              width: 120,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.deepPurple],
                ),
              ),
              child: Icon(Icons.edit, size: 100, color: Colors.white70),
            ),
          ),
          SlideTransition(
            position: _anim7,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.35, left: size.width * 0.00775),
              width: 160,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.indigo, Colors.deepPurple],
                ),
              ),
              child: Icon(Icons.edit, size: 100, color: Colors.white70),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }
}
