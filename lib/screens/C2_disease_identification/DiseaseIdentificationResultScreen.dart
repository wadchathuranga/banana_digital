import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../screens/C2_disease_identification/CuresForDiseaseIdentificationScreen.dart';
import '../../models/DiseaseIdentificationModel.dart';
import '../../utils/app_colors.dart';
import '../chat_screen/TextWidget.dart';

class DiseaseIdentificationResultScreen extends StatefulWidget {
  const DiseaseIdentificationResultScreen({Key? key, required this.result}) : super(key: key);

  final DiseaseIdentificationModel result;

  @override
  State<DiseaseIdentificationResultScreen> createState() => _DiseaseIdentificationResultScreenState();
}

class _DiseaseIdentificationResultScreenState extends State<DiseaseIdentificationResultScreen> {

  late List<Probabilities> _chartData;
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
        title: const Text('Disease Identification'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const Text(
                    'Disease Name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(widget.result.disease != null ? widget.result.disease!.nameDisplay.toString() : 'Not found'),
                  const Divider(),
                  const Text(
                    'Disease Description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  MarkdownBody(data: widget.result.disease != null ? widget.result.disease!.description.toString() : 'Not found'),
                  const Divider(),
                  const Text('Symptom Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                  const SizedBox(height: 10),
                  MarkdownBody(data: widget.result.disease != null ? widget.result.disease!.symptomDescription.toString() : 'Not found'),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryColor,
                              width: 2.0,
                            ),
                          ),
                          child: SfCircularChart(
                            margin: const EdgeInsets.all(5.0),
                            title: ChartTitle(
                              text: 'Top Probabilities',
                              textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                            tooltipBehavior: _tooltipBehavior,
                            series: <CircularSeries>[
                              PieSeries<Probabilities, String>(
                                dataSource: _chartData,
                                xValueMapper: (Probabilities data, _) => data.diseaseType,
                                yValueMapper: (Probabilities data, _) => data.probability,
                                dataLabelSettings: const DataLabelSettings(isVisible: true),
                                enableTooltip: true,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.result.disease != null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CuresForDiseaseIdentificationScreen(
                                    cures: widget.result.disease!.cures)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: TextWidget(label: 'Cures not found'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Cures'),
                          SizedBox(width: 15),
                          Icon(Icons.arrow_circle_right_outlined),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // get chart data
  List<Probabilities> getChartData() {
    final List<Probabilities> chartData = [];
    late double sum = 100.0;
    widget.result.probabilities?.forEach((key, value) {
      sum = sum - (double.parse(value)*100).roundToDouble();
      chartData.add(Probabilities(key, (double.parse(value)*100).roundToDouble()));
    });
    chartData.add(Probabilities('Others', sum));
    return chartData;
  }
}

class Probabilities {
  Probabilities(this.diseaseType, this.probability);
  final String diseaseType;
  final double probability;
}