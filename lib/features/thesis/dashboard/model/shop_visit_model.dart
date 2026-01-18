import 'package:workspace/features/thesis/dashboard/model/task_model.dart';

class ShopVisitModel {
  final String? id;
  final String? svTitle;
  final String? svDescription;
  final String? svDate;
  final String? svClient;
  final String? svAmount;
  final String? svAttachment;
  final String? svType;
  final String? svTaskId;
  final TaskModel? task;
  ShopVisitModel({
    this.id,
    this.svTitle,
    this.svDescription,
    this.svDate,
    this.svClient,
    this.svAmount,
    this.svAttachment,
    this.svType,
    this.svTaskId,
    this.task,
  });

  ShopVisitModel copyWith({
    String? id,
    String? svTitle,
    String? svDescription,
    String? svDate,
    String? svClient,
    String? svAmount,
    String? svAttachment,
    String? svType,
    String? svTaskId,
    TaskModel? task,
  }) {
    return ShopVisitModel(
      id: id ?? this.id,
      svTitle: svTitle ?? this.svTitle,
      svDescription: svDescription ?? this.svDescription,
      svDate: svDate ?? this.svDate,
      svClient: svClient ?? this.svClient,
      svAmount: svAmount ?? this.svAmount,
      svAttachment: svAttachment ?? this.svAttachment,
      svType: svType ?? this.svType,
      svTaskId: svTaskId ?? this.svTaskId,
      task: task ?? this.task,
    );
  }

  factory ShopVisitModel.fromMap(Map<String, dynamic> map) {
    TaskModel task = TaskModel.fromMap(map);
    return ShopVisitModel(
      id: map['id'] as String,
      svTitle: map['svTitle'] as String,
      svDescription: map['svDescription'] as String,
      svDate: map['svDate'] as String,
      svClient: map['svClient'] as String,
      svAmount: map['svAmount'] as String,
      svAttachment: map['svAttachment'] as String,
      svType: map['svType'] as String,
      svTaskId: map['svTaskId'] as String,
      task: task,
    );
  }

  @override
  String toString() {
    return 'ShopVisitModel(svTitle: $svTitle, svDescription: $svDescription, svDate: $svDate, svClient: $svClient, svAmount: $svAmount, compressedBytes: $svAttachment, svType: $svType, svTaskId: $svTaskId, task: $task)';
  }

  @override
  bool operator ==(covariant ShopVisitModel other) {
    if (identical(this, other)) return true;

    return other.svTitle == svTitle &&
        other.svDescription == svDescription &&
        other.svDate == svDate &&
        other.svClient == svClient &&
        other.svAmount == svAmount &&
        other.svAttachment == svAttachment &&
        other.svType == svType &&
        other.svTaskId == svTaskId &&
        other.task == task;
  }

  @override
  int get hashCode {
    return svTitle.hashCode ^
        svDescription.hashCode ^
        svDate.hashCode ^
        svClient.hashCode ^
        svAmount.hashCode ^
        svAttachment.hashCode ^
        svType.hashCode ^
        svTaskId.hashCode ^
        task.hashCode;
  }
}
