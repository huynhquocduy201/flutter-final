import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VirtualmachineModel Tests', () {
    test('VirtualmachineModel instantiation', () {
      final event = VirtualmachineModel(
          id: '1',
          name: 'máy 1',
          gpu: 'RTX 4060',
          cpu: 'i9-13900K',
          ram: '32GB DRR5',
          price: 0.59,
          description: 'No Content',
          status: 'No Users'
          );

      expect(event.id, '1');
      expect(event.name, 'máy 1');
      expect(event.gpu, 'RTX 4060');
      expect(event.cpu, 'i9-13900K');
      expect(event.ram, '32GB DRR5');
      expect(event.price, 0.59);
      expect(event.description, 'No Content');
      expect(event.status, 'No Users');
    });
test('VirtualmachineModel toMap and fromMap', () {
      final event = VirtualmachineModel(
          id: '1',
          name: 'máy 1',
          gpu: 'RTX 4060',
          cpu: 'i9-13900K ',
          ram: '32GB DRR5',
          price: 0.59,
          description: 'No Content',
          status: 'No Users');

      final map = event.toMap();
      final newevent = VirtualmachineModel.fromMap(map);

      expect(newevent, equals(event));
    });

    test('VirtualmachineModel toJson and fromJson', () {
      final event = VirtualmachineModel(
          id: '1',
          name: 'máy 1',
          gpu: 'RTX 4060',
          cpu: 'i9-13900K ',
          ram: '32GB DRR5',
          price: 0.59,
          description: 'No Content',
          status: 'No Users');

      final jsonStr = event.toJsonofMap();
      final newevent = VirtualmachineModel.fromJsonofMap(jsonStr);

      expect(newevent, equals(event));
    });
  

    test('VirtualmachineModel copyWith', () {
      final event = VirtualmachineModel(
          id: '1',
          name: 'máy 1',
          gpu: 'RTX 4060',
          cpu: 'i9-13900K ',
          ram: '32GB DRR5',
          price: 0.59,
          description: 'No Content',
          status: 'No Users');

      final updatedevent = event.copyWith(
        gpu: 'RTX 3060',
        cpu: 'i8-13900K',
        ram: '16GB DRR5',
      );

      expect(updatedevent.id, '1');
      expect(updatedevent.name, 'máy 1');
      expect(updatedevent.gpu, 'RTX 3060');
      expect(updatedevent.cpu, 'i8-13900K');
      expect(updatedevent.ram, '16GB DRR5');
      expect(updatedevent.price, 0.59);
      expect(updatedevent.description, 'No Content');
      expect(updatedevent.status, 'No Users');
    });
  });
}
