import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());


  Future<void> registerUser ({required String email , required String password}) async {
    emit(RegisterLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      emit(RegisterSuccess());
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'weak-password'){
        emit(RegisterFailure(errMessage: 'weak-password'));
      }else if (ex.code == 'email-alredy-in-use'){
        emit(RegisterFailure(errMessage: 'email-alredy-in-use'));
      }
    } catch (e){
      emit(RegisterFailure(errMessage: 'there was an error please try again'));
    }
  }
}
