import 'package:flutter/material.dart';
import 'package:pbl2/theme/colors.dart';
import 'package:pbl2/services/authenticator_service.dart';

class RecuperarSenha extends StatefulWidget {
  const RecuperarSenha({super.key});

  @override
  State<RecuperarSenha> createState() => _RecuperarSenhaState();
}
//================================================================================

class _RecuperarSenhaState extends State<RecuperarSenha> {
  final TextEditingController _emailController = TextEditingController();
  bool _enviando = false;
  String? _erroMensagem;
//================================================================================

  Future<void> _enviarRecuperacao() async {
    final email = _emailController.text.trim();

    setState(() {
      _erroMensagem = null;
      _enviando = true;
    });

    final emailValido = RegExp(r"^.{3,}@.{3,}$").hasMatch(email);

    if (email.length > 50) {
      setState(() {
        _erroMensagem = 'O e-mail não pode ter mais de 50 caracteres.';
        _enviando = false;
      });
      return;
    }

    if (!emailValido) {
      setState(() {
        _erroMensagem = 'Por favor, insira um e-mail válido.';
        _enviando = false;
      });
      return;
    }
//================================================================================
    await Future.delayed(const Duration(seconds: 1));

//================================================================================

    final resultado = await AuthenticatorService.recuperarSenha(email);
    if (!mounted) return;
    setState(() => _enviando = false);

    if (resultado == "Sucesso") {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Instruções enviadas para o seu e-mail.')),
      );
    } else {
      setState(() {
        _erroMensagem = resultado;
      });
    }
  }
//================================================================================

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardTorneio,
      title: const Text(
        'Recuperar Palavra-passe',
        style:
            TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
      ),
//================================================================================

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Digite o seu e-mail',

              hintStyle: TextStyle(
                color: Color.fromARGB(255, 155, 155, 155),
              ),
              enabledBorder: UnderlineInputBorder(
                //cor da linha quando nao está clicado no campo pra digitar
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
              ), //cor da linha quando está clicado no campo pra digitar
            ),
          ),
          if (_erroMensagem != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                _erroMensagem!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ),
        ],
      ),
//================================================================================

      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            )),
        //================================================================================

        ElevatedButton(
          onPressed: _enviando ? null : _enviarRecuperacao,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _enviando ? AppColors.colorBotao : AppColors.colorBotao,
            disabledBackgroundColor: AppColors.colorBotao,
          ),
          child: _enviando
              ? const CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 2,
                )
              : const Text(
                  'Enviar',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
        ),
      ],
    );
  }
}
