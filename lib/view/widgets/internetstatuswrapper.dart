import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/connection_checker.dart';

class InternetStatusWrapper extends StatelessWidget {
  final Widget child;

  const InternetStatusWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Consumer<ConnectivityProvider>(
          builder: (context, connectivityProvider, _) {
            if (!connectivityProvider.isConnected) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.brown.shade100,
                    content: const Text(
                      'Internet connection lost',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              });
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
