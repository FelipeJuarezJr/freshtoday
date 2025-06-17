import 'package:flutter/foundation.dart';
import '../../core/models/sobriety_tracking_model.dart';
import '../../core/models/achievement_model.dart';
import '../../core/services/sobriety_service.dart';

class SobrietyProvider with ChangeNotifier {
  final SobrietyService _sobrietyService;
  SobrietyTrackingModel? _sobrietyStatus;
  List<MilestoneModel> _milestones = [];
  bool _isLoading = false;
  String? _error;

  SobrietyProvider(this._sobrietyService) {
    _initialize();
  }

  SobrietyTrackingModel? get sobrietyStatus => _sobrietyStatus;
  List<MilestoneModel> get milestones => _milestones;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _initialize() async {
    try {
      _isLoading = true;
      notifyListeners();

      _sobrietyStatus = await _sobrietyService.getSobrietyStatus();
      _milestones = _sobrietyService.getMilestones();

      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> startJourney() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _sobrietyService.startSobrietyJourney();
      await _initialize();

      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  Future<void> checkIn(CheckIn checkIn) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _sobrietyService.checkIn(checkIn);
      await _initialize();

      _isLoading = false;
      _error = null;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 