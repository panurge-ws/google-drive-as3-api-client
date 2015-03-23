**Refer to the example .mxml in "src" folder to understand how the framework works.**

## WARNING ##
Please register your app key in the Google API console as:

- a Web Application app in the Google API console with a valid (existing) redirect URL

OR

- an Installed Application -> Installed Application Type: Other


If you have used a Web Application method before, you need to logout first and then test the Installed Application Type method


See the docs contained in "docs" folder;

# MInimal Setup #

  1. copy "com" folder;
  1. add the libraries contained in "libs" folder;


```


			private var stageWebView:StageWebView;
			private var driveClient:GoogleDriveClient;
			private var oAuth:GoogleOAuth2;
			
			
			
			protected function init():void
			{
				
				// instantiates the OAuth2 setting
				// see https://developers.google.com/drive/quickstart
				oAuth = new GoogleOAuth2();
				
				oAuth.CLIENT_ID = "XXXXXXXXXXXXXX"
				oAuth.CLIENT_SECRET = "XXXXXXXXXXXX";
				oAuth.REDIRECT_URI = "XXXXXXXXXXXX";
				
				
				oAuth.SCOPES = "https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile";
				
				// we want to delegate to the framework the management of session and tokens
				oAuth.manageSession = true;
				
				// instantiates the Drive Client
				driveClient = new GoogleDriveClient(oAuth);
				driveClient.addEventListener(GoogleDriveEvent.ERROR_EVENT, onApiError);
				driveClient.addEventListener(GoogleDriveEvent.UPLOAD_ERROR, onApiError);
				
				// creates a StageWebView to host Login/Auth page prompted by Google Auth
				stageWebView = new StageWebView();
				stageWebView.viewPort = new Rectangle(0,0,400,400);
				
				// initilize the OAth2 process
				oAuth.stageWebView = stageWebView; // note that in this moment we don't need to display the StageWebView (see: onAuthRequestInit)
				
				oAuth.addEventListener(GoogleOAuth2Event.AUTH_REQUEST_INIT, onAuthRequestInit);
				oAuth.addEventListener(GoogleOAuth2Event.AUTH_FAULT, onAuthFault);
				oAuth.addEventListener(GoogleOAuth2Event.AUTH_SUCCESS, onAuthSuccess);
				
				oAuth.init();
			
			}
			
			protected function onApiError(event:GoogleDriveEvent):void
			{
				if (event.data){
					Alert.show("onAPIError\nerror code: " + event.data.code + "\nerror message: " + event.data.message);
				}
				else{
					Alert.show("onAPIError\n: " + event.toString());
				}
			}
			
			protected function onAuthFault(event:GoogleOAuth2Event):void
			{
				Alert.show("onAuthFault\nerror code: " + event.code + "\nerror message: " + event.message);
			}
			
			protected function onAuthRequestInit(GoogleOAuth2Event:Event):void
			{
				// we have to display stage web view NOW!
				stageWebView.viewPort = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
				stageWebView.stage = stage;
			}
			
			protected function onAuthSuccess(event:GoogleOAuth2Event):void
			{
				oAuth.removeEventListener(GoogleOAuth2Event.AUTH_SUCCESS, onAuthSuccess);
				
				// the auth was succefull so we can dispose the stageWebView
				stageWebView.dispose();
				stageWebView = null;
				
				// caldriveClient.files.files_list to populate the list of files
				driveClient.files.addEventListener(GoogleDriveEvent.FILE_LIST_COMPLETE, onListComplete);
				driveClient.files.files_list();
			}

			protected function onListComplete(event:GoogleDriveEvent):void
			{
				driveClient.files.removeEventListener(GoogleDriveEvent.FILE_LIST_COMPLETE, onListComplete);
				driveClient.files.removeEventListener(GoogleDriveEvent.FILE_ALL_LIST, onListComplete);
				
				
				var results:ArrayCollection = new ArrayCollection((event.data as GoogleDriveFileList).items);
				trace(results)
			}

```