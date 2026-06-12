import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pbl2/theme/colors.dart';

Flushbar<dynamic>? _flushbarAtual;

void mostrarErroFlushbar(BuildContext context, String mensagem) {
  // Se já existe um flushbar aberto → fecha antes de abrir outro
  _flushbarAtual?.dismiss();

  final novoFlushbar = Flushbar(
    messageText: Text(
      mensagem,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    icon: const Icon(
      Icons.error_outline,
      color: AppColors.textPrimary,
    ),
    duration: const Duration(seconds: 3),
    flushbarPosition: FlushbarPosition.TOP,
    margin: const EdgeInsets.all(12),
    borderRadius: BorderRadius.circular(12),
    backgroundColor: const Color.fromARGB(255, 255, 79, 79),
    animationDuration: const Duration(milliseconds: 400),
  );

  _flushbarAtual = novoFlushbar;

  novoFlushbar.show(context).then((_) {
    if (_flushbarAtual == novoFlushbar) {
      _flushbarAtual = null;
    }
  });
}
