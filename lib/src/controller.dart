import 'package:flutter/foundation.dart';

class ViewerConfig {
  final String? focusedAyahId;
  ViewerConfig({this.focusedAyahId});
}
class ViewerController extends ValueNotifier<ViewerConfig> {
  ViewerController(super.value);

  void focusOnAyah(String ayahId) {
    value = ViewerConfig(focusedAyahId: ayahId);
    notifyListeners();
  }
  void removeAyahFocus() {
    value = ViewerConfig(focusedAyahId: null);
    notifyListeners();
  }

}