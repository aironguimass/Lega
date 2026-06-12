import 'package:flutter/material.dart';
import 'package:pbl2/services/authenticator_service.dart';
import 'package:pbl2/widgets/mostrar_erro_flushbar.dart';

// import 'package:pbl2/telas/tela_meus_torneios.dart';
bool _flushbarAberta = false;

Future<void> verificarAcessoMeusTorneios(BuildContext context) async {
  final bool logado = await AuthenticatorService.estaLogado();

  if (!context.mounted) return;

  if (logado) {
    print("Usuário logado! Abrindo Tela de Meus Torneios...");

    // Quando a tela estiver criarda ativa isto:

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const TelaMeusTorneios(),
    //   ),
    // );
  } else {
    if (_flushbarAberta) return;

    _flushbarAberta = true;

    mostrarErroFlushbar(
      context,
      "Precisas estar logado para ver os teus torneios.",
    );

    _flushbarAberta = false;
  }
}
