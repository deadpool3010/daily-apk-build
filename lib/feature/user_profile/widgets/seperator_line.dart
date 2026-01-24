import 'package:bandhucare_new/core/export_file/app_exports.dart';

class SeperatorLine extends StatelessWidget {
  final double height;
  final double horizontalPadding;
  final Color color;

  const SeperatorLine({super.key, this.height = 1, this.horizontalPadding = 0, this.color = const Color(0xFFECF2F7)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        height: height,
        width: double.infinity,
        color: color,
      ),
    );
  }
}
