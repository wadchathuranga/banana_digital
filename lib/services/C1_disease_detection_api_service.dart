import 'package:http/http.dart' as http;

import '../utils/app_configs.dart';

class C1DiseaseDetectionApiService {

  // POST: disease detection
  static Future proceedToClassification({required imageFile, required String accessToken}) async {
    try {
      // string to uri
      var uri = Uri.parse(DISEASE_DETECTION);

      // create multipart request
      var request = http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = await http.MultipartFile.fromPath('image', imageFile.path);

      // add file to multipart
      request.files.add(multipartFile);

      // herders
      var headers = {
        'Authorization': 'Bearer $accessToken'
      };

      // set headers to request
      request.headers.addAll(headers);

      // send request
      http.StreamedResponse response = await request.send();
      return response;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // GET: get disease detection history
  static Future diseaseDetectionHistory({required String accessToken}) async {
    try {
      var url = Uri.parse(DISEASE_DETECTION_HISTORIES);
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

  // GET: get cures by diseaseName
  static Future getCuresByDiseaseName({required String accessToken, required String diseaseName}) async {
    try {
      var url = Uri.parse('$GET_CURES_BY_DISEASE_NAME?name=$diseaseName');
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