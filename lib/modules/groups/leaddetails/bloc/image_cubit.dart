
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/modules/groups/leads/bloc/leads_state.dart';

class ImageCubit extends Cubit<ChangedImageState>{
  ImageCubit() : super(ChangedImageState(null, null));

  void changeImage(String? firstName, String? lastName){
    emit(ChangedImageState(firstName??state.firstName, lastName??state.lastName));
  }

}