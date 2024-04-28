
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/modules/groups/leads/bloc/leads_state.dart';

class BirthdayCubit extends Cubit<ChangedBirthdayState>{
  BirthdayCubit() : super(ChangedBirthdayState(null, ));

  void changeBirthday(String? birthday, ){
    emit(ChangedBirthdayState(birthday));
  }

}