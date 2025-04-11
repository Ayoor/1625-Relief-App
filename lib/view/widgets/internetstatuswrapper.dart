import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/connection_checker.dart';

class InternetStatusWrapper extends StatefulWidget {
  final Widget child;

  const InternetStatusWrapper({super.key, required this.child});

  @override
  _InternetStatusWrapperState createState() => _InternetStatusWrapperState();
}

class _InternetStatusWrapperState extends State<InternetStatusWrapper> {
  bool _isDialogVisible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Consumer<ConnectivityProvider>(
          builder: (context, connectivityProvider, _) {
            if (!connectivityProvider.isConnected) {
              // Show dialog only if it's not already visible
              if (!_isDialogVisible) {
                _isDialogVisible = true;
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
                  ).then((_) {
                    // After dialog is dismissed, set _isDialogVisible back to false
                    _isDialogVisible = false;
                  });
                });
              }
            } else {
              // Close the dialog only if it's visible
              if (_isDialogVisible) {
                Navigator.pop(context);
              }
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
