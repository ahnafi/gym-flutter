import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gym_app/app/data/models/gym_class.dart';
import 'package:gym_app/app/data/models/gym_class_detail.dart';
import 'package:gym_app/app/data/repositories/gym_class_repository.dart';

class GymClassInitial {}
class LoadGymClasses {}
class GymClassLoading {}
class LoadGymClassDetail {
  final int classId;
  LoadGymClassDetail(this.classId);
}
class GymClassError {
  final String message;
  GymClassError(this.message);
}
class GymClassesLoaded {
  final List<GymClass> gymClasses;
  GymClassesLoaded(this.gymClasses);
}
class GymClassDetailLoaded {
  final GymClassDetail classDetail;
  GymClassDetailLoaded(this.classDetail);
}

class GymClassBloc extends Bloc<Object, Object> {
  final GymclassRepository gymclassRepository;

  GymClassBloc({required this.gymclassRepository}) 
    : super(GymClassInitial()) {
      on<LoadGymClasses>(_onLoadGymClasses);
      on<LoadGymClassDetail>(_onLoadGymClassDetail);
  }

  Future<void> _onLoadGymClasses(
    LoadGymClasses event,
    Emitter<Object> emit,
  ) async {
    print('🔄 GymClassBloc: Loading gym classes...');
    emit(GymClassLoading());

    try {
      final classes = await gymclassRepository.getGymClasses();
      print('✅ GymClassBloc: Loaded ${classes.length} classes');
      emit(GymClassesLoaded(classes));
    } catch (e) {
      print('❌ GymClassBloc error: $e');
      emit(GymClassError(e.toString()));
    }
  }

  Future<void> _onLoadGymClassDetail(
    LoadGymClassDetail event,
    Emitter<Object> emit,
  ) async {
    print('🔄 GymClassBloc: Loading gym class detail for ID ${event.classId}...');
    emit(GymClassLoading());

    try {
      final classDetail = await gymclassRepository.getGymClassById(event.classId);
      print('✅ GymClassBloc: Loaded gym class detail: ${classDetail.name}');
      emit(GymClassDetailLoaded(classDetail));
    } catch (e) {
      print('❌ GymClassBloc error loading detail: $e');
      emit(GymClassError(e.toString()));
    }
  }

}