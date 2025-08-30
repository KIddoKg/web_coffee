enum FlavorType {
  dev('dev'),
  prod('prod');

  bool get isDev => this == dev;

  bool get isProd => this == prod;

  final String value;

  const FlavorType(this.value);
}

abstract class Flavor {
  static FlavorType _flavorType = FlavorType.dev;

  static FlavorType get flavorType => _flavorType;

  static void setFlavor(FlavorType flavor) {
    _flavorType = flavor;
  }
}
