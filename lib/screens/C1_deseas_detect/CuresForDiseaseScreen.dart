import 'package:banana_digital/models/DiseaseDetectionModel.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../utils/app_colors.dart';

class CuresForDiseaseScreen extends StatefulWidget {
  const CuresForDiseaseScreen({Key? key, required this.data}) : super(key: key);

  final Disease data;

  @override
  State<CuresForDiseaseScreen> createState() => _CuresForDiseaseScreenState();
}

class _CuresForDiseaseScreenState extends State<CuresForDiseaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cures'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
          child: Column(
            children: [
              const Text(
                'DISEASE',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _imageWidget(widget.data.img),
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
                  Text(widget.data.name.toString()),
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
                  MarkdownBody(data: widget.data.description!),
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
                  MarkdownBody(data: widget.data.symptomDescription.toString()),
                  const SizedBox(height: 10),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Cures',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (widget.data.cures!.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.data.cures!.length,
                      itemBuilder: (context, index) {
                        return  _expandableTile(widget.data.cures![index]);
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
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
                            Text(
                              widget.data.description.toString(),
                              style: const TextStyle(fontSize: 16),
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
                                      _imageWidget(widget.data.img),
                                      const SizedBox(height: 10),
                                      const Text(
                                        '- Disease Image -',
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        widget.data.description.toString(),
                                        style: const TextStyle(fontSize: 16),
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

}
