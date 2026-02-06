import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    // NOTE: This widget is used inside scrollables (e.g. a horizontal ListView on
    // the home screen). Returning a Scaffold here will cause unbounded (infinite)
    // layout constraints and crash with "infinite size during layout".
    return SizedBox(
      width: 360,
      height: 135,
      child: Container(
        decoration: ShapeDecoration(
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 30,
              cornerSmoothing: 1.0,
            ),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3865FF), Color(0xFF223D99)],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DateShowCard(),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DoctorNameAndSession(),
                  SizedBox(height: 8),
                  ThickLine(),
                  SizedBox(height: 8),
                  TimeDuration(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateShowCard extends StatelessWidget {
  const DateShowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius(
            cornerRadius: 18,
            cornerSmoothing: 1.0,
          ),
        ),
        color: Color(0xFFE5EFFE),
      ),
      height: 110,
      width: 85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Thu",
            style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          Text(
            "23",
            style: TextStyle(
              fontFamily: "Lato",
              fontWeight: FontWeight.bold,
              color: Color(0xFF3865FF),
              fontSize: 40,
            ),
          ),
        ],
      ),
    );
  }
}

class ThickLine extends StatelessWidget {
  const ThickLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(1.0),
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.1),
          ],
          stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
        ),
      ),
    );
  }
}

class DoctorNameAndSession extends StatelessWidget {
  const DoctorNameAndSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Appointment with Dr. Vishnu",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Roboto",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2),
        Text(
          "Therapy Session",
          style: TextStyle(
            fontSize: 15,
            fontFamily: "Roboto",
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class TimeDuration extends StatelessWidget {
  const TimeDuration({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Upcoming",
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "11 Am - 01 Pm",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
