import 'package:flutter/material.dart';

class OverlaySetting {
  void showErrorAlert(BuildContext context, String message) async {
    OverlayEntry overlay =
    OverlayEntry(builder: (_) => AlertEmailError(message));

    Navigator.of(context).overlay!.insert(overlay);

    await Future.delayed(const Duration(seconds: 2));
    overlay.remove();
  }
}

class AlertEmailError extends StatefulWidget {
  final String errMessage;
  const AlertEmailError(this.errMessage, {Key? key}) : super(key: key);

  @override
  AlertEmailErrorWidget createState() => AlertEmailErrorWidget();
}

class AlertEmailErrorWidget extends State<AlertEmailError>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.decelerate));

    _controller.forward().whenComplete(() {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: FadeTransition(
            opacity: _animation,
            child: Material(
              color: const Color.fromARGB(0, 255, 255, 255),
              child: Container(
                margin: const EdgeInsets.all(0),
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey),
                child: Text(
                  widget.errMessage,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
