import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/feature/personal_information/widget/info_row.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(
      builder: (sessionController) {
        final user = sessionController.user;

        if (user == null) return const SizedBox();

        return Column(
          children: [
            InfoRow(label: 'Phone Number', value: user.mobile ?? '—'),
            const SizedBox(height: 16),
            InfoRow(
              label: 'Email ID',
              value: user.email ?? user.email ?? 'N/A',
            ),
            const SizedBox(height: 16),
            InfoRow(label: 'ABHA Address', value: user.abhaAddress ?? '—'),
            const SizedBox(height: 16),
            InfoRow(label: 'ABHA Number', value: user.abhaNumber ?? '—'),
            const SizedBox(height: 16),
            InfoRow(label: 'Address', value: user.address ?? '—'),
          ],
        );
      },
    );
  }
}
