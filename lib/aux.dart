import 'dart:convert';
import 'package:http/http.dart' as http;

class Aux {
  static Future<List?> search(String query) async {

    late List<dynamic> temp;
    var url = await Uri.parse("http://api.serpstack.com/search?access_key=3fa38531c4c514741c3342b2da479bdf&query=$query&num=9");

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) ;
      temp = jsonResponse["organic_results"];

      temp.forEach((mapa1) {

        print("${mapa1["title"]} ----  ${mapa1["url"]}");
      });
      return temp;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
