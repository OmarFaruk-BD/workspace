// class TaskModel {
//   String? id;
//   String? title;
//   String? description;
//   String? priority;
//   String? taskType;
//   String? client;
//   String? amount;
//   String? dueDate;
//   String? comments;
//   String? attachments;
//   String? assignedTo;
//   String? status;
//   String? createdAt;
//   String? updatedAt;

//   TaskModel({
//     this.id,
//     this.title,
//     this.description,
//     this.priority,
//     this.taskType,
//     this.client,
//     this.amount,
//     this.dueDate,
//     this.comments,
//     this.attachments,
//     this.assignedTo,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//   });

//   TaskModel copyWith({
//     String? id,
//     String? title,
//     String? description,
//     String? priority,
//     String? taskType,
//     String? client,
//     String? amount,
//     String? dueDate,
//     String? comments,
//     String? attachments,
//     String? assignedTo,
//     String? status,
//     String? createdAt,
//     String? updatedAt,
//   }) {
//     return TaskModel(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       priority: priority ?? this.priority,
//       taskType: taskType ?? this.taskType,
//       client: client ?? this.client,
//       amount: amount ?? this.amount,
//       dueDate: dueDate ?? this.dueDate,
//       comments: comments ?? this.comments,
//       attachments: attachments ?? this.attachments,
//       assignedTo: assignedTo ?? this.assignedTo,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'title': title,
//       'description': description,
//       'priority': priority,
//       'taskType': taskType,
//       'client': client,
//       'amount': amount,
//       'dueDate': dueDate,
//       'comments': comments,
//       'attachments': attachments,
//       'assignedTo': assignedTo,
//       'status': status,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//     };
//   }

//   factory TaskModel.fromMap(Map<String, dynamic> map) {
//     return TaskModel(
//       id: map['taskId'] != null ? map['taskId'] as String : null,
//       title: map['title'] != null ? map['title'] as String : null,
//       description: map['description'] != null
//           ? map['description'] as String
//           : null,
//       priority: map['priority'] != null ? map['priority'] as String : null,
//       taskType: map['taskType'] != null ? map['taskType'] as String : null,
//       client: map['client'] != null ? map['client'] as String : null,
//       amount: map['amount'] != null ? map['amount'] as String : null,
//       dueDate: map['dueDate'] != null ? map['dueDate'] as String : null,
//       comments: map['comments'] != null ? map['comments'] as String : null,
//       attachments: map['attachments'] != null
//           ? map['attachments'] as String
//           : null,
//       assignedTo: map['assignedTo'] != null
//           ? map['assignedTo'] as String
//           : null,
//       status: map['status'] != null ? map['status'] as String : null,
//       createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
//       updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
//     );
//   }

//   @override
//   String toString() {
//     return 'TaskModel(id: $id, title: $title, description: $description, priority: $priority, taskType: $taskType, client: $client, amount: $amount, dueDate: $dueDate, comments: $comments, attachments: $attachments, assignedTo: $assignedTo, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
//   }

//   @override
//   bool operator ==(covariant TaskModel other) {
//     if (identical(this, other)) return true;

//     return other.id == id &&
//         other.title == title &&
//         other.description == description &&
//         other.priority == priority &&
//         other.taskType == taskType &&
//         other.client == client &&
//         other.amount == amount &&
//         other.dueDate == dueDate &&
//         other.comments == comments &&
//         other.attachments == attachments &&
//         other.assignedTo == assignedTo &&
//         other.status == status &&
//         other.createdAt == createdAt &&
//         other.updatedAt == updatedAt;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         title.hashCode ^
//         description.hashCode ^
//         priority.hashCode ^
//         taskType.hashCode ^
//         client.hashCode ^
//         amount.hashCode ^
//         dueDate.hashCode ^
//         comments.hashCode ^
//         attachments.hashCode ^
//         assignedTo.hashCode ^
//         status.hashCode ^
//         createdAt.hashCode ^
//         updatedAt.hashCode;
//   }
// }
