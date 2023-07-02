import 'package:http/http.dart' as http;

class C4WateringFertilizerApiService {
  // POST: make the harvesting or fertilizer plan
  static Future predictThePlan({required String accessToken, required urlConst, required croppedImg, required dataBody }) async {
    try {
      var headers = {
        'Authorization': 'Bearer $accessToken'
      };
      var url = Uri.parse(urlConst); // url define
      var request = http.MultipartRequest(
          'POST', url); // create multipart request
      var multipartFile = await http.MultipartFile.fromPath(
          'soil_image', croppedImg.path);

      request.fields.addAll(dataBody); // set tha data body
      request.files.add(multipartFile); // multipart that takes file
      request.headers.addAll(headers); // set the headers

      http.StreamedResponse response = await request.send();
      return response;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // GET: watering and fertilizer history
  static Future getWateringFertilizerHistory({required String accessToken, required String urlConst}) async {
    try {
      var url = Uri.parse(urlConst);
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );
      return response;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}