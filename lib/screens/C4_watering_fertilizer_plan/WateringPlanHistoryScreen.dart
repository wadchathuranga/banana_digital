import 'dart:convert';
import 'package:expandable/expandable.dart';
import 'package:http/http.dart' as http;
import 'package:banana_digital/models/WateringPlanHistoryModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_configs.dart';
import '../../widgets/Loading.dart';
import '../../widgets/TextWidget.dart';

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
      var url = Uri.parse(WATERING_PLAN_HISTORY);
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> resData = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            historyList = resData.map((history) => WateringPlanHistoryModel.fromJson(history)).toList();
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget(label: response.reasonPhrase.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (err) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: err.toString()),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("================= Catch Error ====================");
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

  Widget _expandableTile(WateringPlanHistoryModel harvestPredictedHistory) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Column(
        children: [
          ExpandableNotifier(
            initialExpanded: false,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
                ScrollOnExpand(
                  child: ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        DateFormat('MMM d, yyyy hh:mm:ss a').format(DateTime.parse(harvestPredictedHistory.createdAt!)).toString(),
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
                        child: Column(
                          children: [
                            const Text(
                              'Predicted Watering Plan',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'harvestPredictedHistory.predictedHarvest.toString()',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
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
                      child: const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                            child: Column(
                              children: [
                                Text(
                                  'Predicted Fertilizer Plan',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'fertilizerPlanHistory.predictedHarvest.toString()',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                                ),
                                // PIE CHART
                                // topPredictionPieChart(harvestPredictedHistory.topProbabilities),
                                SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'User Input Data',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 15),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Agro climatic region'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.agroClimaticRegion.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Plant density'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.plantDensity.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Spacing between plants'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.spacingBetweenPlants.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Pesticides used'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.pesticidesUsed.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Plant generation'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.plantGeneration.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Fertilizer type'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.fertilizerType.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Soil pH'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.soilPH.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Amount of sunlight received'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.amountOfSunlightReceived.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Watering schedule'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.wateringSchedule.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Number of leaves'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.numberOfLeaves.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Height'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.height.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text('Variety'),
                                          ),
                                          // Expanded(
                                          //   child: Text(':   ${harvestPredictedHistory.variety.toString()}'),
                                          // ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      SizedBox(
                                        child:  ElevatedButton(
                                          onPressed: null, // () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostHarvestBestPracticesScreen(data: harvestPredictedHistory.postHarvestPractices!))),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Watering Plans'),
                                              SizedBox(width: 10),
                                              Icon(Icons.arrow_circle_right_outlined)
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  // Widget topPredictionPieChart(topProbabilities) {
  //   return SizedBox(
  //     width: 250,
  //     height: 200,
  //     child: SfCircularChart(
  //       margin: const EdgeInsets.only(top: 20.0),
  //       title: ChartTitle(
  //         text: 'Top 03 Predictions',
  //         textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),
  //       ),
  //       legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
  //       tooltipBehavior: _tooltipBehavior,
  //       series: <CircularSeries>[
  //         PieSeries<TopPrediction, String>(
  //           radius: '55',
  //           dataSource: getChartData(topProbabilities),
  //           xValueMapper: (TopPrediction data, _) => data.weightRange,
  //           yValueMapper: (TopPrediction data, _) => data.probability,
  //           dataLabelSettings: const DataLabelSettings(isVisible: true),
  //           enableTooltip: true,
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
