

import 'package:flutter_project/model/virtualmachine_model.dart';
import 'package:flutter_project/service/virtualmachine_service.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  final eventService = VirtualmachineService();
final event = VirtualmachineModel(
      id: '1',
      name: 'máy 1',
      gpu: 'RTX 4060',
      cpu: 'i9-13900K',
      ram: '32GB DRR5',
      price: 1,
      description: 'No Content',
      status: 'No Users',
    );
  test('EventService có thể lưu và lấy sự kiện', () async {
     await eventService.saveEvent(event);
  
    // Lấy tất cả sự kiện
    final events = await eventService.getAllEvents();

    // Kiểm tra xem sự kiện có trong danh sách hay không
    expect(events.any((e) => e.cpu == 'i9-13900K'), true);

    // Xóa sự kiện
    await eventService.deleteEvent(event);

    // Kiểm tra xem sự kiện đã bị xóa
    final eventsAfterDelete = await eventService.getAllEvents();
    expect(eventsAfterDelete.any((e) => e.id == 'i9-13900K'), false);
  });
}
