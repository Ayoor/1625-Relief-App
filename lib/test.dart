import 'package:flutter/material.dart';

class Testme extends StatefulWidget {
  const Testme({super.key});

  @override
  State<Testme> createState() => _TestmeState();
}

class _TestmeState extends State<Testme> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      print("Focus state: ${_focusNode.hasFocus}");
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
          ),
        ),
      ),
    );
  }
}
