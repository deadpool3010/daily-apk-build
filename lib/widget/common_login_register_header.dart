import 'package:bandhucare_new/core/app_exports.dart';

class CommonLoginRegisterHeader extends StatelessWidget {
  final String title;
  final String? subtitleText;
  final String? actionText;
  final VoidCallback? onActionTap;
  final VoidCallback? onBackTap;
  final bool showLogo;

  const CommonLoginRegisterHeader({
    super.key,
    required this.title,
    this.subtitleText,
    this.actionText,
    this.onActionTap,
    this.onBackTap,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.loginHeader),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            child: Stack(
              children: [
                // Back Button
                if (onBackTap != null)
                  Positioned(
                    left: 24,
                    top: 20,
                    child: GestureDetector(
                      onTap: onBackTap,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),

                // Title and Subtitle
                Positioned(
                  left: 0,
                  top: 100,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(
                                transitionOnUserGestures: true,
                                tag: 'header_title',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                              if (subtitleText != null || actionText != null)
                                const SizedBox(height: 12),
                              if (subtitleText != null || actionText != null)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: onActionTap,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (subtitleText != null)
                                        Text(
                                          subtitleText!,
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                          ),
                                        ),
                                      if (actionText != null)
                                        Hero(
                                          tag: actionText == 'Register'
                                              ? 'register_to_abha'
                                              : 'login_text',
                                          child: Material(
                                            color: Colors.transparent,
                                            child: Text(
                                              actionText!,
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                decoration: TextDecoration.none,
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
                        if (showLogo) ...[
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: ClipOval(
                              child: Image.asset(
                                ImageConstant.blueLogo,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.medical_services,
                                    color: Colors.white,
                                    size: 30,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
