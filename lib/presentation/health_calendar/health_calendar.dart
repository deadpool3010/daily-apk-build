import 'package:bandhucare_new/core/export_file/app_exports.dart';

class HealthCalendar extends StatefulWidget {
  const HealthCalendar({super.key});

  @override
  State<HealthCalendar> createState() => _HealthCalendarState();
}

class _HealthCalendarState extends State<HealthCalendar> {
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Colors.redAccent,
    //     systemNavigationBarColor: Colors.transparent,
    //   ),
    // );
  }

  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.red,
        systemNavigationBarColor: Colors.transparent,
      ),
      child: Scaffold(
        appBar: CommonAppBar(title: 'Health Calendar'),
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
                child: selectedIndex == 1
                    ? const MyAppointment()
                    : const YourReminders(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
