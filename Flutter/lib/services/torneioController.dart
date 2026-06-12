import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl2/models/model_torneio.dart';

class TorneioService {
  final String _baseUrl = 'http://10.0.2.2:5029/api/Torneio';

  Future<List<Torneio>> fetchTorneios() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        print("JSON RECEBIDO: ${response.body}");
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Torneio.fromJson(item)).toList();
      } else {
        throw Exception(
            'Erro ao carregar dados do servidor (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception(
          'Não foi possível conectar ao servidor. Verifique se tens ligação a internet.');
    }
  }
}
