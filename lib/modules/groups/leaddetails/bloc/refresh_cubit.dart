
import 'package:bloc/bloc.dart';
import 'package:mal/modules/groups/leaddetails/bloc/bloc.dart';
import 'package:uuid/uuid.dart';

class RefreshCubit extends Cubit<RefreshState>{
  RefreshCubit(this.uuid) : super(RefreshState(uuid.v4()));
  final Uuid uuid;
  void refresh(){
    emit(RefreshState(uuid.v4()));
  }
}