import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../models/WateringPlanModel.dart';
import '../../utils/app_colors.dart';

class WateringPlanResultScreen extends StatefulWidget {
  const WateringPlanResultScreen({Key? key, required this.wateringPlan}) : super(key: key);

  final WateringPlanModel wateringPlan;

  @override
  State<WateringPlanResultScreen> createState() => _WateringPlanResultScreenState();
}

class _WateringPlanResultScreenState extends State<WateringPlanResultScreen> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watering Plan Results'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _expandableTile(widget.wateringPlan.wateringPlan!),
              const SizedBox(height: 30),
              const Text(
                'Top Prediction Watering Plan Probabilities',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
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
                      itemCount: widget.wateringPlan.topProbabilities!.length,
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
                                        widget.wateringPlan.topProbabilities![index].plan.toString(),
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
                                        '${(double.parse(widget.wateringPlan.topProbabilities![index].probability!) * 100).toStringAsFixed(2)}%',
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _expandableTile(WateringPlan wateringPlan) {
    return Column(
      children: [
        ExpandableNotifier(
          initialExpanded: true,
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
                  header: const Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      'Predicted Plan',
                      style: TextStyle(
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
                                ':  ${wateringPlan.variety.toString()}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                ':  ${wateringPlan.stage.toString()}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                ':  ${wateringPlan.wateringPlan.toString()}',
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                          child: Column(
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
                                        ':  ${wateringPlan.variety.toString()}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        ':  ${wateringPlan.stage.toString()}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        ':  ${wateringPlan.wateringPlan.toString()}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(),
                              MarkdownBody(
                                data: wateringPlan.description.toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  theme: const ExpandableThemeData(
                      tapHeaderToExpand: false,
                      tapBodyToExpand: false,
                      tapBodyToCollapse: false,
                      iconColor: Colors.white,
                      headerAlignment: ExpandablePanelHeaderAlignment.center
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}
