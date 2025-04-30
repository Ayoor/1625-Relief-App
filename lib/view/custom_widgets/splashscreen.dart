import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Shorter duration for the fade-in
      vsync: this,
    );

    // Create an animation from 0 (invisible) to 1 (fully visible)
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Start the animation after a delay (when image is done)
    Future.delayed(const Duration(seconds: 3), () {
      _controller.forward();
    });
  }

  // @override
  // void dispose() {
  //   // Dispose the animation controller when the widget is destroyed
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "lib/assets/1625_logo.png",
                width: MediaQuery.of(context).size.width / 1.7,
              ),
              const SizedBox(
                height: 20,
              ),
              FadeTransition(
                opacity: _animation,
                child: const Text(
                  "Relief",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
