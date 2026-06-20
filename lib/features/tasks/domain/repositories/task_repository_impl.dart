import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../data/models/task_model.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  final http.Client client;
  static const String _cacheKey = 'CACHED_TASKS';

  TaskRepositoryImpl({required this.client});

  @override
  Future<List<TaskEntity>> getTasks({int page = 1, int limit = 10}) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final response = await client.get(
          Uri.parse('${ApiConstants.baseUrl}/tasks?page=$page&limit=$limit')
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        final tasks = data.map((json) => TaskModel.fromJson(json)).toList();

        if (page == 1) {
          prefs.setString(_cacheKey, response.body);
        }

        return tasks;
      } else {
        throw Exception('Server error');
      }
    } catch (e) {
      final cachedStr = prefs.getString(_cacheKey);
      if (cachedStr != null && page == 1) {
        final List data = json.decode(cachedStr);
        return data.map((json) => TaskModel.fromJson(json)).toList();
      }
      throw Exception('Gagal memuat data dan tidak ada cache lokal.');
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