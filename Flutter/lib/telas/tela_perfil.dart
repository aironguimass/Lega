import 'package:flutter/material.dart';
import 'package:pbl2/widgets/fundo_padrao.dart';
import 'package:pbl2/theme/colors.dart';
import 'package:pbl2/services/authenticator_service.dart';
import 'package:pbl2/widgets/popup_alterar_dados.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}
//===============================================================================

class _TelaPerfilState extends State<TelaPerfil> {
//===============================================================================

  bool carregando = false;
  String? email;

  @override
  void initState() {
    super.initState();
    carregarEmail();
  }
//===============================================================================

  Future<void> carregarEmail() async {
    email = await AuthenticatorService.obterEmail(); // cria esse método
    setState(() {});
  }
//===============================================================================

  Future<void> fazerLogout() async {
    setState(() => carregando = true);
    await AuthenticatorService.logout();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pop(context);
  }
//===============================================================================

  @override
  Widget build(BuildContext context) {
    return FundoPadrao(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
//===============================================================================

            Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                )),
//===============================================================================

            const SizedBox(height: 90),
//===============================================================================

            Text(
              email ?? 'Carregando...',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
//===============================================================================

            const SizedBox(height: 30),
//===============================================================================

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorBotao),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const PopupAlterarDado(alterarEmail: true),
                ).then((_) {
                  // Atualiza o e-mail na tela depois de alterar
                  carregarEmail();
                });
              },
              child: const Text(
                'Alterar e-mail',
                style: TextStyle(color: Colors.white),
              ),
            ),
//===============================================================================

            const SizedBox(height: 30),
//===============================================================================

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorBotao),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const PopupAlterarDado(alterarEmail: false),
                );
              },
              child: const Text(
                'Alterar palavra-passe',
                style: TextStyle(color: Colors.white),
              ),
            ),
//===============================================================================

            const SizedBox(height: 30),
//===============================================================================

            carregando
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : ElevatedButton(
                    onPressed: fazerLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.colorBotao,
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
