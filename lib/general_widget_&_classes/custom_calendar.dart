import 'package:bandhucare_new/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

String _formatMonthYear(DateTime date) {
  final months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.year}';
}

class CustomCalander extends StatefulWidget {
  const CustomCalander({super.key});

  @override
  State<CustomCalander> createState() => _CustomCalanderState();
}

class _CustomCalanderState extends State<CustomCalander> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          //  crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Custom header with month/year and navigation arrows on the right
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 16, right: 16),
              child: SizedBox(
                width: constraints.maxWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatMonthYear(_focusedDay),
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _focusedDay = DateTime(
                                _focusedDay.year,
                                _focusedDay.month - 1,
                              );
                            });
                          },
                          child: Icon(Icons.chevron_left, color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _focusedDay = DateTime(
                                _focusedDay.year,
                                _focusedDay.month + 1,
                              );
                            });
                          },
                          child: Icon(Icons.chevron_right, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 7),
            TableCalendar(
              //  key: ValueKey(_focusedDay),
              pageAnimationEnabled: true,

              pageJumpingEnabled: true,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return _selectedDay != null && isSameDay(_selectedDay!, day);
              },
              calendarFormat: _calendarFormat,
              // onFormatChanged: (format) {
              //   if (_calendarFormat != format) {
              //     setState(() {
              //       _calendarFormat = format;
              //     });
              //   }
              // },
              // onDaySelected: (selectedDay, focusedDay) {
              //   if (_selectedDay == null ||
              //       !isSameDay(_selectedDay!, selectedDay)) {
              //     setState(() {
              //       _selectedDay = selectedDay;
              //       _focusedDay = focusedDay;
              //     });
              //   } // if the day is selected, set the selected day and the focused da
              // },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  HapticFeedback.selectionClick();
                });
              },
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 14,
                ),
                defaultTextStyle: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 14,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 14,
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0xFFE5EFFE),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: GoogleFonts.roboto(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                markerDecoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  shape: BoxShape.circle,
                ),
              ),
              headerVisible: false,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: GoogleFonts.roboto(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
