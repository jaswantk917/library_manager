// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'student_list_bloc.dart';

enum StudentListLoadingStatus {
  initial,
  loadingList,
  error,
  loadedList,
  refreshing,
}

enum StudentAddingStatus {
  initial,
  added,
  error,
  addding,
}

class StudentListState extends Equatable {
  final List<Student> students;
  final CustomError error;
  final StudentListLoadingStatus status;
  final StudentAddingStatus addStatus;
  const StudentListState({
    required this.students,
    required this.error,
    required this.status,
    required this.addStatus,
  });

  factory StudentListState.initial() => const StudentListState(
        students: [],
        status: StudentListLoadingStatus.initial,
        error: CustomError(),
        addStatus: StudentAddingStatus.initial,
      );

  @override
  List<Object> get props => [students, error, status, addStatus];

  StudentListState copyWith({
    List<Student>? students,
    CustomError? error,
    StudentListLoadingStatus? status,
    StudentAddingStatus? addStatus,
  }) {
    return StudentListState(
      students: students ?? this.students,
      error: error ?? this.error,
      status: status ?? this.status,
      addStatus: addStatus ?? this.addStatus,
    );
  }

  @override
  bool get stringify => true;
}
