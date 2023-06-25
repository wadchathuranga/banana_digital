import 'package:banana_digital/models/FertilizerPlanModel.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../utils/app_colors.dart';

class FertilizerPlanResultScreen extends StatefulWidget {
  const FertilizerPlanResultScreen({Key? key, required this.fertilizerPlan}) : super(key: key);

  final FertilizerPlanModel fertilizerPlan;

  @override
  State<FertilizerPlanResultScreen> createState() => _FertilizerPlanResultScreenState();
}

class _FertilizerPlanResultScreenState extends State<FertilizerPlanResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertilizer Plan Results'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _expandableTile(widget.fertilizerPlan.fertilizerPlan!),
              const SizedBox(height: 30),
              const Text(
                'Top Predicted Fertilizer Plans',
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
                                'Dosage',
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
                      itemCount: widget.fertilizerPlan.topProbabilities!.length,
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
                                        widget.fertilizerPlan.topProbabilities![index].dose.toString(),
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
                                        '${(double.parse(widget.fertilizerPlan.topProbabilities![index].probability!) * 100).toStringAsFixed(2)}%',
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

  Widget _expandableTile(FertilizerPlan fertilizerPlan) {
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
                                'Type',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Dose',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ':  ${fertilizerPlan.variety.toString()}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                ':  ${fertilizerPlan.stage.toString()}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                ':  ${fertilizerPlan.fertilizerType.toString()}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                ':  ${widget.fertilizerPlan.dose.toString()}',
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
                                        'Type',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        'Dose',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ':  ${fertilizerPlan.variety.toString()}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        ':  ${fertilizerPlan.stage.toString()}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        ':  ${fertilizerPlan.fertilizerType.toString()}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        ':  ${widget.fertilizerPlan.dose.toString()}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 10),
                              const Divider(),
                              MarkdownBody(
                                data: fertilizerPlan.description.toString(),
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
