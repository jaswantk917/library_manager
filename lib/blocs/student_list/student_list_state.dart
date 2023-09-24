// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'student_list_bloc.dart';

enum StudentListLoadingStatus {
  initial,
  loadingList,
  error,
  loadedList,
  addingStduent,
  addedStudent,
}

class StudentListState extends Equatable {
  final List<Student> students;
  final CustomError error;
  final StudentListLoadingStatus status;
  const StudentListState({
    required this.students,
    required this.status,
    required this.error,
  });

  factory StudentListState.initial() => const StudentListState(
      students: [],
      status: StudentListLoadingStatus.initial,
      error: CustomError());

  @override
  List<Object> get props => [students, error, status];

  StudentListState copyWith({
    List<Student>? students,
    CustomError? error,
    StudentListLoadingStatus? status,
  }) {
    return StudentListState(
      students: students ?? this.students,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  bool get stringify => true;
}
