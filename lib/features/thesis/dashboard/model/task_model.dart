import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String taskId;
  final String amount;
  final String attachments;
  final String comments;
  final String dueDate;
  final String description;
  final String priority;
  final String title;
  final String assignedTo;
  final DateTime createdAt;
  final String taskType;
  final String client;
  final String status;
  final DateTime updatedAt;

  TaskModel({
    required this.taskId,
    required this.amount,
    required this.attachments,
    required this.comments,
    required this.dueDate,
    required this.description,
    required this.priority,
    required this.title,
    required this.assignedTo,
    required this.createdAt,
    required this.taskType,
    required this.client,
    required this.status,
    required this.updatedAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'] ?? '',
      amount:map['amount'] ?? '',
      attachments: map['attachments'] ?? '',
      comments: map['comments'] ?? '',
      dueDate: map['dueDate'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? '',
      title: map['title'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      taskType: map['taskType'] ?? '',
      client: map['client'] ?? '',
      status: map['status'] ?? '',
      updatedAt: (map['updatedAt'] is Timestamp)
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'amount': amount,
      'attachments': attachments,
      'comments': comments,
      'dueDate': dueDate,
      'description': description,
      'priority': priority,
      'title': title,
      'assignedTo': assignedTo,
      'createdAt': createdAt,
      'taskType': taskType,
      'client': client,
      'status': status,
      'updatedAt': updatedAt,
    };
  }
}
