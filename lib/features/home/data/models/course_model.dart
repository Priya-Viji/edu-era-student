import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/course_entity.dart';

class CourseModel {
  final String id;
  final String mentorId;
  final String title;
  final String description;
  final String category;
  final String level;
  final String language;
  final double price;
  final double? rating;
  final bool isFree;
  final String? thumbnailUrl;
  final List<LessonModel> lessons;
  final String status;
  final int studentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
final bool isBookmarked;

  CourseModel({
    required this.id,
    required this.mentorId,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.language,
    required this.price,
    required this.rating,
    required this.isFree,
    this.thumbnailUrl,
    required this.lessons,
    required this.status,
    required this.studentCount,
    required this.createdAt,
    required this.updatedAt,
    this.isBookmarked = false,
  });

  /// -----------------------------
  /// COPYWITH (needed for avg rating)
  /// -----------------------------
  CourseModel copyWith({
    String? id,
    String? mentorId,
    String? title,
    String? description,
    String? category,
    String? level,
    String? language,
    double? price,
    double? rating,
    bool? isFree,
    String? thumbnailUrl,
    List<LessonModel>? lessons,
    String? status,
    int? studentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isBookmarked,
  }) {
    return CourseModel(
      id: id ?? this.id,
      mentorId: mentorId ?? this.mentorId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      level: level ?? this.level,
      language: language ?? this.language,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      isFree: isFree ?? this.isFree,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      lessons: lessons ?? this.lessons,
      status: status ?? this.status,
      studentCount: studentCount ?? this.studentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  /// -----------------------------
  /// Firestore → Model
  /// -----------------------------
  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      mentorId: data['mentorId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      level: data['level'] ?? '',
      language: data['language'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      isFree: data['isFree'] ?? false,
      thumbnailUrl: data['thumbnailUrl'],
      lessons: (data['lessons'] as List? ?? [])
          .map((l) => LessonModel.fromJson(l as Map<String, dynamic>))
          .toList(),
      status: data['status'] ?? 'draft',
      studentCount: data['studentCount'] ?? 0,
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
      isBookmarked: data['isBookmarked'] ?? false,
    );
  }

  static DateTime _parseDate(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
    return DateTime.now();
  }

  /// -----------------------------
  /// Model → Map
  /// -----------------------------
  Map<String, dynamic> toMap() => {
    "id": id,
    "mentorId": mentorId,
    "title": title,
    "description": description,
    "category": category,
    "level": level,
    "language": language,
    "price": price,
    "rating": rating,
    "isFree": isFree,
    "thumbnailUrl": thumbnailUrl,
    "status": status,
    'studentCount': studentCount,
    "createdAt": Timestamp.fromDate(createdAt),
    "updatedAt": Timestamp.fromDate(updatedAt),
    "lessons": lessons.map((l) => l.toJson()).toList(),
    "isBookmarked": isBookmarked,
  };

  /// -----------------------------
  /// Model → Entity
  /// -----------------------------
  CourseEntity toEntity() {
    return CourseEntity(
      id: id,
      mentorId: mentorId,
      title: title,
      description: description,
      category: category,
      level: level,
      language: language,
      price: price,
      rating: rating,
      isFree: isFree,
      thumbnailUrl: thumbnailUrl ?? "",
      lessons: lessons.map((l) => l.toEntity()).toList(),
      status: status,
      studentCount: studentCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isBookmarked: isBookmarked,
    );
  }
}

/// -----------------------------
/// LESSON MODEL
/// -----------------------------
class LessonModel {
  final String title;
  final List<SubLessonModel> subLessons;

  LessonModel({required this.title, required this.subLessons});

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      title: json["title"] ?? "",
      subLessons: (json["subLessons"] as List? ?? [])
          .map((s) => SubLessonModel.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "subLessons": subLessons.map((s) => s.toJson()).toList(),
  };

  Lesson toEntity() {
    return Lesson(
      title: title,
      subLessons: subLessons.map((s) => s.toEntity()).toList(),
    );
  }
}

/// -----------------------------
/// SUBLESSON MODEL
/// -----------------------------
class SubLessonModel {
  final String title;
  final String youtubeLink;
  final int duration;

  SubLessonModel({
    required this.title,
    required this.youtubeLink,
    required this.duration,
  });

  factory SubLessonModel.fromJson(Map<String, dynamic> json) {
    return SubLessonModel(
      title: json["title"] ?? "",
      youtubeLink: json["youtubeLink"] ?? "",
      duration: json["duration"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "youtubeLink": youtubeLink,
    "duration": duration,
  };

  SubLesson toEntity() {
    return SubLesson(
      title: title,
      youtubeLink: youtubeLink,
      duration: duration,
    );
  }
}
