import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicPortalFlowState {
  const PublicPortalFlowState({
    this.campus,
    this.department,
    this.period,
    this.portal,
  });

  final String? campus;
  final String? department;
  final String? period;
  final String? portal;

  bool get hasCampus => campus != null && campus!.isNotEmpty;
  bool get hasDepartment => department != null && department!.isNotEmpty;
  bool get hasPeriod => period != null && period!.isNotEmpty;
  bool get hasPortal => portal != null && portal!.isNotEmpty;

  PublicPortalFlowState copyWith({
    String? campus,
    String? department,
    String? period,
    String? portal,
    bool clearDepartment = false,
    bool clearPeriod = false,
    bool clearPortal = false,
  }) {
    return PublicPortalFlowState(
      campus: campus ?? this.campus,
      department: clearDepartment ? null : (department ?? this.department),
      period: clearPeriod ? null : (period ?? this.period),
      portal: clearPortal ? null : (portal ?? this.portal),
    );
  }
}

class PublicPortalFlowController extends Notifier<PublicPortalFlowState> {
  @override
  PublicPortalFlowState build() => const PublicPortalFlowState();

  void selectCampus(String campus) {
    state = state.copyWith(
      campus: campus,
      clearDepartment: true,
      clearPeriod: true,
      clearPortal: true,
    );
  }

  void selectDepartment(String department) {
    state = state.copyWith(
      department: department,
      clearPeriod: true,
      clearPortal: true,
    );
  }

  void selectPeriod(String period) {
    state = state.copyWith(
      period: period,
      clearPortal: true,
    );
  }

  void selectPortal(String portal) {
    state = state.copyWith(portal: portal);
  }

  void reset() => state = const PublicPortalFlowState();
}

final publicPortalFlowControllerProvider =
    NotifierProvider<PublicPortalFlowController, PublicPortalFlowState>(
  PublicPortalFlowController.new,
);

