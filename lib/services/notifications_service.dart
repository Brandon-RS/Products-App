import 'package:flutter/material.dart';

class NotificationsService {
  static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
      backgroundColor: const Color(0xff3f3f9c),
      behavior: SnackBarBehavior.floating,
      elevation: 1.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 16),
          children: [
            const WidgetSpan(child: Icon(Icons.warning_rounded, color: Colors.white)),
            const WidgetSpan(child: SizedBox(width: 30)),
            TextSpan(
              text: message == 'EMAIL_NOT_FOUND' ? 'Usuario no encontrado!' : 'El usuario ya existe!',
            ),
          ],
        ),
      ),
      action: SnackBarAction(label: '↓', textColor: Colors.white, onPressed: () {}),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
