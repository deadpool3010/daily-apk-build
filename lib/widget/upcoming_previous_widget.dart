import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFE5EFFE),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header text aligned with dates
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        "Your upcoming appointments",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    buildTimelineWithDates(dates, data),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget dot() {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        height: 17,
        width: 17,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.blue, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      Container(
        height: 8,
        width: 8,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ],
  );
}

Widget line() {
  return Container(
    width: 1,
    height: 90,
    decoration: BoxDecoration(color: Colors.blue),
  );
}

Widget buildTimelineWithDates(
  List<String> dates,
  List<Map<String, String>> data,
) {
  // Use the minimum length to prevent index out of bounds
  final itemCount = dates.length < data.length ? dates.length : data.length;

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      ...List.generate(itemCount, (index) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // DATE - aligned with dot center
              SizedBox(
                child: Transform.translate(
                  offset: const Offset(
                    0,
                    -5,
                  ), // Adjust this value to move up/down (negative = up)
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      dates[index],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: index == 0 ? Colors.blue : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // DOT AND LINE COLUMN
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dot is 15px height, same as date container
                  dot(),
                  if (index != itemCount - 1)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2, bottom: 2),
                        child: line(),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 10),

              // CONTENT (CARD)
              Expanded(
                child: Transform.translate(
                  offset: const Offset(
                    0,
                    -25,
                  ), // Adjust this value to center with dots (negative = up)
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: buildAppointmentCard(data[index]),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ],
  );
}

List<Map<String, String>> data = [
  {"type": "Full body Scan", "time": "11 Am - 01 Pm"},
  {"type": "Full body Scan 2", "time": "09 Am - 11 Pm"},
  {"type": "Full body Scan 2", "time": "09 Am - 11 Pm"},
  {"type": "Full body Scan 2", "time": "09 Am - 11 Pm"},
  {"type": "Full body Scan 2", "time": "09 Am - 11 Pm"},
];

List<String> dates = ["02 Nov", "13 Nov", "30 Nov", "02 Dec", "13 Dec"];

Widget buildAppointmentCard(Map<String, String> data) {
  return Container(
    //constraints: const BoxConstraints(minHeight: 50),
    margin: const EdgeInsets.symmetric(vertical: 0),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ICON CIRCLE
        Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFE5EFFE),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.receipt_long_rounded,
            color: Color(0xFF2063FF),
            size: 22,
          ),
        ),

        const SizedBox(width: 12),

        // TEXT CONTENT
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data["type"] ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                data["time"] ?? "",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
