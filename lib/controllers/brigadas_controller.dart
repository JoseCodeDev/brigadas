import 'dart:convert';
import 'package:http/http.dart' as http;

class BrigadasController {
  final headers = {"Content-Type": "application/json;charset=UTF-8"};

  Future<List<Map<String, dynamic>>> getBrigadas() async {
    final response = await http.get(Uri.parse(
        'https://j8l2hx11gh.execute-api.us-east-1.amazonaws.com/brigadas'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener las brigadas');
    }
  }

  Future<void> postBrigadas(String nombre) async {
    final brigada = {"nombre": nombre};
    final response = await http.post(
      Uri.parse(
          'https://j8l2hx11gh.execute-api.us-east-1.amazonaws.com/brigadas'),
      headers: headers,
      body: jsonEncode(brigada),
    );
    if (response.statusCode == 200) {
      // Registro agregado exitosamente
    } else {
      throw Exception('Error al agregar la brigada');
    }
  }

  Future<void> deleteBrigada(String id) async {
    final response = await http.delete(
      Uri.parse(
          'https://j8l2hx11gh.execute-api.us-east-1.amazonaws.com/brigadas/$id'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      // Registro eliminado exitosamente
    } else {
      throw Exception('Error al eliminar la brigada');
    }
  }

  Future<void> updateBrigada(String id, String nombre) async {
    final brigada = {"nombre": nombre};
    final response = await http.put(
      Uri.parse(
          'https://j8l2hx11gh.execute-api.us-east-1.amazonaws.com/brigadas/$id'),
      headers: headers,
      body: jsonEncode(brigada),
    );
    if (response.statusCode == 200) {
      // Registro actualizado exitosamente
    } else {
      throw Exception('Error al actualizar la brigada');
    }
  }
}
