import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../models/HarvestPredictionModel.dart';
import '../../utils/app_colors.dart';

class PostHarvestBestPracticesScreen extends StatefulWidget {
  const PostHarvestBestPracticesScreen({Key? key, required this.data}) : super(key: key);

  final List<PostHarvestPractices> data;

  @override
  State<PostHarvestBestPracticesScreen> createState() => _PostHarvestBestPracticesScreenState();
}

class _PostHarvestBestPracticesScreenState extends State<PostHarvestBestPracticesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Harvest Best Practices'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(height: 15),
          // const Text(
          //     'Post Harvest Best Practices',
          //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          // ),
         if (widget.data.isNotEmpty)
           Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return  _expandableTile(widget.data[index]);
              },
            ),
          )
          else
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Center(
                  child: Text('Data not available'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _expandableTile(PostHarvestPractices postHarvestPractices) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Column(
        children: [
          ExpandableNotifier(
            initialExpanded: true,
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
                      child: Row(
                        children: [
                          Text(
                            postHarvestPractices.practiceName.toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                    collapsed: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
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
                                Text(postHarvestPractices.description.toString()),
                                // TODO: Modify code to render markdown text
                                // MarkdownBody(
                                //   data: postHarvestPractices.description.toString(),
                                // )
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
