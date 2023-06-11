import 'package:flutter/material.dart';

class PredictionHistoryScreen extends StatefulWidget {
  const PredictionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<PredictionHistoryScreen> createState() => _PredictionHistoryScreenState();
}

class _PredictionHistoryScreenState extends State<PredictionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prediction History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text('Prediction Histories'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Text("List View $index");
              },
            ),
          ],
        ),
      ),
    );
  }
}
