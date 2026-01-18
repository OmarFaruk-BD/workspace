class NotificationModel {
  final String? id;
  final String? comments;
  final String? title;
  final String? content;
  final String? priority;
  final String? createdAt;

  NotificationModel({
    this.id,
    this.comments,
    this.title,
    this.content,
    this.priority,
    this.createdAt,
  });

  NotificationModel copyWith({
    String? id,
    String? comments,
    String? title,
    String? content,
    String? priority,
    String? createdAt,
  }) => NotificationModel(
    id: id ?? this.id,
    comments: comments ?? this.comments,
    title: title ?? this.title,
    content: content ?? this.content,
    priority: priority ?? this.priority,
    createdAt: createdAt ?? this.createdAt,
  );
}

class NotificationModelV2 {
  final String? id;
  final String? date;
  final String? title;
  final String? content;
  final String? comments;
  final String? priority;
  final String? userName;
  final String? createdAt;
  final String? assignedTo;

  NotificationModelV2({
    this.id,
    this.date,
    this.title,
    this.content,
    this.comments,
    this.priority,
    this.userName,
    this.createdAt,
    this.assignedTo,
  });

  NotificationModelV2 copyWith({
    String? id,
    String? date,
    String? title,
    String? content,
    String? comments,
    String? priority,
    String? userName,
    String? createdAt,
    String? assignedTo,
  }) => NotificationModelV2(
    id: id ?? this.id,
    date: date ?? this.date,
    title: title ?? this.title,
    content: content ?? this.content,
    userName: userName ?? this.userName,
    comments: comments ?? this.comments,
    priority: priority ?? this.priority,
    createdAt: createdAt ?? this.createdAt,
    assignedTo: assignedTo ?? this.assignedTo,
  );
}
