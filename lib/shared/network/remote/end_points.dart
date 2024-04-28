class EndPoints {


  static String baseUrl = 'https://mal.simply37.com/api/v1/user';
  static String baseUrlForImage = 'https://mal.simply37.com';



  static String getSettings = '/settings';
  static String login = '/auth/login';
  static String getUserDetails = '/user/details';
  static String getUserProfile = '/profile/details';
  static String updateProfile = '/profile/update';
  static String upLoadImageProfile = '/profile/update-image';
  static String getAllNotification = '/notifications';

  static String getAllAds = '/ads';
  static String getMessages = '/messages';
  static String deleteMessage = '/messages/delete/';

  static String getStages = '/stages';
  static String getStage = '/stages/show/';
  static String finishStage = '/stages/finish/';
  static String createMeeting = '/zoom/store';
  static String updateMeeting = '/zoom/update';
  static String updateZoomEmail = '/zoom/update_email';
  static String getZoomEmail = '/zoom/get_zoom_email';
  static String previousMeetings = '/zoom/previous_meetings';
  static String upcomingMeetings = '/zoom/upcoming_meetings';
  static String zoomSync = '/zoom/sync';
  static String getGroups = '/groups';
  static String createGroup = '/groups/store';
  static String editGroup = '/groups/edit/';
  static String deleteGroup = '/groups/delete/';
  static String deleteGroups = '/groups/selected/delete';
  static String addContactToGroup = '/groups/add_contact_to_group';
  static String addContactsToGroup = '/groups/list/create';
  static String groupDetails = '/groups/show/';//pass id after url
  static String deleteContact = '/contacts/delete/';//pass id after url
  static String deleteContacts = '/contacts/selected/delete';
  static String editContact = "/contacts/edit/";//pass id after url
  static String getContact = "/contacts/show/";//pass id after url
  static String changeContactsGroup = "/contacts/changeGroup";
  static String getUserNotes = "/notes/contact/";//pass id after url
  static String editUserNote = "/notes/edit/";//pass id after url
  static String addUserNote = "/notes/store";
  static String deleteUserNote = "/notes/delete/";//pass id after url
  static String addUserTask = "/tasks/store";
  static String getUserTasks = "/tasks/contact/";//pass id after url
  static String editUserTask = "/tasks/edit/";//pass id after url
  static String deleteUserTask = "/tasks/delete/";//pass id after url
  static String markUserTask = "/tasks/mark/";//pass id after url

}
