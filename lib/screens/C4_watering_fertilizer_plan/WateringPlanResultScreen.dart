import 'package:banana_digital/models/WateringPlanModel.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
        title: const Text('Watering Plan'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Watering Plan Results',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
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
                          'Predicted Watering Plan',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.wateringPlan.prediction.toString().toUpperCase(),
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            //
            const SizedBox(height: 30),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //       height: 50,
            //       width: MediaQuery.of(context).size.width*3/4,
            //       child: ElevatedButton(
            //         onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostHarvestBestPracticesScreen(data: widget.result.postHarvestPractices!))),
            //         child: const Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Text('Post Harvest Best Practices'),
            //             SizedBox(width: 10),
            //             Icon(Icons.arrow_circle_right_outlined)
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

}
