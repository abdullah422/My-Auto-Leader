abstract class SendingStates {}

class SendingInitialState extends SendingStates {}


// get messages
class GetMessagesLoadingState extends SendingStates {}
class GetMessagesSuccessState extends SendingStates {}
class GetMessagesErrorState extends SendingStates {
  final String error;

  GetMessagesErrorState(this.error);
}
class GetMessagesErrorConnectionState extends SendingStates {
  final String error;

  GetMessagesErrorConnectionState(this.error);
}

class InValidMessageState extends SendingStates {}
class ShowClearIconState extends SendingStates {}


//upload messages
class UploadMessageLoadingState extends SendingStates {}
class UploadMessageSuccessState extends SendingStates {
  final String message;

  UploadMessageSuccessState({required this.message});
}
class UploadMessageErrorState extends SendingStates {
  final String error;

  UploadMessageErrorState(this.error);
}






//images

class ImageLoadedState extends SendingStates {}
class RemoveSelectedImageState extends SendingStates {}

class ShowMicState extends SendingStates {}
class HideMicState extends SendingStates {}

class StartRecordState extends SendingStates {}


class SelectedFilesState extends SendingStates {}
class RemoveSelectedFileState extends SendingStates {}