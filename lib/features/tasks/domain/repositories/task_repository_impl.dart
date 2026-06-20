import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../data/models/task_model.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final http.Client client;

  TaskRepositoryImpl({required this.client});

  @override
  Future<List<TaskEntity>> getTasks() async {
    final response = await client.get(Uri.parse('${ApiConstants.baseUrl}/tasks'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat tasks');
    }
  }

  @override
  Future<TaskEntity> addTask(String title, String description) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'description': description}),
    );
    if (response.statusCode == 201) {
      return TaskModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal menambah task');
    }
  }

  @override
  Future<void> updateTaskStatus(int id, String status) async {
    final response = await client.patch(
      Uri.parse('${ApiConstants.baseUrl}/tasks/$id/status'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': status}),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal mengubah status');
    }
  }
}