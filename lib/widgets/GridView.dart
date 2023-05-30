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
      margin: const EdgeInsets.all(5.0),
      // color: Colors.blue,
      child: InkWell(
        onTap: (){
          if (widget.value == '1') {
            Navigator.pushNamed(context, '/one');
          } else if (widget.value == '2') {
            Navigator.pushNamed(context, '/two');
          } else if (widget.value == '3') {
            Navigator.pushNamed(context, '/three');
          } else if (widget.value == '4') {
            Navigator.pushNamed(context, '/four');
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
                height: 100,
                child: Container(
                  color: AppColors.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      widget.img,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3,),
              SizedBox(
                height: 80,
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
    );
  }
}
