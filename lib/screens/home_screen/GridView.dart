import 'package:banana_digital/utils/app_colors.dart';
import 'package:flutter/material.dart';



class GridViewCard extends StatefulWidget {
  const GridViewCard({Key? key, required this.title, required this.icon, required this.img, required this.value}) : super(key: key);

  final String title;
  final IconData icon;
  final String img;
  final String value;

  @override
  State<GridViewCard> createState() => _GridViewCardState();
}

class _GridViewCardState extends State<GridViewCard> {


  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // color: Colors.blue,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryColor,
              // color: Colors.transparent,
              width: 2.0,
            ),
          ),
          child: InkWell(
            onTap: (){
              if (widget.value == '1') {
                Navigator.pushNamed(context, '/C1_main');
              } else if (widget.value == '2') {
                Navigator.pushNamed(context, '/C2_main');
              } else if (widget.value == '3') {
                Navigator.pushNamed(context, '/C3_main');
              } else if (widget.value == '4') {
                Navigator.pushNamed(context, '/C4_main');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Image.asset(
                          widget.img,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 70,
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
