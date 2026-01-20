class Snack {
  final int id;
  final String name;
  final String time;
  final int duration;
  final String objective;
  final List<Exercise> exercises;

  Snack({
    required this.id,
    required this.name,
    required this.time,
    required this.duration,
    required this.objective,
    required this.exercises,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'time': time,
    'duration': duration,
    'objective': objective,
    'exercises': exercises.map((e) => e.toJson()).toList(),
  };

  factory Snack.fromJson(Map<String, dynamic> json) => Snack(
    id: json['id'],
    name: json['name'],
    time: json['time'],
    duration: json['duration'],
    objective: json['objective'],
    exercises: (json['exercises'] as List).map((e) => Exercise.fromJson(e)).toList(),
  );
}

class Exercise {
  final String name;
  final int duration;
  final String description;
  final String initialPosition;
  final String movement;
  final String whatToFeel;
  final List<String> errorsToAvoid;
  final String? gifUrl;

  Exercise({
    required this.name,
    required this.duration,
    required this.description,
    required this.initialPosition,
    required this.movement,
    required this.whatToFeel,
    required this.errorsToAvoid,
    this.gifUrl,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'duration': duration,
    'description': description,
    'initialPosition': initialPosition,
    'movement': movement,
    'whatToFeel': whatToFeel,
    'errorsToAvoid': errorsToAvoid,
    if (gifUrl != null) 'gifUrl': gifUrl,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    name: json['name'],
    duration: json['duration'],
    description: json['description'],
    initialPosition: json['initialPosition'],
    movement: json['movement'],
    whatToFeel: json['whatToFeel'],
    errorsToAvoid: List<String>.from(json['errorsToAvoid'] ?? []),
    gifUrl: json['gifUrl'],
  );
}

class Session {
  final String id;
  final String userId;
  final DateTime date;
  final int snackNumber;
  final String snackName;
  final DateTime startTime;
  final DateTime? endTime;
  final bool completed;
  final String effortLevel;
  final int points;
  final String? notes;

  Session({
    required this.id,
    required this.userId,
    required this.date,
    required this.snackNumber,
    required this.snackName,
    required this.startTime,
    this.endTime,
    required this.completed,
    required this.effortLevel,
    required this.points,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'date': date.toIso8601String(),
    'snackNumber': snackNumber,
    'snackName': snackName,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'completed': completed,
    'effortLevel': effortLevel,
    'points': points,
    'notes': notes,
  };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    id: json['id'],
    userId: json['userId'],
    date: DateTime.parse(json['date']),
    snackNumber: json['snackNumber'],
    snackName: json['snackName'],
    startTime: DateTime.parse(json['startTime']),
    endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
    completed: json['completed'],
    effortLevel: json['effortLevel'],
    points: json['points'],
    notes: json['notes'],
  );
}
