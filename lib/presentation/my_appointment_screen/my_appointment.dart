import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/utils/context_extensions.dart';

class MyAppointment extends StatefulWidget {
  const MyAppointment({super.key});

  @override
  State<MyAppointment> createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: context.hasThreeButtonNavigation,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 20),
                CustomCalander(),
                const SizedBox(height: 20),
                Events(),
                const SizedBox(height: 20),
                Events(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
