import 'package:bandhucare_new/general_widget_&_classes/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildAbhaSection() {
  return Container(
    width: 360,
    height: 125,
    decoration: BoxDecoration(
      color: Color.fromRGBO(237, 242, 247, 1.0),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ABHA ID",
                  style: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Your Personal Identification",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 10),
                DynamicButton(
                  text: "Create Another",
                  width: 129,
                  height: 35,
                  onPressed: () {},
                  fontSize: 14,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: buildCardFront(width: 150, height: 90),
          ),
        ],
      ),
    ),
  );
}

Widget buildCardFront({double width = 360, double height = 198}) {
  final scaleFactorW = width / 360;
  final scaleFactorH = height / 198;
  final scaleFactor = (scaleFactorW + scaleFactorH) / 2;

  return SizedBox(
    width: width,
    height: height,
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24 * scaleFactor),
          child: Image.asset(
            'assets/blank_abha.png',
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20 * scaleFactorW,
              right: 20 * scaleFactorW,
              top: 75 * scaleFactorH,
              bottom: 16 * scaleFactorH,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Added to prevent overflow
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 62 * scaleFactorW,
                      height: 64 * scaleFactorH,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12 * scaleFactor),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 40 * scaleFactor,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 12 * scaleFactorW),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, // Added
                        children: [
                          RichText(
                            overflow: TextOverflow.ellipsis, // Added
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Name: ',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 12 * scaleFactor,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text: 'Siddharth',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 12 * scaleFactor,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6 * scaleFactorH),
                          RichText(
                            overflow: TextOverflow.ellipsis, // Added
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Abha No: ',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11 * scaleFactor,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text: '91 1234 5678 9101',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11 * scaleFactor,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6 * scaleFactorH),
                          RichText(
                            overflow: TextOverflow.ellipsis, // Added
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Abha Address: ',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11 * scaleFactor,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sid2000@abdm',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 11 * scaleFactor,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 45 * scaleFactorW,
                      height: 45 * scaleFactorH,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8 * scaleFactor),
                      ),
                      child: Icon(
                        Icons.qr_code,
                        size: 35 * scaleFactor,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Flexible(
                      // Added to prevent overflow
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Gender: ',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11 * scaleFactor,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: 'Male',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11 * scaleFactor,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 13 * scaleFactorW),
                    Flexible(
                      // Added
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'DOB: ',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11 * scaleFactor,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: '03032004',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11 * scaleFactor,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 13 * scaleFactorW),
                    Flexible(
                      // Added
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Mobile: ',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11 * scaleFactor,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: '1234567891',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 11 * scaleFactor,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
