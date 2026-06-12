import 'package:flutter/material.dart';
import 'package:pbl2/services/authenticator_service.dart';
import 'package:pbl2/telas/tela_criar_conta.dart';
import 'package:pbl2/theme/colors.dart';
import 'package:pbl2/widgets/fundo_padrao.dart';
import 'package:pbl2/telas/popup_esqueci_senha.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  State<LoginPage> createState() => _LoginPageState();
}
//===============================================================================
//===============================================================================
//===============================================================================

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  Future<void> _fazerLogin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    final sucesso = await AuthenticatorService.logar(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    if (sucesso) {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.pop(context);
    } else {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(
            content: Text('E-mail ou Palavra-passe incorretos.')));
    }
  }
//===============================================================================
//===============================================================================
//===============================================================================

  @override
  Widget build(BuildContext context) {
    return FundoPadrao(
      child: Padding(
        padding: EdgeInsets.all(
            24.0), // Espaco entre as bordas da tela e o conteudo, podem modificar.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
//===============================================================================
//BOTAO VOLTAR
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

            const SizedBox(height: 80),
//===============================================================================
// TITULO LOGIN
            const Text(
              'Login',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
//===============================================================================

            const SizedBox(height: 20),
//===============================================================================
// CAMPO EMAIL
            TextField(
              controller: _emailController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                  hintText: 'E-mail',
                  hintStyle: TextStyle(
                      color: Colors.white, fontSize: 15, letterSpacing: 2),
                  filled: true,
                  fillColor: AppColors.fundoCardTransparente,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  )),
            ),
//===============================================================================

            const SizedBox(
              height: 10,
            ),
//===============================================================================
// CAMPO PALAVRA PASSE
            TextField(
              controller: _passwordController,
              style: const TextStyle(
                color: Colors.white,
              ),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Palavra-passe',
                hintStyle: TextStyle(
                    color: Colors.white, fontSize: 15, letterSpacing: 2),
                filled: true,
                fillColor: AppColors.fundoCardTransparente,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
//===============================================================================
            SizedBox(
              height: 10,
            ),

//===============================================================================
            Align(
              // BOTAO ESQUECI OS DADOS
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => const RecuperarSenha());
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Esqueci minha palavra-passe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      height: 1,
                      width: 188,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),

//===============================================================================

            const SizedBox(
              height: 30,
            ),

//===============================================================================
            Center(
              //botao de ENTRAR LOGIN
              child: ElevatedButton(
                onPressed: _isLoading ? null : _fazerLogin,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: AppColors.colorBotao,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text('Entrar',
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        )),
              ),
            ),
//===============================================================================
            const SizedBox(
              height: 100,
            ),
//===============================================================================
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Não é usuário?',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
//===============================================================================
                  const SizedBox(
                    height: 5,
                  ),
//===============================================================================
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TelaCriarConta()),
                        );
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(150, 40),
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.colorBotao,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'CRIAR CONTA',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
