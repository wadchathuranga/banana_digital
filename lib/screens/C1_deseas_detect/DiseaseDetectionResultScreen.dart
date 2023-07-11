import 'package:flutter/material.dart';

import '../../models/DiseaseDetectionModel.dart';
import '../../screens/C1_deseas_detect/CuresForDiseaseScreen.dart';

class DiseaseDetectionResultScreen extends StatefulWidget {
  const DiseaseDetectionResultScreen({Key? key, required this.data}) : super(key: key);

  final DiseaseDetectionModel data;

  @override
  State<DiseaseDetectionResultScreen> createState() => _DiseaseDetectionResultScreenState();
}

class _DiseaseDetectionResultScreenState extends State<DiseaseDetectionResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(
                  top: 20.0, left: 20, right: 20, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Detection Results',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
              indent: 50.0,
              endIndent: 50.0,
            ),
            const SizedBox(height: 10),
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
                            ':   ${widget.data.disease!.nameDisplay}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _imageWidget(widget.data.originalImgUrl),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _imageWidget(widget.data.detectedImgUrl),
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
                  const SizedBox(height: 50),
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
                              'Disease',
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Cures',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.data.probabilities!.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.data.probabilities![index].diseaseName.toString(),
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
                                  '${(double.parse(widget.data.probabilities![index].avgConfidence!) * 100).toStringAsFixed(2)}%',
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
                                  '${widget.data.probabilities![index].totalArea.toString()} px',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CuresForDiseaseScreen(data: widget.data.disease!))),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.arrow_circle_right_outlined),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  // const SizedBox(height: 50),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ElevatedButton(
                  //           onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => CuresForDiseaseScreen(data: widget.data.disease!))),
                  //           child: const Row(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: [
                  //               Text('Cures for Disease'),
                  //               SizedBox(width: 10),
                  //               Icon(Icons.arrow_circle_right_outlined),
                  //             ],
                  //           ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
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

}
