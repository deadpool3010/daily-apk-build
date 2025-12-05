import 'package:bandhucare_new/core/app_exports.dart';

class ScanQrScreen extends StatelessWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScanQrController>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Camera Preview Area
            Positioned.fill(child: _buildCameraPreview(controller)),

            // Top Header
            Positioned(top: 26, left: 0, right: 0, child: _buildHeader()),

            // Scanning Frame Overlay
            Positioned.fill(child: _buildScanningOverlay(controller)),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview(ScanQrController controller) {
    return Obx(() {
      final scannerController = controller.mobileScannerController.value;
      final error = controller.cameraError.value;

      if (error != null) {
        return Container(
          color: Colors.black,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white70,
                    size: 48,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // if (scannerController == null) {
      //   return Container(
      //     color: Colors.black,
      //     child: Center(
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           CircularProgressIndicator(color: Colors.white),
      //           SizedBox(height: 16),
      //           Text(
      //             'Initializing camera...',
      //             style: TextStyle(color: Colors.white, fontSize: 14),
      //           ),
      //         ],
      //       ),
      //     ),
      //   );
      // }

      return Stack(
        children: [
          MobileScanner(
            controller: scannerController,
            fit: BoxFit.cover,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && controller.isScanning.value) {
                final rawValue = barcodes.first.rawValue;
                if (rawValue != null) {
                  controller.handleBarcode(rawValue);
                }
              }
            },
          ),
          // Grid overlay
          CustomPaint(painter: CameraGridPainter(), child: Container()),
        ],
      );
    });
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          Text(
            'Scan QR',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Lato',
              fontWeight: FontWeight.w600,
            ),
          ),
          Image.asset(ImageConstant.bandhuCareLogo, width: 44, height: 44),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay(ScanQrController controller) {
    return Stack(
      children: [
        // Dark overlay with transparent center
        CustomPaint(painter: ScanningFramePainter(), child: Container()),

        // Scanning frame border
        Center(
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              // border: Border.all(color: Color(0xFFFF6B35), width: 3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                // Corner indicators
                Positioned(
                  top: -2,
                  left: -2,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFFF6B35), width: 4),
                        left: BorderSide(color: Color(0xFFFF6B35), width: 4),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFFF6B35), width: 4),
                        right: BorderSide(color: Color(0xFFFF6B35), width: 4),
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  left: -2,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFFF6B35), width: 4),
                        left: BorderSide(color: Color(0xFFFF6B35), width: 4),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFFF6B35), width: 4),
                        right: BorderSide(color: Color(0xFFFF6B35), width: 4),
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Timer countdown at bottom
        // Positioned(
        //   bottom: 100,
        //   left: 0,
        //   right: 0,
        //   child: Center(
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        //       decoration: BoxDecoration(
        //         color: Colors.black.withOpacity(0.7),
        //         borderRadius: BorderRadius.circular(30),
        //       ),
        //       child: Text(
        //         'Scanning in ${controller.countdown.value}...',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 16,
        //           fontWeight: FontWeight.w500,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

// Custom painter for camera grid
class CameraGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw grid lines
    final spacing = size.width / 3;
    for (int i = 1; i < 3; i++) {
      // Vertical lines
      canvas.drawLine(
        Offset(spacing * i, 0),
        Offset(spacing * i, size.height),
        paint,
      );
      // Horizontal lines
      canvas.drawLine(
        Offset(0, spacing * i),
        Offset(size.width, spacing * i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for scanning frame overlay
class ScanningFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final frameSize = 280.0;
    final frameLeft = (size.width - frameSize) / 2;
    final frameTop = (size.height - frameSize) / 2;

    // Draw dark overlay with transparent center
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final transparentPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(frameLeft, frameTop, frameSize, frameSize),
          Radius.circular(24),
        ),
      );

    final combinedPath = Path.combine(
      PathOperation.difference,
      path,
      transparentPath,
    );

    canvas.drawPath(combinedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
