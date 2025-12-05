import 'package:bandhucare_new/core/app_exports.dart';

class HealthCalendar extends StatefulWidget {
  const HealthCalendar({super.key});

  @override
  State<HealthCalendar> createState() => _HealthCalendarState();
}

class _HealthCalendarState extends State<HealthCalendar> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Health Calendar'),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SmoothToggle(
              onChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            Expanded(
              child: selectedIndex == 0
                  ? const MyAppointment()
                  : const YourReminders(),
            ),
          ],
        ),
      ),
    );
  }
}
