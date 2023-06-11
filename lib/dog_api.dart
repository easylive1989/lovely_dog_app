import 'dart:convert';

import 'package:http/http.dart';

class DogApi {
  final Client _client;

  DogApi({required Client client}) : _client = client;

  Future<List<String>> getBreedList() async {
    var response = await _client.get(
      Uri.parse("https://dog.ceo/api/breeds/list/all"),
    );
    var messageResponse = jsonDecode(response.body)["message"];
    return messageResponse.keys.toList();
  }

  Future<String> getDogImage(String breed) async {
    var response = await _client.get(
      Uri.parse("https://dog.ceo/api/breed/$breed/images/random"),
    );
    return jsonDecode(response.body)["message"];
  }
}
