// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'student_list_bloc.dart';

sealed class StudentListEvent extends Equatable {
  const StudentListEvent();

  @override
  List<Object> get props => [];
}

class LoadListFirstTimeEvent extends StudentListEvent {}

class RefreshListEvent extends StudentListEvent {}

class AddStudentEvent extends StudentListEvent {
  final Student student;
  const AddStudentEvent({
    required this.student,
  });

  @override
  List<Object> get props => [student];

  @override
  String toString() => 'AddStudentEvent(student: $student)';
}

class AddStudentEventInitial extends StudentListEvent {}
// class GetStudentByIdEvent extends StudentListEvent {
//   final String id;
//   const GetStudentByIdEvent({
//     required this.id,
//   });

//   @override
//   List<Object> get props => [id];

//   @override
//   String toString() => 'GetStudentByIdEvent(id: $id)';
// }
