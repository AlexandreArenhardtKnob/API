import 'package:api_modelo/model/profile.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  final String baseUrl = "http://api.bengkelrobot.net:8001";
  Client cliente = Client();

  Future<List<Profile>> getProfiles() async {
    final response = await cliente.get("$baseUrl/api/profile");
    if (response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> createProfile(Profile data) async {
    final response = await cliente.post(
      "$baseUrl/api/profile",
      headers: {"content-type": "application/json"},
      body: profileToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfile(Profile data) async {
    final response = await cliente.put(
      "$baseUrl/api/profile/${data.id}",
      headers: {"content-type": "application/json"},
      body: profileToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProfile(int id) async {
    final response = await cliente.delete(
      "$baseUrl/api/profile/$id",
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
