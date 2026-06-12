import 'package:flutter/material.dart';
import 'package:pbl2/services/authenticator_service.dart';
import 'package:pbl2/widgets/fundo_padrao.dart';
import 'package:pbl2/theme/colors.dart';
import 'package:pbl2/widgets/mostrar_erro_flushbar.dart';

class TelaCriarConta extends StatefulWidget {
  const TelaCriarConta({super.key});

  @override
  State<TelaCriarConta> createState() => _TelaCriarConta();
}
//================================================================================

class _TelaCriarConta extends State<TelaCriarConta> {
  final nomeCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final confirmarEmailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmarPassCtrl = TextEditingController();
//================================================================================

  bool carregando = false;

  Future<void> criarConta() async {
    setState(() => carregando = true);

    final erro = await AuthenticatorService.criarConta(
      nomeCtrl.text,
      emailCtrl.text,
      passCtrl.text,
    );
//================================================================================

    setState(() => carregando = false);

    if (erro == null) {
      Navigator.pop(context); // volta para a tela de login
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Erro"),
          content: Text(erro),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    }
  }
//================================================================================

  @override
  Widget build(BuildContext context) {
    return FundoPadrao(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
//================================================================================

            const SizedBox(height: 30),
//================================================================================

            TextField(
              controller: nomeCtrl,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Nome',
                hintStyle: TextStyle(
                    color: AppColors.letraTransparente,
                    fontSize: 15,
                    letterSpacing: 2),
                filled: true,
                fillColor: AppColors.fundoCardTransparente,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

//================================================================================
            const SizedBox(height: 10),
            TextField(
              controller: emailCtrl,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'E-mail',
                hintStyle: TextStyle(
                    color: AppColors.letraTransparente,
                    fontSize: 15,
                    letterSpacing: 2),
                filled: true,
                fillColor: AppColors.fundoCardTransparente,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
//================================================================================
            const SizedBox(height: 10),
            TextField(
              controller: confirmarEmailCtrl,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Confirmar E-mail',
                hintStyle: TextStyle(
                    color: AppColors.letraTransparente,
                    fontSize: 15,
                    letterSpacing: 2),
                filled: true,
                fillColor: AppColors.fundoCardTransparente,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
//================================================================================
            const SizedBox(height: 10),
            TextField(
              controller: passCtrl,
              style: const TextStyle(
                color: Colors.white,
              ),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Palavra-passe',
                hintStyle: TextStyle(
                    color: AppColors.letraTransparente,
                    fontSize: 15,
                    letterSpacing: 2),
                filled: true,
                fillColor: AppColors.fundoCardTransparente,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
//================================================================================
            const SizedBox(height: 10),
            TextField(
              controller: confirmarPassCtrl,
              style: const TextStyle(
                color: Colors.white,
              ),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Confirmar Palavra-passe',
                hintStyle: TextStyle(
                    color: AppColors.letraTransparente,
                    fontSize: 15,
                    letterSpacing: 2),
                filled: true,
                fillColor: AppColors.fundoCardTransparente,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
//================================================================================

            const SizedBox(height: 30),
//================================================================================

            carregando
                ? const CircularProgressIndicator(color: Colors.white)
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      backgroundColor: AppColors.colorBotao,
                    ),
                    //================================================================================
//verificacoes para criar a conta
                    onPressed: () async {
                      final emailValido =
                          RegExp(r"^.{3,}@.{3,}$").hasMatch(emailCtrl.text);
//================================================================================

                      if (nomeCtrl.text.isEmpty) {
                        mostrarErroFlushbar(
                            context, "O nome não pode estar vazio.");
                        return;
                      }
//================================================================================

                      if (nomeCtrl.text.length > 50) {
                        mostrarErroFlushbar(context,
                            "O nome não pode ultrapassar 50 caracteres.");
                        return;
                      }
//================================================================================

                      if (!emailValido) {
                        mostrarErroFlushbar(context, "E-mail inválido.");
                        return;
                      }
//================================================================================

                      if (emailCtrl.text != confirmarEmailCtrl.text) {
                        mostrarErroFlushbar(
                            context, "Os e-mails não coincidem.");
                        return;
                      }
//================================================================================

                      if (passCtrl.text.length < 6) {
                        mostrarErroFlushbar(context,
                            "A palavra-passe deve ter no mínimo 6 caracteres.");
                        return;
                      }
//================================================================================

                      if (passCtrl.text.length > 15) {
                        mostrarErroFlushbar(context,
                            "A palavra-passe deve ter no máximo 15 caracteres.");
                        return;
                      }
//================================================================================

                      if (passCtrl.text != confirmarPassCtrl.text) {
                        mostrarErroFlushbar(
                            context, "As palavras-passe não coincidem.");
                        return;
                      }
//================================================================================

                      await criarConta();
                    },
                    child: const Text(
                      "Criar Conta",
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
