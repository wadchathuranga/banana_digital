import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../screens/C3_harvest_predict/PostHarvestBestPracticesScreen.dart';
import '../../models/HarvestPredictionModel.dart';
import '../../utils/app_colors.dart';

class HarvestPredictionResultScreen extends StatefulWidget {
  const HarvestPredictionResultScreen({Key? key, required this.result}) : super(key: key);

  final HarvestPredictionModel result;

  @override
  State<HarvestPredictionResultScreen> createState() => _HarvestPredictionResultScreenState();
}

class _HarvestPredictionResultScreenState extends State<HarvestPredictionResultScreen> {

  late List<TopPrediction> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harvest Predict'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 10.0),
          child: Column(
            children: [
              const Text(
                  'Harvest Predicted Results',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2.0,
                        ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Text(
                              'Predicted Harvest',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.result.prediction.toString(),
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2.0,
                      ),
                    ),
                    child: SfCircularChart(
                      margin: const EdgeInsets.only(top: 20.0),
                      title: ChartTitle(
                        text: 'Top 03 Predictions',
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                      tooltipBehavior: _tooltipBehavior,
                      series: <CircularSeries>[
                        PieSeries<TopPrediction, String>(
                            dataSource: _chartData,
                            xValueMapper: (TopPrediction data, _) => data.weightRange,
                            yValueMapper: (TopPrediction data, _) => data.probability,
                            dataLabelSettings: const DataLabelSettings(isVisible: true),
                            enableTooltip: true,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width*3/4,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostHarvestBestPracticesScreen(data: widget.result.postHarvestPractices!))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Post Harvest Best Practices'),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_circle_right_outlined)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // get chart data
  List<TopPrediction> getChartData() {
    final List<TopPrediction> chartData = [];
    late double sum = 100.0;
    widget.result.topProbabilities?.forEach((key, value) {
      sum = sum - (double.parse(value)*100).roundToDouble();
      chartData.add(TopPrediction(key, (double.parse(value)*100).roundToDouble()));
    });
    chartData.add(TopPrediction('Others', sum));
    return chartData;
  }
}

class TopPrediction {
  TopPrediction(this.weightRange, this.probability);
  final String weightRange;
  final double probability;
}
