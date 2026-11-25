import 'package:flutter_test/flutter_test.dart';
import 'package:uyg_agirlik_antrenmani_gunlugu/uyg_agirlik_antrenmani_gunlugu.dart';

void main() {
  test('33 dilde ad ve açıklama, doğru kimlik', () {
    expect(agirlikAntrenmaniGunluguTool.id, agirlikAntrenmaniGunluguId);
    expect(agirlikAntrenmaniGunluguTool.title.length, 33);
    expect(agirlikAntrenmaniGunluguTool.tagline.length, 33);
  });
}
