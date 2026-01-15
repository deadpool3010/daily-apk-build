import 'package:bandhucare_new/feature/hospital_information/controller/hospital_controller.dart';
import 'package:bandhucare_new/feature/personal_information/widget/info_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HospitalInformationSection extends StatelessWidget {
  const HospitalInformationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HospitalController>();
    return Obx(() {
      final hospital = controller.hospital.value;
      //print("hospital.hospitalName: ${hospital.hospitalName}");
      return Column(
        children: [
          InfoRow(label: "Hospital Name", value: hospital.hospitalName ?? '-'),
          const SizedBox(height: 10),
          InfoRow(label: "Hosptial Type", value: hospital.hospitalType ?? '-'),
          const SizedBox(height: 16),
          InfoRow(label: "Department", value: hospital.department ?? '-'),
          const SizedBox(height: 16),
          InfoRow(
            label: "Emergency Contact",
            value: hospital.emergencyContanct ?? '-',
          ),
          const SizedBox(height: 16),
          InfoRow(
            label: "Main Phone Number",
            value: hospital.mainMobileNumber ?? '-',
          ),
          const SizedBox(height: 16),
          InfoRow(label: "Email Address", value: hospital.email ?? '-'),
          const SizedBox(height: 16),
          InfoRow(
            label: "Operating Hours",
            value: hospital.operatingHours ?? '-',
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Address :",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          InfoRow(label: "Stret/Area", value: hospital.street ?? '-'),
          const SizedBox(height: 16),
          InfoRow(label: "City", value: hospital.city ?? '-'),
          const SizedBox(height: 16),
          InfoRow(label: "State", value: hospital.state ?? '-'),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Map :",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );
    });
  }
}
