import 'package:banana_digital/screens/zoom_drawer_menu/menu_widget.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  var selectedSalutation;
  late String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text('Form Testing', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(thickness: 3),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // autovalidate: _autovalidate,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: DropdownButtonFormField<String>(
                      validator: (val) {
                        if (val == null) {return 'Required!';} else {return null;}
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Grade',
                      ),
                      items: ['MR.', 'MS.'].map((gradeItem) {
                        return DropdownMenuItem(
                          value: gradeItem
                              .toString(),
                          child: Text(gradeItem
                              .toString()),
                        );
                      }).toList(),
                      onChanged: (newValueSelected) {
                        setState(() {
                          selectedSalutation = newValueSelected;
                        });
                      },
                      value: selectedSalutation,
                      isExpanded: false,
                      // hint: Text('Grade'),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Grade',
                    ),
                    onChanged: (val) =>
                        setState(() => selectedSalutation = val!),
                    validator: (value) => value == null ? 'field required' : null,
                    items:
                    ['MR.', 'MS.'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: selectedSalutation,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: 'Name'),
                    validator: (value) => value!.isEmpty ? 'Name is required' : null,
                    onSaved: (value) => name = value!,
                  ),
                  ElevatedButton(
                    child: Text('PROCEED'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        selectedSalutation;
                        //form is valid, proceed further
                        _formKey.currentState!.save();//save once fields are valid, onSaved method invoked for every form fields

                      } else {
                        setState(() {

                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
