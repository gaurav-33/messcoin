import 'package:hive/hive.dart';
import '../../core/models/student_model.dart';
import '../../core/storage/hive_boxes.dart';

class StudentBoxManager {
  static const String studentBox = HiveBoxes.studentBox;

  static Future<void> saveStudent(StudentModel student) async {
    final box = Hive.box<StudentModel>(studentBox);
    await box.put('student', student);
  }

  static Future<StudentModel?> getStudent() async {
    final box = Hive.box<StudentModel>(studentBox);
    return box.get('student');
  }

  static Future<void> clearStudent() async {
    final box = Hive.box<StudentModel>(studentBox);
    await box.delete('student');
  }
}
