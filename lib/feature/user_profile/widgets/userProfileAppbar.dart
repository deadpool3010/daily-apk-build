import 'package:bandhucare_new/core/export_file/app_exports.dart';

class UserProfileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const UserProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'My Profile',
        style: TextStyle(
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
