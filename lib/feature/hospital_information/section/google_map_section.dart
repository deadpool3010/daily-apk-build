import 'package:bandhucare_new/core/constants/variables.dart';
import 'package:bandhucare_new/core/utils/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Geolocator, LocationPermission;
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class GoogleMapSection extends StatelessWidget {
  const GoogleMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _openMap(context);
        },
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            image: DecorationImage(
              image: AssetImage(ImageConstant.google_map_section_img),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _openGoogleMapRouting({
  double? currentLat,
  double? currentLng,
  double? destinationLat,
  double? destinationLng,
  required BuildContext context,
}) async {
  // Only include origin if we have valid coordinates
  String originParam = '';
  if (currentLat != null &&
      currentLng != null &&
      currentLat != 0 &&
      currentLng != 0) {
    originParam = '&origin=$currentLat,$currentLng';
  }

  // Ensure destination coordinates are valid
  if (destinationLat == null ||
      destinationLng == null ||
      destinationLat == 0 ||
      destinationLng == 0) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Destination coordinates are not available'),
        ),
      );
    }
    return;
  }

  final String googleMapUrl =
      "https://www.google.com/maps/dir/?api=1$originParam&destination=$destinationLat,$destinationLng&travelmode=driving";

  final Uri url = Uri.parse(googleMapUrl);
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open Google Maps');
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open Google Maps: $e')));
    }
  }
}

Future<List<double>?> _getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text('Location services are disabled'),
      description: Text(
        'Please enable location services in your device settings',
      ),
    );
    return null;
  }

  // Check current permission status
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    // Request permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text('Location permissions denied'),
        description: Text(
          'Please enable location permissions to use this feature',
        ),
      );
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text('Location permissions permanently denied'),
      description: Text(
        'Please enable location permissions in your app settings',
      ),
    );
    return null;
  }

  // Get current position
  try {
    final position = await Geolocator.getCurrentPosition();
    return [position.latitude, position.longitude];
  } catch (e) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text('Failed to get location'),
      description: Text('An error occurred while getting your location'),
    );
    return null;
  }
}

Future<void> _openMap(BuildContext context) async {
  double currentLat = 0;
  double currentLng = 0;
  double destinationLat = destLat ?? 0;
  double destinationLng = destLong ?? 0;

  List<double>? location = await _getLocation();
  if (location != null) {
    currentLat = location[0];
    currentLng = location[1];
  }
  print('currentLat: $currentLat');
  print('currentLng: $currentLng');
  print('destinationLat: $destinationLat');
  print('destinationLng: $destinationLng');
  _openGoogleMapRouting(
    currentLat: currentLat,
    currentLng: currentLng,
    destinationLat: destLat,
    destinationLng: destLong,
    context: context,
  );
}
