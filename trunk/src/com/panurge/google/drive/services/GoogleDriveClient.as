/*
Licensed under the MIT License

Copyright (c) 2012 Panurge Web Studio

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


*/

package com.panurge.google.drive.services
{
	
	
	import com.adobe.net.DynamicURLLoader;
	import com.panurge.google.GoogleServiceBase;
	import com.panurge.google.IGoogleOAuth2;
	import com.panurge.google.drive.events.GoogleDriveEvent;
	import com.panurge.google.drive.model.GoogleDriveAbout;
	
	import flash.events.Event;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * The Drive client class. 
	 * You can use this class to access the drive API.
	 * 
	 * Please note that this class hosts also some of the other services (like parents, files, children, etc.).
	 * Those services can also be instantiated like indipendent classes; but if you want a complete client API, this is the class you need.
	 * <pre>
	 * <code>
	 * 
	 * var oAuth:GoogleOAuth2 = new GoogleOAuth2();
	   oAuth.CLIENT_ID = YOUR_CLIENT_ID;
	   oAuth.CLIENT_SECRET = YOUR_CLIENT_SECRET;
	   oAuth.REDIRECT_URI = "http://www.yoursite.com/";
	   oAuth.SCOPES = "https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile";
	   oAuth.manageSession = true;
				
	   var driveClient:GoogleDriveClient = new GoogleDriveClient(oAuth);
	   driveClient.addEventListener(GoogleDriveEvent.ERROR_EVENT, onApiError);
	   driveClient.addEventListener(GoogleDriveEvent.UPLOAD_ERROR, onApiError);
				
	   var stageWebView:StageWebView = new StageWebView();
	   stageWebView.viewPort = new Rectangle(0,0,400,400);
				
	   oAuth.stageWebView = stageWebView;
	   oAuth.addEventListener(GoogleOAuth2Event.AUTH_REQUEST_INIT, onAuthRequestInit);
	   oAuth.addEventListener(GoogleOAuth2Event.AUTH_FAULT, onAuthFault);
	   oAuth.addEventListener(GoogleOAuth2Event.AUTH_SUCCESS, onAuthSuccess);
	   oAuth.init();		
	
	 * 
	 * </code>
	 * </pre>
	 * @author 
	 * 
	 * @version 0.0.1
	 * 
	 */
	public class GoogleDriveClient extends DriveServiceBase
	{
		
		public static const MIMETYPE_GOOGLE_FOLDER:String = "application/vnd.google-apps.folder";
		
		
		/**
		 * if true, if you don't set any mimetype for the files upload, the API tries to autodetect the mimetypes.
		 * WARNING: some text mimetypes return error in uploading ("text/plain", application/xml", etc). 
		 * You can force these types to "text/html" to let Google Drive read them or simply to "application/octet-stream"
		 * if you have no idea of which mimetype the file belongs to. 
		 * If this variable is set to true, the API will automatically
		 * force these types to allowed ones. 
		 */
		public static var auto_detect_mimetype:Boolean = true;
		
		/**
		 * 
		 * @param oauth The IGoogleOAuth2 needed to manage authentication (e.g.: GoogleOAuth2)
		 * 
		 * @see GoogleOAuth2
		 * 
		 */
		public function GoogleDriveClient(oauth:IGoogleOAuth2)
		{
			super(oauth);
		}
		
		private var _files:Files;
		
		/**
		 * The Google Drive Files service
		 * @return 
		 * 
		 */
		public function get files():Files
		{
			if (!_files){
				_files = new Files(oauth);
				_files.driveClient = this;
			}
			return _files;
		}
		
		public function set files(value:Files):void
		{
			_files = value;
		}
		
		private var _changes:Changes;

		/**
		 * The Google Drive Changes service
		 * @return 
		 * 
		 */
		public function get changes():Changes
		{
			if (!_changes){
				_changes = new Changes(oauth);
				_changes.driveClient = this;
			}
			return _changes;
		}

		public function set changes(value:Changes):void
		{
			_changes = value;
		}
		
		private var _permissions:Permissions;
		
		/**
		 * The Google Drive Permissions service
		 * @return 
		 * 
		 */
		public function get permissions():Permissions
		{
			if (!_permissions){
				_permissions = new Permissions(oauth);
				_permissions.driveClient = this;
			}
			return _permissions;
		}
		
		public function set permissions(value:Permissions):void
		{
			_permissions = value;
		}
		
		
		private var _revisions:Revisions;
		
		/**
		 * The Google Drive Revisions service
		 * @return 
		 * 
		 */
		public function get revisions():Revisions
		{
			if (!_revisions){
				_revisions = new Revisions(oauth);
				_revisions.driveClient = this;
			}
			return _revisions;
		}
		
		public function set revisions(value:Revisions):void
		{
			_revisions = value;
		}

		
		// children
		
		
		private var _children:Children;
		
		/**
		 * The Google Drive Children service
		 * @return 
		 * 
		 */
		public function get children():Children
		{
			if (!_children){
				_children = new Children(oauth);
				_children.driveClient = this;
			}
			return _children;
		}
		
		public function set children(value:Children):void
		{
			_children = value;
		}

		
		
		
		
		// parents
		
		private var _parents:Parents;
		
		/**
		 * The Google Drive Children service
		 * @return 
		 * 
		 */
		public function get parents():Parents
		{
			if (!_parents){
				_parents = new Parents(oauth);
				_parents.driveClient = this;
			}
			return _parents;
		}
		
		public function set parents(value:Parents):void
		{
			_parents = value;
		}

		
		// About
		
		
		/**
		 * 
		 * Gets the information about the current user along with Drive API settings
		 * 
		 * @param includeSubscribed Whether to include subscribed items when calculating the number of remaining change IDs
		 * @param maxChangeIdCount Maximum number of remaining change IDs to count
		 * @param startChangeId Change ID to start counting from when calculating number of remaining change IDs
		 * @return 
		 * 
		 */
		public function about_get(includeSubscribed:Boolean = false, maxChangeIdCount:Number = -1, startChangeId:Number = -1):DynamicURLLoader
		{	
			var urlVar:URLVariables = new  URLVariables();
			
			urlVar.includeSubscribed = includeSubscribed;
			
			if (startChangeId != -1){
				urlVar.startChangeId = startChangeId;
			}
			if (maxChangeIdCount != -1){
				urlVar.maxChangeIdCount = maxChangeIdCount;
			}
			
			return callService("https://www.googleapis.com/drive/v2/about", URLRequestMethod.GET, GoogleDriveEvent.ABOUT_GET, urlVar);	
		}
		
		
		
		/**
		 * Lists a user's apps.
		 * 
		 * Authorization
		 * 
		 * This request requires authorization with at least one of the following scopes (read more about authentication and authorization).
		   Scope
			https://www.googleapis.com/auth/drive.apps
			https://www.googleapis.com/auth/drive.apps.readonly
			
		 * This service will return a generic <code>Object</code>, since Google Drive API Reference doesn't provide a model for App list
		 * 
		 * @return 
		 * 
		 */
		public function apps_list():DynamicURLLoader
		{	
			return callService("https://www.googleapis.com/drive/v2/apps", URLRequestMethod.GET, GoogleDriveEvent.APPS_LIST );	
		}
		
		
		
		override protected function onLoadComplete(event:Event):void
		{
			
			var objectResult:Object = this.parseResult(event);
			// we got an error
			if (objectResult == null)
				return;
			
			var urlLoader:* = event.currentTarget;
			removeListeners(urlLoader);
			
			trace("onLoadComplete", urlLoader.eventType, urlLoader);
			
			var eventToDispatch:GoogleDriveEvent;
			
			switch(urlLoader.eventType)
			{
					
				case GoogleDriveEvent.ABOUT_GET:
				{	
					if (urlLoader.data != null && urlLoader.data != ""){
						var about:GoogleDriveAbout = new GoogleDriveAbout();
						about.cast(objectResult);
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType, about);
					}
					else{
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType, null);
					}
					break;
				}
					
				case GoogleDriveEvent.APPS_LIST:
				{	
					if (urlLoader.data != null && urlLoader.data != ""){
						// retunr a generic Objecr 
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType, objectResult);
					}
					else{
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType, null);
					}
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			if (eventToDispatch){
				dispatchEvent(eventToDispatch);
			}
		}		
		
		
		
			
	}
}