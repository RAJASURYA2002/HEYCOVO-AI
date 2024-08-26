// import 'package:heyconvo/constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class GitRequest{
  Future getSpeech() async {
  Uri uri = Uri.parse("https://raw.githubusercontent.com/RAJASURYA2002/Spark_AI_Tranning/main/heyconvo_tranning.json");
  http.Response response = await http.get(uri);
  if (response.statusCode == 200) {
      String data = response.body;
      var speech = jsonDecode(data);
      return speech;
    } else {
      return;
    }
  }
}