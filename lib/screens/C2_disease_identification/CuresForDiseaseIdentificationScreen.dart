import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../models/DiseaseIdentificationModel.dart';
import '../../utils/app_colors.dart';

class CuresForDiseaseIdentificationScreen extends StatefulWidget {
  const CuresForDiseaseIdentificationScreen({Key? key, required this.cures}) : super(key: key);

  final List<Cures>? cures;

  @override
  State<CuresForDiseaseIdentificationScreen> createState() => _CuresForDiseaseIdentificationScreenState();
}

class _CuresForDiseaseIdentificationScreenState extends State<CuresForDiseaseIdentificationScreen> {
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
              if (widget.cures!.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.cures!.length,
                  itemBuilder: (context, index) {
                    return  _expandableTile(widget.cures![index]);
                  },
                )
              else
                const CircularProgressIndicator(),
            ],
          ),

        ),
      ),
    );
  }


  Widget _expandableTile(Cures cures) {
    return Column(
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
                          MarkdownBody(
                            data: cures.description.toString(),
                            // styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.spaceBetween),
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
    );
  }


  Widget _imageWidget(imageUrl) {
    if (imageUrl != null) {
      return Image.network( /// TODO: image not found exception should be validate
        imageUrl,
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return const Text('Image not found');
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

}
