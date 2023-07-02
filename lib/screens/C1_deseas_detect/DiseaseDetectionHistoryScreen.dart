import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/DiseaseDetectionModel.dart';
import '../../services/C1_disease_detection_api_service.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../widgets/Loading.dart';
import '../chat_screen/TextWidget.dart';
import './CuresForDiseaseScreen.dart';

class DiseaseDetectionHistoryScreen extends StatefulWidget {
  const DiseaseDetectionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionHistoryScreen> createState() => _DiseaseDetectionHistoryScreenState();
}

class _DiseaseDetectionHistoryScreenState extends State<DiseaseDetectionHistoryScreen> {

  late List<DiseaseDetectionModel> historyList = [];
  String? accessToken;
  bool isLoading = true;

  @override
  void initState() {
    accessToken = UserSharedPreference.getAccessToken().toString();
    fetchHistoryData();
    super.initState();
  }

  // Get disease detection histories by API
  Future fetchHistoryData() async {
    try {

      final response = await C1DiseaseDetectionApiService.diseaseDetectionHistory(accessToken: accessToken!);

      if (response.statusCode == 200) {
        List<dynamic> resData = jsonDecode(response.body);
        if (!mounted) return;
        setState(() {
          historyList = resData.map((history) => DiseaseDetectionModel.fromJson(history)).toList();
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
        title: const Text('Disease Detection History'),
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

  Widget _expandableTile(DiseaseDetectionModel diseaseDetectedHistory) {
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
                        DateFormat('MMM d, yyyy hh:mm:ss a').format(DateTime.parse(diseaseDetectedHistory.createdAt!)).toString(),
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
                              'Detected Disease',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              diseaseDetectedHistory.disease!.nameDisplay.toString(),
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
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Disease Name:',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ':   ${diseaseDetectedHistory.disease!.nameDisplay}',
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _imageWidget(diseaseDetectedHistory.originalImgUrl),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _imageWidget(diseaseDetectedHistory.detectedImgUrl),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Expanded(
                                      child: Text('Original Image', textAlign: TextAlign.center,),
                                    ),
                                    Expanded(
                                      child: Text('Detected Image', textAlign: TextAlign.center,),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                const Text(
                                  'Detection Probabilities',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Divider(
                                  indent: 100,
                                  endIndent: 100,
                                  thickness: 2,
                                ),
                                const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Disease Name',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
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
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Total Areas',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: diseaseDetectedHistory.probabilities!.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                diseaseDetectedHistory.probabilities![index].diseaseName.toString(),
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${(double.parse(diseaseDetectedHistory.probabilities![index].avgConfidence!) * 100).toStringAsFixed(2)}%',
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                diseaseDetectedHistory.probabilities![index].totalArea.toString(),
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const SizedBox(height: 50),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CuresForDiseaseScreen(data: diseaseDetectedHistory.disease!))),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Cures for Disease'),
                                      SizedBox(width: 10),
                                      Icon(Icons.arrow_circle_right_outlined),
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

  Widget _imageWidget(imageUrl) {
    if (imageUrl != null) {
      return Image(
        fit: BoxFit.cover,
        image: NetworkImage(imageUrl),
      );
    } else {
      return const Icon(
        Icons.image_sharp,
        size: 200,
        color: Colors.black12,
      );
    }
  }

}
