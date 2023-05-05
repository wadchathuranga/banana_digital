import 'package:flutter/material.dart';

class OneResultScreen extends StatefulWidget {
  const OneResultScreen({Key? key}) : super(key: key);

  @override
  State<OneResultScreen> createState() => _OneResultScreenState();
}

class _OneResultScreenState extends State<OneResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 30.0, left: 20, right: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Classification Results',
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
            const SizedBox(height: 15),
            // _imageWidget(widget.result.imageUrl),
            _imageWidget('imageUrl'),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Disease Name:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Reason:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '   :   ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '   :   ',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bacteria',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Text(
                      'Lack of sun lights',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _imageWidget(imageUrl) {
    // if (imageUrl) {
    if (true) {
      return SizedBox(
        width: MediaQuery.of(context).size.width / 6 * 4,
        height: 250,
        child: Image.network('https://res.cloudinary.com/practicaldev/image/fetch/s--Uu8lVunk--/c_imagga_scale,f_auto,fl_progressive,h_1080,q_auto,w_1080/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/hz1b1ztf4rihmyyes0ew.png'),
      );
    } else {
      return SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width / 6 * 4,
        child: Container(
          color: Colors.black12,
          child: const Icon(
            Icons.image_sharp,
            size: 250,
            color: Colors.black12,
          ),
        ),
      );
    }
  }
}
