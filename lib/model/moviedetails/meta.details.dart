class Meta {
  int? apiVersion;
  String? executionTime;

  Meta({this.apiVersion, this.executionTime});

  factory Meta.fromMap(Map<String, dynamic> map) {
    return Meta(
      apiVersion: map['server_time'] as int?, // أو حسب الكي القادم من الـ API
      executionTime: map['execution_time'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'server_time': apiVersion,
      'execution_time': executionTime,
    };
  }
}