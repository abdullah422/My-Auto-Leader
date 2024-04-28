// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mal/responses/message_response.dart';
import 'package:mal/shared/network/remote/api.dart';
import 'package:mal/shared/network/remote/end_points.dart';
import 'package:mal/translations/locale_keys.g.dart';
import 'package:share_plus/share_plus.dart';

import '../../../model/message_model.dart';
import 'sending_states.dart';

const pathToReadAudio = 'record.aac';

class SendingCubit extends Cubit<SendingStates> {
  SendingCubit() : super(SendingInitialState());

  static SendingCubit get(context) => BlocProvider.of(context);

  bool? startRecord = false;

  bool showClear = false;

  void showClearIcon(String input) {
    if (input.isNotEmpty || input != '') {
      showClear = true;
      emit(ShowClearIconState());
    } else {
      showClear = false;
      emit(ShowClearIconState());
    }
  }

  bool getMessagesErrorConnection = false;
  List<Message> messages = [];
  bool getMessageLoading = true;

  getMessages() async {
    getMessageLoading = true;
    emit(GetMessagesLoadingState());
    try {
      await API().getData(endPoint: EndPoints.getMessages).then((value) {
        var messageResponse = MessageResponse.fromJson(value.data);
        messages = messageResponse.messages!;
        print('get messages successfully');
        getMessageLoading = false;
        emit(GetMessagesSuccessState());
        print(messages.length);
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(GetMessagesErrorConnectionState(LocaleKeys.chek_internet.tr()));
        getMessagesErrorConnection = true;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit(GetMessagesErrorConnectionState(LocaleKeys.chek_internet.tr()));
        getMessagesErrorConnection = true;
      } else {
        getMessagesErrorConnection = true;
        emit(GetMessagesErrorConnectionState(LocaleKeys.ops.tr()));
      }
    } catch (e) {
      getMessagesErrorConnection = true;
      emit(GetMessagesErrorConnectionState(LocaleKeys.ops.tr()));
    }
  }

  int value = 0;

  void share({String? mMessage, reContact}) async {
    bool space = true;
    for (final character in mMessage.toString().runes) {
      if (character == 32) {
        space = true;
      } else {
        space = false;
        break;
      }
    }
    print(space);
    print('imageFileList length =  ${imageFileList!.length}');
    if (value == 0 &&
        space == false &&
        mMessage!.isNotEmpty &&
        imageFileList!.isEmpty &&
        imagePathsList!.isEmpty &&
        filesPaths.isEmpty) {
      print('message length =  ${mMessage.length}');
      await Share.share('$mMessage\n' + reContact).then((value) {
        /// after share
         uploadMessage(mMessage);
      });

    } else if (imagePathsList!.isNotEmpty) {
      print(imagePathsList!.length);
      print('share images');
      /*if(imagePathsList!.length==1&&space==false && mMessage!.isNotEmpty){
        await Share.shareFiles(imagePathsList!,text:'$mMessage\n' + reContact,).then((value){
          // uploadMessage(mMessage);
        });
      }else{
        await Share.shareFiles(imagePathsList!);
      }*/
      await Share.shareFiles(imagePathsList!);

    } else if (filesPaths.isNotEmpty) {
      print(filesPaths.length);
      print('share files');
      await Share.shareFiles(filesPaths);
    } else if (value == 1) {
      print('share record');
      await Share.shareFiles(['/data/user/0/com.example.mal/cache/record.aac']);
    } else {
      emit(InValidMessageState());
    }
  } //end of share

  bool showMic = false;
  void pressToShowMic() {
    showMic = true;
    emit(ShowMicState());
  }

  void pressToHideMic() {
    showMic = false;
    emit(HideMicState());
  }

  ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  List<String>? imagePathsList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    imagePathsList=[];
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    for (var element in imageFileList!) {
      imagePathsList!.add(element.path);
    }
    emit(ImageLoadedState());
  } //end of selectImages

  void deleteSelectedImage(int index) {
    imageFileList!.removeAt(index);
    imagePathsList!.removeAt(index);
    //imageFileList!.removeAt(index);
    emit(RemoveSelectedImageState());
  } //end of deleteSelectedImage

  List<String> filesPaths = [];
  FilePickerResult? result;

  void selectFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for (var element in files) {
        filesPaths.add(element.path);
      }
      emit(SelectedFilesState());
    } else {
      // User canceled the picker
    }
  } //end of selectFiles

  void deleteSelectedFile(int index) {
    filesPaths.removeAt(index);
    emit(RemoveSelectedFileState());
  } //end of deleteSelectedImage

  void uploadMessage(String message) async {
    emit(UploadMessageLoadingState());
    try {
      await API().postData(
          endPoint: EndPoints.getMessages,
          data: {'content': message, 'type': 'text'}).then((value) {
        print(value.data['status']);
        getMessages();
        emit(UploadMessageSuccessState(message: value.data['success']));
      });
    } on DioError catch (e) {
      print('error form dio = ${e}');
    } catch (e) {
      print('error form method = ${e.toString()}');
    }
  } //end of uploadMessage

  void deleteMessage(Message message) async {
    emit(UploadMessageLoadingState());
    try {
      await API()
          .postData(endPoint: EndPoints.deleteMessage + message.id.toString())
          .then((value) {
        print(value.data['success']);
        getMessages();
        emit(UploadMessageSuccessState(message: value.data['success']));
      });
    } on DioError catch (e) {
      print('error form dio = ${e}');
    } catch (e) {
      print('error form method = ${e.toString()}');
    }
  } //end of delete Message

}
