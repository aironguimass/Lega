import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthenticatorService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

// Verifica se já tem alguém logado e  confere se o token existe
//===============================================================================

  static Future<bool> estaLogado() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null && token.isNotEmpty;
  }
//===============================================================================

  static Future<void> guardarToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
//===============================================================================

  // Vai buscar o token que está guardado
  static Future<String?> obterToken() async {
    return await _storage.read(key: 'auth_token');
  }
//===============================================================================

  static Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_id');
  }
//===============================================================================

// Tenta falar com a API para ver se o login está certo
  static Future<bool> logar(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5029/api/Usuario/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final dados = jsonDecode(response.body);

        await _storage.write(
            key: 'user_id', value: dados['usuarioId'].toString());
        await _storage.write(key: 'email', value: dados['email']);
        await _storage.write(key: 'auth_token', value: "logado");
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
//===============================================================================

  static Future<String?> obterUserId() async {
    return await _storage.read(key: 'user_id');
  }
//===============================================================================

  static Future<String?> obterEmail() async {
    return await _storage.read(key: 'email');
  }

  static Future<String?> obterNome() async {
    return await _storage.read(key: 'nome');
  }
//===============================================================================

  static Future<Map<String, dynamic>?> obterUsuario() async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) return null;

    final response = await http.get(
      Uri.parse('http://10.0.2.2:5029/api/Usuario/$id'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }
//===============================================================================

  static Future<String?> recuperarSenha(String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5029/api/Usuario/recuperar-senha'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return "Sucesso";
      } else if (response.statusCode == 404) {
        return "Não existe conta com este e-mail.";
      }

      return "Erro ao processar pedido.";
    } catch (e) {
      return "Erro de conexão com o servidor.";
    }
  }

//===============================================================================

  static Future<void> atualizarEmail(String novoEmail) async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) return;

    final response = await http.put(
      Uri.parse('http://10.0.2.2:5029/api/Usuario/$id/email'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(novoEmail),
    );

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      await _storage.write(key: 'email', value: novoEmail);
    }
  }

//===============================================================================

  static Future<void> atualizarPalavraPasse(String novaPass) async {
    final id = await _storage.read(key: 'user_id');
    if (id == null) return;

    final response = await http.put(
      Uri.parse('http://10.0.2.2:5029/api/Usuario/$id/password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(novaPass),
    );

    print(response.statusCode);
    print(response.body);
  }

//===============================================================================

  static Future<String?> criarConta(
      String nome, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5029/api/Usuario'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuarioId': 0,
          'nome': nome,
          'email': email,
          'palavraPasseHash': password
        }),
      );

      if (response.statusCode == 200) {
        final dados = jsonDecode(response.body);

        //aqui salva os dados do usuario no banco de dados
        await _storage.write(
            key: 'user_id', value: dados['usuarioId'].toString());
        await _storage.write(key: 'email', value: dados['email']);
        await _storage.write(key: 'auth_token', value: "logado");

        return null;
      }

      return "Erro ao criar conta";
    } catch (e) {
      return "Erro ao conectar ao servidor";
    }
  }

//===============================================================================
}
