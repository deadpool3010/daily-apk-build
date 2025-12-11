import 'package:bandhucare_new/localization/en_us/en_us_translation.dart';
import 'package:bandhucare_new/localization/gu_in/gu_in_translation.dart';
import 'package:bandhucare_new/localization/hi_in/hi_in_translation.dart';
import 'package:bandhucare_new/localization/ta_in/ta_in_translation.dart';
import 'package:bandhucare_new/localization/te_in/te_in_translation.dart';
import 'package:bandhucare_new/localization/ba_in/ba_in_translation.dart';
import 'package:get/get.dart';

class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUs,
    'en_us': enUs,
    'gu_IN': guIn,
    'gu_in': guIn,
    'hi_IN': hiIn,
    'hi_in': hiIn,
    'ta_IN': taIn,
    'ta_in': taIn,
    'te_IN': teIn,
    'te_in': teIn,
    'ba_IN': baIn,
    'ba_in': baIn,
  };
}
