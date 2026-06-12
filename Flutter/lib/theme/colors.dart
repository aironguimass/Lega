import 'package:flutter/material.dart';

class AppColors {
  static const Color colorBackground = Color.fromARGB(255, 0, 9, 54);

  // Cor dos cartões dos torneios
  static const Color cardTorneio = Color(0xFF1E264D);
  static const Color colorBotao = Color.fromARGB(255, 0, 45, 170);

  // Cor do status do torneio
  static const Color statusActive = Color(0xFF00E676);
  static const Color statusFinished = Color(0xFFFF1744);

  // Cores de Texto
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;

  static Color get fundoCardTransparente =>
      const Color.fromARGB(255, 155, 155, 155).withOpacity(0.4);

  static Color get iconeTransparente =>
      const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5);

  static Color get letraTransparente => Colors.white.withOpacity(0.7);
  static const Color bordaWidget = Color.fromARGB(255, 145, 145, 145);
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      colorBackground,
    ],
  );
}
