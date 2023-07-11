import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/DiseaseIdentificationHistoryModel.dart';
import '../../services/C2_disease_identification_api_service.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../widgets/Loading.dart';
import '../chat_screen/TextWidget.dart';
import './CuresForDiseaseIdentificationHistoryScreen.dart';

class DiseaseIdentificationHistoryScreen extends StatefulWidget {
  const DiseaseIdentificationHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseIdentificationHistoryScreen> createState() => _DiseaseIdentificationHistoryScreenState();
}

class _DiseaseIdentificationHistoryScreenState extends State<DiseaseIdentificationHistoryScreen> {

  late List<DiseaseIdentificationHistoryModel> historyList = [];
  String? accessToken;
  String? lang;
  bool isLoading = true;

  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    accessToken = UserSharedPreference.getAccessToken().toString();
    lang = UserSharedPreference.getLanguage().toString();
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchHistoryData();
    super.initState();
  }

  // Get disease detection histories by API
  Future fetchHistoryData() async {
    try {
      final response = await C2DiseaseIdentificationApiService.diseaseIdentificationHistory(accessToken: accessToken!, lang: lang!);

      if (response.statusCode == 200) {
        List<dynamic> resData = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          historyList = resData.map((history) => DiseaseIdentificationHistoryModel.fromJson(history)).toList();
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
        title: const Text('Disease Identification History'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
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

  Widget _expandableTile(DiseaseIdentificationHistoryModel diseaseIdentificationHistory) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
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
                        DateFormat('MMM d, yyyy hh:mm:ss a').format(DateTime.parse(diseaseIdentificationHistory.createdAt!)).toString(),
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
                              'Identified Disease',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              diseaseIdentificationHistory.disease!.nameDisplay.toString(),
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
                            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0, bottom: 5.0),
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Disease',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${diseaseIdentificationHistory.disease!.nameDisplay}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                                _imageWidget(diseaseIdentificationHistory.disease!.img),
                                const Text(
                                  '- Image -',
                                ),
                                const SizedBox(height: 10),
                                const Divider(
                                  thickness: 2,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Description',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                MarkdownBody(data: diseaseIdentificationHistory.disease!.description!),
                                const SizedBox(height: 10),
                                const Divider(
                                  thickness: 2,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Symptom Description',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                MarkdownBody(data: diseaseIdentificationHistory.disease!.symptomDescription.toString()),
                                const SizedBox(height: 10),
                                const Divider(
                                  // indent: 100,
                                  // endIndent: 100,
                                  thickness: 2,
                                ),
                                topPredictionPieChart(diseaseIdentificationHistory.probabilities),
                                const Divider(
                                  // indent: 100,
                                  // endIndent: 100,
                                  thickness: 2,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'User Input Data',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text('Leaf color'),
                                        ),
                                        Expanded(
                                          child: Text(':   ${diseaseIdentificationHistory.leafColor.toString()}'),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    // const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text('Stunt growth'),
                                        ),
                                        Expanded(
                                          child: Text(':   ${diseaseIdentificationHistory.stuntedGrowth.toString()}'),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    // const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text('Abnormal fruiting'),
                                        ),
                                        Expanded(
                                          child: Text(':   ${diseaseIdentificationHistory.abnormalFruiting.toString()}'),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    // const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text('Leaf curling'),
                                        ),
                                        Expanded(
                                          child: Text(':   ${diseaseIdentificationHistory.leafCurling.toString()}'),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text('Leaf spots'),
                                        ),
                                        Expanded(
                                          child: Text(':   ${diseaseIdentificationHistory.leafSpots.toString()}'),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text('Stem color'),
                                        ),
                                        Expanded(
                                          child: Text(':   ${diseaseIdentificationHistory.stemColor.toString()}'),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text('Root rot'),
                                        ),
                                        Expanded(
                                          child: Text(':   ${diseaseIdentificationHistory.rootRot.toString()}'),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text('Leaf wilting'),
                                        ),
                                        Expanded(
                                          child: Text(':   ${diseaseIdentificationHistory.leafWilting.toString()}'),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text('Presence of pets'),
                                        ),
                                        Expanded(
                                          child: Text(':   ${diseaseIdentificationHistory.presenceOfPests.toString()}'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      child:  ElevatedButton(
                                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CuresForDiseaseIdentificationHistoryScreen(cures: diseaseIdentificationHistory.disease!.cures))),
                                        // onPressed: null,
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Cures'),
                                            SizedBox(width: 10),
                                            Icon(Icons.arrow_circle_right_outlined)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
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

  Widget _imageWidget(imageUrl) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Text('Image not found', style: TextStyle(color: Colors.red),);
        },
      );
    } else {
      return const Icon(
        Icons.image_sharp,
        size: 200,
        color: Colors.black12,
      );
    }
  }

  Widget topPredictionPieChart(topProbabilities) {
    return SizedBox(
      width: 250,
      height: 200,
      child: SfCircularChart(
        margin: const EdgeInsets.only(top: 20.0),
        title: ChartTitle(
          text: 'Top 03 Probabilities',
          textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
        ),
        legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.scroll),
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