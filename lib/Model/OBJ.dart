class OBJ {
  final String objUrl;
  final String objName;
  final double objPrice;
  final int objCount;
  final String objSize;
  final double objMass;

  OBJ({
    required this.objUrl,
    required this.objName,
    required this.objPrice,
    required this.objCount,
    required this.objSize,
    required this.objMass,
  });

  Map<String, dynamic> toMap() {
    return {
      'objUrl': objUrl,
      'objName': objName,
      'objPrice': objPrice,
      'objCount': objCount,
      'objSize': objSize,
      'objMass': objMass,
    };
  }

  static OBJ fromMap(Map<String, dynamic> map) {
    return OBJ(
      objUrl: map['objUrl'],
      objName: map['objName'],
      objPrice: map['objPrice'],
      objCount: map['objCount'],
      objSize: map['objSize'],
      objMass: map['objMass'],
    );
  }

}