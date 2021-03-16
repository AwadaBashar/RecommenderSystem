import 'package:http/http.dart';

Future getData(url) async {
  print('method called');
  Response response =await get(url);
  print('finished');
  return response.body;
}
