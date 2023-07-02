import 'dart:convert';
import 'package:banana_digital/services/C4_watering_fertilizer_api_service.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/WateringPlanHistoryModel.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_configs.dart';
import '../../widgets/Loading.dart';
import '../chat_screen/TextWidget.dart';

class WateringPlanHistoryScreen extends StatefulWidget {
  const WateringPlanHistoryScreen({Key? key}) : super(key: key);

  @override
  State<WateringPlanHistoryScreen> createState() => _WateringPlanHistoryScreenState();
}

class _WateringPlanHistoryScreenState extends State<WateringPlanHistoryScreen> {

  late List<WateringPlanHistoryModel> historyList = [];
  String? accessToken;
  bool isLoading = true;

  @override
  void initState() {
    accessToken = UserSharedPreference.getAccessToken().toString();
    fetchHistoryData();
    super.initState();
  }

  // Get harvest prediction histories API
  Future fetchHistoryData() async {
    try {
      // var url = Uri.parse(WATERING_PLAN_HISTORY);
      // final response = await http.get(
      //   url,
      //   headers: {
      //      "Authorization": "Bearer $accessToken",
      //   },
      // );

      http.Response response = await C4WateringFertilizerApiService.getWateringFertilizerHistory(accessToken: accessToken!, urlConst: WATERING_PLAN_HISTORY);

      if (response.statusCode == 200) {
        List<dynamic> resData = jsonDecode(response.body);
        historyList = resData.map((history) => WateringPlanHistoryModel.fromJson(history)).toList();
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget(label: response.reasonPhrase.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (err) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: err.toString()),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("================= Catch Error [fetchWateringPlanHistoryData] ====================");
        print(err);
        print("==================================================");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watering Plan Histories'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                if (historyList.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        return  _expandableTile(historyList[index]);
                      },
                    ),
                  ),
                if (historyList.isEmpty && !isLoading)
                  const Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Center(
                      child: Text('History not available'),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            child: !isLoading
                ? null
                : const LoadingWidget(msg: 'Loading...'),
          ),
        ],
      ),
    );
  }

  Widget _expandableTile(WateringPlanHistoryModel wateringPlanHistory) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          ExpandableNotifier(
            initialExpanded: false,
            child: Stack(
              children: [
                Container(
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: AppColors.primaryColor,
                  ),
                ),
                ScrollOnExpand(
                  child: ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        DateFormat('MMM d, yyyy hh:mm:ss a').format(DateTime.parse(wateringPlanHistory.createdAt!)).toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                    collapsed: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Variety',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Stage',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Plan',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ':  ${wateringPlanHistory.wateringPlan!.variety.toString()}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  ':  ${wateringPlanHistory.wateringPlan!.stage.toString()}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  ':  ${wateringPlanHistory.wateringPlan!.wateringPlan.toString()}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    expanded: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Variety',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          'Stage',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          'Plan',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ':  ${wateringPlanHistory.wateringPlan!.variety.toString()}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          ':  ${wateringPlanHistory.wateringPlan!.stage.toString()}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          ':  ${wateringPlanHistory.wateringPlan!.wateringPlan.toString()}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(),
                                MarkdownBody(
                                  data: wateringPlanHistory.wateringPlan!.description.toString(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Top Predicted Watering Plans',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Plan',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Probability',
                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: wateringPlanHistory.topProbabilities!.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      wateringPlanHistory.topProbabilities![index].plan.toString(),
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${(double.parse(wateringPlanHistory.topProbabilities![index].probability!) * 100).toStringAsFixed(2)}%',
                                                      style: const TextStyle(fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                            Column(
                              children: [
                                const Text(
                                  'User Input Data',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Variety'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.wateringPlan!.variety.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Stage'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.wateringPlan!.stage.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Plant density'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.plantDensity.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                // const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Fertilizer used last season'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.fertilizerUsedLastSeason.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Leaf color'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.leafColor.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('water source'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.waterSource.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Soil pH'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.soilPh.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Organic matter content'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.organicMatterContent.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Crop rotation'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.cropRotation.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Pest disease infection'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.pestDiseaseInfestation.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Plant height'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.plantHeight.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Plant density'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.plantDensity.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Stem diameter'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.stemDiameter.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Slope of the land'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.slope.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Irrigation method'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.irrigationMethod.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Soil texture'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.soilTexture.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Soil color'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.soilColor.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                const SizedBox(height: 10),
                                const Text(
                                  'Api Given Data',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Temperature'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.temperature.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Avg temperature'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.avgTemperature.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Rainfall'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.rainfall.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Avg rainfall'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.avgRainfall.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Humidity'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.humidity.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Soil moisture'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.soilMoisture.toString()}'),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                const SizedBox(height: 10),
                                const Text(
                                  'Model Identified Data',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text('Soil Type'),
                                    ),
                                    Expanded(
                                      child: Text(':   ${wateringPlanHistory.soilType.toString()}'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    theme: const ExpandableThemeData(
                        tapBodyToExpand: true,
                        tapBodyToCollapse: true,
                        iconColor: Colors.white,
                        headerAlignment: ExpandablePanelHeaderAlignment.center
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
