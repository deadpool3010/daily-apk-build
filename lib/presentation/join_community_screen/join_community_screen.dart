import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:bandhucare_new/core/utils/context_extensions.dart';

class JoinCommunityScreen extends GetView<JoinCommunityController> {
  const JoinCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        body: SafeArea(
          top: false,
          bottom: context.hasThreeButtonNavigation,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF2563EB),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF2563EB),
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Image.asset(
                            ImageConstant.bandhuCareLogo,
                            width: 32,
                            height: 32,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Bandhu Care',
                            style: TextStyle(
                              fontFamily: 'Paggoda',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14333A66),
                              blurRadius: 24,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Joined ',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                Text(
                                  'Successfully.',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text('👏', style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'We found multiple communities you can join.\nPlease select one to continue:',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 13,
                                    height: 1.4,
                                    color: Color(0xFF6B7280),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Obx(() {
                              if (controller.isLoading.value) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (controller.communities.isEmpty) {
                                return _NoCommunityMessage(
                                  message:
                                      controller
                                          .noCommunityMessage
                                          .value
                                          .isNotEmpty
                                      ? controller.noCommunityMessage.value
                                      : 'No communities found.',
                                );
                              }

                              return Column(
                                children: List.generate(
                                  controller.communities.length,
                                  (index) {
                                    final community =
                                        controller.communities[index];
                                    final communityId =
                                        community["_id"]?.toString() ?? '';
                                    final isSelected = controller
                                        .selectedCommunityIds
                                        .contains(communityId);
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            index ==
                                                controller.communities.length -
                                                    1
                                            ? 0
                                            : 12,
                                      ),
                                      child: Row(
                                        children: [
                                          _SelectionIndicator(
                                            isSelected: isSelected,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: _CommunityOptionTile(
                                              label: community["name"] ?? '',
                                              isSelected: isSelected,
                                              onTap: () => controller
                                                  .toggleSelection(communityId),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                            const SizedBox(height: 24),
                            Obx(() {
                              final hasCommunities =
                                  controller.communities.isNotEmpty;
                              final hasSelection =
                                  controller.selectedCommunityIds.isNotEmpty;
                              final isJoining =
                                  controller.isJoiningCommunity.value;

                              return SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: hasCommunities && !isJoining
                                        ? () {
                                            if (!hasSelection) {
                                              Get.snackbar(
                                                'Select a community',
                                                'Please choose at least one community to continue.',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor:
                                                    Colors.orangeAccent,
                                                colorText: Colors.white,
                                              );
                                              return;
                                            }
                                            controller
                                                .joinSelectedCommunities();
                                          }
                                        : null,
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: hasCommunities
                                            ? LinearGradient(
                                                colors: [
                                                  const Color(
                                                    0xFF0988F3,
                                                  ).withOpacity(
                                                    isJoining ? 0.6 : 1,
                                                  ),
                                                  const Color(
                                                    0xFF0340CC,
                                                  ).withOpacity(
                                                    isJoining ? 0.6 : 1,
                                                  ),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              )
                                            : null,
                                        color: hasCommunities
                                            ? null
                                            : const Color(0xFFCBD5F5),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: hasCommunities
                                            ? (isJoining
                                                  ? const SizedBox(
                                                      width: 22,
                                                      height: 22,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(Colors.white),
                                                      ),
                                                    )
                                                  : const Text(
                                                      'Join Community',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ))
                                            : const Text(
                                                'No Communities Available',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF6B7280),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  // TODO: Handle skip action
                                  Get.back();
                                },
                                child: const Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 14,
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityOptionTile extends StatelessWidget {
  const _CommunityOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF4FF) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 14,
                  color: Color(0xFF111827),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(JamIcons.arrowRight, size: 22, color: Color(0xFF1D2873)),
          ],
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF2563EB), width: 1.6),
      ),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: isSelected ? 10 : 0,
          height: isSelected ? 10 : 0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class _NoCommunityMessage extends StatelessWidget {
  const _NoCommunityMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.group_outlined,
              size: 42,
              color: Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Lato',
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
