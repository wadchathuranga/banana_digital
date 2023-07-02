import 'dart:convert';
import 'package:banana_digital/services/C3_harvest_prediction_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/HarvestPredictionHistoryModel.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_configs.dart';
import '../../widgets/Loading.dart';
import '../chat_screen/TextWidget.dart';
import 'PostHarvestBestPracticesScreen.dart';


class HarvestPredictionHistoryScreen extends StatefulWidget {
  const HarvestPredictionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<HarvestPredictionHistoryScreen> createState() => _HarvestPredictionHistoryScreenState();
}

class _HarvestPredictionHistoryScreenState extends State<HarvestPredictionHistoryScreen> {

  late List<HarvestPredictionHistoryModel> historyList = [];
  String? accessToken;
  bool isLoading = true;

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    accessToken = UserSharedPreference.getAccessToken().toString();
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchHistoryData();
    super.initState();
  }

  // Get harvest prediction histories API
  Future fetchHistoryData() async {
    try {
      // var url = Uri.parse(HARVEST_PREDICTION_HISTORIES);
      // final response = await http.get(
      //   url,
      //   headers: {
      //     "Content-Type": "application/json",
      //     "Authorization": "Bearer $accessToken",
      //   },
      // );

      http.Response response = await C3HarvestPredictionApiService.getHarvestHistoryData(accessToken: accessToken!);

      if (response.statusCode == 200) {
        List<dynamic> resData = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          historyList = resData.map((history) => HarvestPredictionHistoryModel.fromJson(history)).toList();
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: TextWidget(label: 'Something went wrong!'),
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
        title: const Text('Harvest Prediction History'),
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
                : const LoadingWidget(msg: 'Loading...',),
          ),
        ],
      ),
    );
  }

  Widget _expandableTile(HarvestPredictionHistoryModel harvestPredictedHistory) {
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
                              'Predicted Harvest',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              harvestPredictedHistory.predictedHarvest.toString(),
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Predicted Harvest',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  harvestPredictedHistory.predictedHarvest.toString(),
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                                ),
                                // PIE CHART
                                topPredictionPieChart(harvestPredictedHistory.topProbabilities),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'User Input Data',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        children: [
                                          const Expanded(
                                              child: Text('Agro climatic region'),
                                          ),
                                          Expanded(
                                              child: Text(':   ${harvestPredictedHistory.agroClimaticRegion.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Plant density'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.plantDensity.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Spacing between plants'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.spacingBetweenPlants.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Pesticides used'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.pesticidesUsed.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Plant generation'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.plantGeneration.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Fertilizer type'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.fertilizerType.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Soil pH'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.soilPH.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Amount of sunlight received'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.amountOfSunlightReceived.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Watering schedule'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.wateringSchedule.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Number of leaves'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.numberOfLeaves.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Height'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.height.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      // const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('Variety'),
                                          ),
                                          Expanded(
                                            child: Text(':   ${harvestPredictedHistory.variety.toString()}'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        child:  ElevatedButton(
                                          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostHarvestBestPracticesScreen(data: harvestPredictedHistory.postHarvestPractices!))),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Post Harvest Best Practices'),
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

  Widget topPredictionPieChart(topProbabilities) {
    return SizedBox(
      width: 250,
      height: 200,
      child: SfCircularChart(
        margin: const EdgeInsets.only(top: 20.0),
        title: ChartTitle(
          text: 'Top 03 Predictions',
          textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 13),
        ),
        legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        tooltipBehavior: _tooltipBehavior,
        series: <CircularSeries>[
          PieSeries<TopPrediction, String>(
            radius: '55',
            dataSource: getChartData(topProbabilities),
            xValueMapper: (TopPrediction data, _) => data.weightRange,
            yValueMapper: (TopPrediction data, _) => data.probability,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true,
          ),
        ],
      ),
    );
  }

  List<TopPrediction> getChartData(data) {
    final List<TopPrediction> chartData = [];
    late double rest = 100.0;
    data.forEach((key, value) {
      rest = rest - (double.parse(value)*100).roundToDouble();
      chartData.add(TopPrediction(key, (double.parse(value)*100).roundToDouble()));
    });
    if (rest >= 0) chartData.add(TopPrediction('Others', rest));
    return chartData;
  }


}

class TopPrediction {
  TopPrediction(this.weightRange, this.probability);
  final String weightRange;
  final double probability;
}
