import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  var r = await http.get(Uri.parse('https://noembed.com/embed?url=https://www.youtube.com/watch?v=Dpp1sIL1m5Q'));
  print(r.statusCode);
  print(r.body);
}
