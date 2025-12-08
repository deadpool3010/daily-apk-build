import 'package:bandhucare_new/core/app_exports.dart';

class MyAppointment extends StatefulWidget {
  const MyAppointment({super.key});

  @override
  State<MyAppointment> createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
    );
  }
}
