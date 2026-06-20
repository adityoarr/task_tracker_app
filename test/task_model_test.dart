import 'package:flutter_test/flutter_test.dart';
import 'package:task_tracker_app/features/tasks/data/models/task_model.dart';

void main() {
  test('TaskModel.fromJson harus mengembalikan objek yang valid', () {
    // Arrange
    final Map<String, dynamic> jsonMap = {
      'id': 1,
      'title': 'Test Title',
      'description': 'Test Desc',
      'status': 'Pending'
    };

    // Act
    final result = TaskModel.fromJson(jsonMap);

    // Assert
    expect(result.id, 1);
    expect(result.title, 'Test Title');
    expect(result.status, 'Pending');
  });
}