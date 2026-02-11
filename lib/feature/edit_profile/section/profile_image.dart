import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/feature/edit_profile/controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({super.key});

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  Get.find<EditProfileController>().pickProfileImage(
                    ImageSource.camera,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  Get.find<EditProfileController>().pickProfileImage(
                    ImageSource.gallery,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditProfileController>();
    final sessionController = Get.find<SessionController>();

    return GestureDetector(
      onTap: () => _showImageSourceSheet(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Obx(() {
            final selectedFile = controller.selectedImage.value;
            final profilePhoto = sessionController.user?.profilePhoto;

            Widget imageWidget;
            if (selectedFile != null) {
              imageWidget = ClipOval(
                clipBehavior: Clip.antiAlias,
                child: Image.file(
                  selectedFile,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              );
            } else if (profilePhoto != null && profilePhoto.isNotEmpty) {
              imageWidget = ClipOval(
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  imageUrl: profilePhoto,
                  placeholder: (_, __) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.person, size: 40),
                  ),
                  errorWidget: (_, __, ___) => _buildDefaultAvatar(),
                ),
              );
            } else {
              imageWidget = _buildDefaultAvatar();
            }

            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: imageWidget,
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade300,
      ),
      child: const Icon(Icons.person, size: 50, color: Colors.grey),
    );
  }
}
