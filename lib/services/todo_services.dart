import 'dart:convert';

import 'package:http/http.dart' as http;

class ToDoService{
  static Future<bool> deleteById(String id) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final response = await http.delete(Uri.parse(url));
    return response.statusCode == 200;
  }
  static Future<List?> fetchToDoList() async {
    const url = "https://api.nstack.in/v1/todos?page=1&limit=20";
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final json = jsonDecode(response.body) as Map;
      final res = json["items"] as List;
      return res;
    }
    else{
      return null;
    }
  }
  static Future<bool> updateData(String id,Map body) async {
    final url = "https://api.nstack.in/v1/todos/$id";
    final response = await http.put(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          "Content-Type" : "application/json",
        }
    );
    return response.statusCode == 200;
  }
  static Future<bool> submitData(Map body) async {
    const url = "https://api.nstack.in/v1/todos";
    final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          "Content-Type" : "application/json",
        }
    );
    return response.statusCode == 201;
  }
}