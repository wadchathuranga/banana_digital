import 'dart:convert';

import 'package:banana_digital/services/C1_disease_detection_api_service.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../models/DiseaseDetectionModel.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../widgets/Loading.dart';
import '../chat_screen/TextWidget.dart';

class CuresForDiseaseScreen extends StatefulWidget {
  const CuresForDiseaseScreen({Key? key, required this.diseaseName}) : super(key: key);

  final String diseaseName;

  @override
  State<CuresForDiseaseScreen> createState() => _CuresForDiseaseScreenState();
}

class _CuresForDiseaseScreenState extends State<CuresForDiseaseScreen> {

  bool isLoading = false;
  Disease? data;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    String? accessToken = UserSharedPreference.getAccessToken().toString();
    getCuresByName(accessToken, widget.diseaseName);
  }

  Future getCuresByName(accessToken, diseaseName) async {
    try {
      final response = await C1DiseaseDetectionApiService.getCuresByDiseaseName(accessToken: accessToken, diseaseName: diseaseName);
      if (response.statusCode == 200) {
        data = Disease.fromJson(jsonDecode(response.body));
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
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
        title: const Text('Cures'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (data != null && !isLoading)
            SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
              child: Column(
                children: [
                  const Text(
                    'DISEASE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _imageWidget(data!.img),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      const Text(
                        'Name',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(data!.name.toString()),
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
                      MarkdownBody(data: data!.description!),
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
                      MarkdownBody(data: data!.symptomDescription.toString()),
                      const SizedBox(height: 10),
                      const Divider(
                        thickness: 2,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Cures',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      if (data!.cures!.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: data!.cures!.length,
                          itemBuilder: (context, index) {
                            return  _expandableTile(data!.cures![index]);
                          },
                        )
                      else
                        const Text('Curse not found', style: TextStyle(color: Colors.red),),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (data == null && !isLoading)
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Center(
                child: Text('Cures not found!'),
              ),
            ),
          if (isLoading)
            const LoadingWidget(),
        ],
      ),
    );
  }

  Widget _imageWidget(imageUrl) {
    if (imageUrl != null) {
      // return Image(
      //   fit: BoxFit.cover,
      //   image: NetworkImage(imageUrl),
      // ); // img not found bug fixed
      return Image.network(
        fit: BoxFit.cover,
        imageUrl.toString(),
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Text('Image not found!', style: TextStyle(color: Colors.red),);
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

  Widget _expandableTile(Cures cures) {
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
                        cures.nameDisplay.toString(),
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
                            MarkdownBody(data: cures.description.toString()),
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
                                      _imageWidget(cures.img),
                                      const SizedBox(height: 10),
                                      MarkdownBody(data: cures.description.toString()),
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

}
