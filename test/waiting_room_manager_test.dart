import 'package:flutter_test/flutter_test.dart';
import 'package:waiting_room_app/queue_provider.dart';

void main() {
  test('should add a client to the waiting list', () {
    // ARRANGE: Set up the necessary objects and variables.
    final manager = QueueProvider();

    // ACT: Call the method you want to test.
    manager.addClient('Ahmed haddad');

    // ASSERT: Verify that the result is what you expect.
    expect(manager.clients.length, 1);
    expect(manager.clients.first, 'Ahmed haddad');
  });

  test('should remove a client from the waiting list', () {
    // ARRANGE
    final manager = QueueProvider();
    manager.addClient('Client 1');
    manager.addClient('Client 2');

    // ACT
    manager.removeClient('Client 1');

    // ASSERT
    expect(manager.clients.length, 1);
    expect(manager.clients.first, 'Client 2');
  });

  test('should remove the first client when nextClient() is called', () {
    // ARRANGE
    final manager = QueueProvider();
    manager.addClient('Client 1');
    manager.addClient('Client 2');
    // ACT
    manager.nextClient();
    // ASSERT
    expect(manager.clients.length, 1);
    expect(manager.clients.first, 'Client 2');
  });
}
