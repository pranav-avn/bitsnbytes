import 'dart:convert';
import 'package:http/http.dart' as http;

gi fetchData(current) async {
  print("Attempting to fetch data from network..");
  if (current == 0) {
    final url =
        "http://blynk-cloud.com/238dc3bbbcfc4ed39a97c212d51f313a/get/V0";
    final response = await http.get(url as Uri);
    if (response.statusCode == 200) {
      print(response.body);
      final map = json.decode(response.body);
      setState(() {
        this.descriptions = "Temperature";
        var withoutbracket = map.toString().replaceAll("[", '');
        withoutbracket = withoutbracket.replaceAll("]", '');
        this.value = withoutbracket;
        this.iconIndex = current;
        this.visibilityTag = true;
      });
    }
  }

  if (current == 1) {
    final url2 =
        "http://blynk-cloud.com/238dc3bbbcfc4ed39a97c212d51f313a/get/V1";
    final response2 = await http.get(url2 as Uri);
    if (response2.statusCode == 200) {
      print(response2.body);
      final map = json.decode(response2.body);
      setState(() {
        this.descriptions = "Humidity";
        var withoutbracket = map.toString().replaceAll("[", '');
        withoutbracket = withoutbracket.replaceAll("]", '');
        this.value = withoutbracket;
        this.iconIndex = current;
      });
    }
  }

  if (current == 2) {
    print("door sensor >>");
    final url3 =
        "http://blynk-cloud.com/238dc3bbbcfc4ed39a97c212d51f313a/get/V2";
    final response3 = await http.get(url3 as Uri);
    if (response3.statusCode == 200) {
      print(response3.body);
      final map = json.decode(response3.body);
      setState(() {
        this.descriptions = "Door state";
        var withoutbracket = map.toString().replaceAll("[", '');
        withoutbracket = withoutbracket.replaceAll("]", '');
        this.value = withoutbracket;
        this.iconIndex = current;
      });
    }
  }

  if (current == 3) {
    print("motion >>");
    final url3 =
        "http://blynk-cloud.com/238dc3bbbcfc4ed39a97c212d51f313a/get/V3";
    final response3 = await http.get(url3 as Uri);
    if (response3.statusCode == 200) {
      print(response3.body);
      final map = json.decode(response3.body);
      setState(() {
        this.descriptions = "Movement";
        var withoutbracket = map.toString().replaceAll("[", '');
        withoutbracket = withoutbracket.replaceAll("]", '');
        if (withoutbracket == '1') {
          withoutbracket = "Motion detected";
        } else {
          withoutbracket = "No motion detected";
        }
        this.value = withoutbracket;
        this.iconIndex = current;
      });
    }
  }
}
