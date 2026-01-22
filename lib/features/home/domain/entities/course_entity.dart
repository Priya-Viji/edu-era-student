import 'package:cloud_firestore/cloud_firestore.dart';

class CourseEntity {
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
  final String thumbnailUrl;
  final List<Lesson> lessons;
  final String status;
  final int studentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isBookmarked;


  CourseEntity({
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
    required this.thumbnailUrl,
    required this.lessons,
    required this.status,
    required this.studentCount,
    required this.createdAt,
    required this.updatedAt,
    this.isBookmarked = false,
  });

  factory CourseEntity.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
      if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.now();
    }

    return CourseEntity(
      id: json["id"] ?? "",
      mentorId: json["mentorId"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      category: json["category"] ?? "",
      level: json["level"] ?? "",
      language: json["language"] ?? "",
      price: (json["price"] ?? 0).toDouble(),
      rating: (json["rating"] ?? 0).toDouble(),
      isFree: json["isFree"] ?? false,
      thumbnailUrl: json["thumbnailUrl"],
      status: json["status"] ?? "draft",
      studentCount: json["studentCount"] ?? 0,
      createdAt: parseDate(json["createdAt"]),
      updatedAt: parseDate(json["updatedAt"]),
      lessons: (json["lessons"] as List? ?? [])
          .map((l) => Lesson.fromJson(l))
          .toList(),
      isBookmarked: json["isBookmarked"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
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
    "studentCount": studentCount,
    "createdAt": Timestamp.fromDate(createdAt),
    "updatedAt": Timestamp.fromDate(updatedAt),
    "lessons": lessons.map((l) => l.toJson()).toList(),
    "isBookmarked": isBookmarked,
  };
}

class Lesson {
  final String title;
  final List<SubLesson> subLessons;

  Lesson({required this.title, required this.subLessons});

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json["title"] ?? "",
      subLessons: (json["subLessons"] as List? ?? [])
          .map((s) => SubLesson.fromJson(s))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "subLessons": subLessons.map((s) => s.toJson()).toList(),
  };

  void operator [](String other) {}
}

class SubLesson {
  final String title;
  final String youtubeLink;
  final int duration;

  SubLesson({required this.title, required this.youtubeLink, required this.duration});

  factory SubLesson.fromJson(Map<String, dynamic> json) {
    return SubLesson(
      title: json["title"] ?? "",
      youtubeLink: json["youtubeLink"] ?? "",
      duration: json["duration"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {"title": title, "youtubeLink": youtubeLink};
}
