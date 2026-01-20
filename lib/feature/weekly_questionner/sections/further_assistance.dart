import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:flutter/widgets.dart';

class FurtherAssistance extends StatelessWidget {
  FurtherAssistance({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Need Further Assistance ?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
          SizedBox(height: 15),
          Text(
            'We are here to help you',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: 20),
          DynamicButton(
            text: 'Contact us',
            onPressed: () {},
            width: 126,
            height: 40,
            fontSize: 14,
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
