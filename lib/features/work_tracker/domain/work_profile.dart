class WorkProfile {
  const WorkProfile({
    required this.companyName,
    required this.jobTitle,
    required this.employmentType,
    required this.joiningDate,
    required this.workLocation,
    required this.shiftType,
    this.notes = '',
  });

  final String companyName;
  final String jobTitle;
  final String employmentType;
  final String joiningDate;
  final String workLocation;
  final String shiftType;
  final String notes;

  factory WorkProfile.empty() => const WorkProfile(
        companyName: '',
        jobTitle: '',
        employmentType: '',
        joiningDate: '',
        workLocation: '',
        shiftType: '',
        notes: '',
      );

  WorkProfile copyWith({
    String? companyName,
    String? jobTitle,
    String? employmentType,
    String? joiningDate,
    String? workLocation,
    String? shiftType,
    String? notes,
  }) {
    return WorkProfile(
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      employmentType: employmentType ?? this.employmentType,
      joiningDate: joiningDate ?? this.joiningDate,
      workLocation: workLocation ?? this.workLocation,
      shiftType: shiftType ?? this.shiftType,
      notes: notes ?? this.notes,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'companyName': companyName,
      'jobTitle': jobTitle,
      'employmentType': employmentType,
      'joiningDate': joiningDate,
      'workLocation': workLocation,
      'shiftType': shiftType,
      'notes': notes,
    };
  }

  factory WorkProfile.fromJson(Map<String, Object?> json) {
    return WorkProfile(
      companyName: json['companyName'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      employmentType: json['employmentType'] as String? ?? '',
      joiningDate: json['joiningDate'] as String? ?? '',
      workLocation: json['workLocation'] as String? ?? '',
      shiftType: json['shiftType'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
    );
  }
}
