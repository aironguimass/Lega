import 'package:flutter/material.dart';
import 'package:pbl2/services/authenticator_service.dart';
import 'package:pbl2/widgets/mostrar_erro_flushbar.dart';
import 'package:pbl2/theme/colors.dart';

class PopupAlterarDado extends StatefulWidget {
  final bool alterarEmail; // true = email, false = senha

  const PopupAlterarDado({super.key, required this.alterarEmail});

  @override
  State<PopupAlterarDado> createState() => _PopupAlterarDadoState();
}

class _PopupAlterarDadoState extends State<PopupAlterarDado> {
  final campo1 = TextEditingController();
  final campo2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final titulo =
        widget.alterarEmail ? "Alterar e-mail" : "Alterar palavra-passe";
    final hint1 = widget.alterarEmail ? "Novo e-mail" : "Nova palavra-passe";
    final hint2 =
        widget.alterarEmail ? "Confirmar e-mail" : "Confirmar palavra-passe";

    return AlertDialog(
      backgroundColor: AppColors.cardTorneio,
      title: Text(
        titulo,
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: campo1,
            obscureText: !widget.alterarEmail,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
                hintText: hint1,
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 110, 110, 110))),
          ),
          TextField(
            controller: campo2,
            obscureText: !widget.alterarEmail,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
                hintText: hint2,
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 110, 110, 110),
                )),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancelar",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        TextButton(
          onPressed: () async {
            final v1 = campo1.text.trim();
            final v2 = campo2.text.trim();

            if (v1.isEmpty || v2.isEmpty) {
              mostrarErroFlushbar(context, "Preencha todos os campos.");
              return;
            }

            if (v1 != v2) {
              mostrarErroFlushbar(
                  context,
                  widget.alterarEmail
                      ? "Os e-mails não coincidem."
                      : "As palavras-passe não coincidem.");
              return;
            }

            if (widget.alterarEmail) {
              // validação de email
              final emailValido = RegExp(r"^.{3,}@.{3,}$").hasMatch(v1);
              if (!emailValido) {
                mostrarErroFlushbar(context, "E-mail inválido.");
                return;
              }

              await AuthenticatorService.atualizarEmail(v1);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("E-mail atualizado com sucesso!"),
                ),
              );
            } else {
              // validação de senha
              if (v1.length < 6) {
                mostrarErroFlushbar(context,
                    "A palavra-passe deve ter no mínimo 6 caracteres.");
                return;
              }

              if (v1.length > 15) {
                mostrarErroFlushbar(context,
                    "A palavra-passe deve ter no máximo 15 caracteres.");
                return;
              }

              await AuthenticatorService.atualizarPalavraPasse(v1);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Palavra-passe atualizada com sucesso!"),
                ),
              );
            }
          },
          child: const Text(
            "Salvar",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ],
    );
  }
}
