import 'package:flutter_test/flutter_test.dart';
import 'package:vent_game/feature/home/provider/HomePageProvider.dart';

void main() {
  late HomePageProvider provider;

  setUp(() {
    provider = HomePageProvider();
  });

  group('homePageProviderShould', () {
    test('sum correctly', () {
      expect(provider.sum(1, 2), 3);
    });
  });
}
