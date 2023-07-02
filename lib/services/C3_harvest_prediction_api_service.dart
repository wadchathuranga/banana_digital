import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_configs.dart';

class C3HarvestPredictionApiService {
  // POST: harvest prediction
  static Future estimateHarvest({required String accessToken, required bodyData}) async {
    try {
      var url = Uri.parse('$HARVEST_PREDICTION/predict');
      final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
          body: jsonEncode(bodyData));
      return response;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  // GET: get all varieties
  static Future getAllVarieties({required String accessToken}) async {
    try {
      var url = Uri.parse(HARVEST_PREDICTION_GET_ALL_VARITIES);
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

  // GET: calculate harvesting day
  static Future calculateHarvestingDay({required String accessToken, required varietyId, required age}) async {
    try {
      var url = Uri.parse('$HARVEST_PREDICTION_DAYS?variety=$varietyId&age=$age');
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

  // GET: get harvest history
  static Future getHarvestHistoryData({required String accessToken}) async {
    try {
      var url = Uri.parse(HARVEST_PREDICTION_HISTORIES);
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