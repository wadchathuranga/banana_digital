import 'dart:convert';
import 'package:http/http.dart' as http;

import '../utils/app_configs.dart';

class C2DiseaseIdentificationApiService {
  // POST: identify diseases
  static Future identifyDiseases({required String accessToken, required dataBody, required lang}) async {
    try {
      var url = Uri.parse('$DISEASES_IDENTIFICATION?language=$lang');
      final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
          body: jsonEncode(dataBody));
      return response;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // GET: get all disease identification history
  static Future diseaseIdentificationHistory({required String accessToken, required String lang}) async {
    try {
      var url = Uri.parse('$DISEASES_IDENTIFICATION_HISTORY&language=$lang');
      final response = await http.get(
          url,
          headers: {
            "Authorization": "Bearer $accessToken",
          });
      return response;
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}