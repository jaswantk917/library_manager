import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:library_management/models/custom_error.dart';
import 'package:library_management/models/student_model.dart';
import 'package:library_management/repositories/student_list_repository.dart';

part 'student_list_event.dart';
part 'student_list_state.dart';

class StudentListBloc extends Bloc<StudentListEvent, StudentListState> {
  final StudentRepository _studentRepository;
  StudentListBloc({required StudentRepository studentRepository})
      : _studentRepository = studentRepository,
        super(StudentListState.initial()) {
    on<LoadStudentEvent>((event, emit) async {
      emit(state.copyWith(status: StudentListLoadingStatus.loadingList));
      try {
        List<Student> students = await _studentRepository.fetchStudentList();
        emit(state.copyWith(
          status: StudentListLoadingStatus.loadedList,
          students: students,
        ));
      } catch (e) {
        emit(state.copyWith(
          error: CustomError(message: e.toString()),
          status: StudentListLoadingStatus.error,
        ));
      }
    });
    on<AddStudentEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: StudentListLoadingStatus.addingStduent,
          ),
        );
        try {
          await _studentRepository.addStudent(event.student);
        } catch (e) {
          emit(state.copyWith(
            error: CustomError(message: e.toString()),
            status: StudentListLoadingStatus.error,
          ));
        }
        List<Student> students = state.students;
        students.add(event.student);
        emit(state.copyWith(
          students: students,
          status: StudentListLoadingStatus.addedStudent,
        ));
      },
    );
  }
}
