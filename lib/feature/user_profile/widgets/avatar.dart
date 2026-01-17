import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/core/ui/widgets/avatar/avatar_loader.dart';
import 'package:bandhucare_new/core/ui/widgets/avatar/user_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SessionController>(
      builder: (sessionController) {
        final photo = sessionController.user?.profilePhoto;
        if (photo == null || photo.isEmpty) {
          return DefaultAvatar();
        }

        return ClipOval(
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            height: 50,
            width: 50,
            fit: BoxFit.cover,
            imageUrl: photo,
            placeholder: (context, url) => AvatarLoader(),
            errorWidget: (context, url, error) => DefaultAvatar(),
          ),
        );
      },
    );
  }
}
