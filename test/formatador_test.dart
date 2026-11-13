import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/util/formatador.dart';

void main() {
  group('Formatador', () {
    test('dataBr converte ISO para brasileiro', () {
      expect(Formatador.dataBr('2019-03-12'), '12/03/2019');
    });

    test('dataBr mantem valor ja brasileiro', () {
      expect(Formatador.dataBr('12/03/2019'), '12/03/2019');
    });

    test('dataBr devolve valor invalido sem alteracao', () {
      expect(Formatador.dataBr('abc'), 'abc');
    });

    test('dataIso converte brasileiro para ISO', () {
      expect(Formatador.dataIso('12/03/2019'), '2019-03-12');
    });

    test('dataIso mantem ISO', () {
      expect(Formatador.dataIso('2019-03-12'), '2019-03-12');
    });

    test('dataValida aceita dd/MM/yyyy', () {
      expect(Formatador.dataValida('12/03/2019'), isTrue);
    });

    test('dataValida aceita AAAA-MM-DD (legado)', () {
      expect(Formatador.dataValida('2019-03-12'), isTrue);
    });

    test('dataValida rejeita data invalida', () {
      expect(Formatador.dataValida('2019-13-40'), isFalse);
      expect(Formatador.dataValida('32/01/2019'), isFalse);
    });

    test('paraDateTime aceita brasileiro', () {
      expect(Formatador.paraDateTime('12/03/2019'), DateTime(2019, 3, 12));
    });

    test('dataHoraBr converte timestamp ISO', () {
      expect(Formatador.dataHoraBr('2026-11-12T22:52:19'), '12/11/2026 22:52');
    });
  });
}
