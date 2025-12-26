import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/feature/user_profile/widgets/abha_card_container.dart';
import 'package:bandhucare_new/feature/user_profile/widgets/abha_card_front.dart';

class AbhaSection extends StatelessWidget {
  const AbhaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(
      builder: (sessionController) {
        final user = sessionController.user;
        if (user?.abhaNumber == null) return const SizedBox();
        return AbhaCardContainer(user: user!);
      },
    );
  }
}
