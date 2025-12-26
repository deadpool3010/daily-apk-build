import 'package:bandhucare_new/core/export_file/app_exports.dart';

class SeperatorLine extends StatelessWidget {
  final double height;
  final double horizontalPadding;

  const SeperatorLine({super.key, this.height = 5, this.horizontalPadding = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Container(
        height: height,
        width: double.infinity,
        color: const Color(0xFFECF2F7),
      ),
    );
  }
}
