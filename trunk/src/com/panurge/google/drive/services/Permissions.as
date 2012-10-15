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
	import com.panurge.google.drive.model.GoogleDrivePermission;
	import com.panurge.google.drive.model.GoogleDrivePermissionsList;
	
	import flash.events.Event;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	
	/**
	 * Permissions
	 * 
	 * https://developers.google.com/drive/v2/reference/permissions
	 * 
	 * @author aboschini
	 * 
	 */
	public class Permissions extends DriveServiceBase
	{
		
		public var driveClient:GoogleDriveClient;
		
		
		public function Permissions(oauth:IGoogleOAuth2)
		{
			super(oauth);
		}
		
		/*
		Required Parameters
		fileId	string	 The ID for the file.
		
		*/
			
		/**
		 * Lists a file's permissions. 
		 * @param fileId The ID for the file.
		 * @param fields Selector specifying which fields to include in a partial response.
		 * @return 
		 * 
		 */
		public function permissions_list(fileId:String = "", fields:String = ""):DynamicURLLoader
		{	
			var urlVar:URLVariables = new  URLVariables();
			
			if (fields != ""){
				urlVar.fields = fields;
			}
			
			return callService("https://www.googleapis.com/drive/v2/"+fileId+"/permissions", URLRequestMethod.GET, GoogleDriveEvent.PERMISSIONS_LIST, urlVar);
			
		}
		
		/**
		 * 
		 * @param fileId
		 * @param permissionId
		 * @return 
		 * 
		 */
		public function permissions_get(fileId:String, permissionId:String):DynamicURLLoader
		{
			return callService("https://www.googleapis.com/drive/v2/"+fileId+"/permissions/" + permissionId, URLRequestMethod.GET, GoogleDriveEvent.PERMISSIONS_GET);
		}
		
		/**
		 * 
		 * @param fileId
		 * @param permissionId
		 * @param permission
		 * @return 
		 * 
		 */
		public function permissions_update(fileId:String, permissionId:String, permission:GoogleDrivePermission):DynamicURLLoader
		{
			
			return callService(	"https://www.googleapis.com/drive/v2/"+fileId+"/permissions/" + permissionId, 
								URLRequestMethod.PUT, 
								GoogleDriveEvent.PERMISSIONS_UPDATE,
								JSON.stringify(buildParams(permission)),
								"application/json");
		}
		
		/**
		 * 
		 * @param fileId
		 * @param permissionId
		 * @return 
		 * 
		 */
		public function permissions_delete(fileId:String, permissionId:String):DynamicURLLoader
		{
			return callService("https://www.googleapis.com/drive/v2/"+fileId+"/permissions/" + permissionId, URLRequestMethod.DELETE, GoogleDriveEvent.PERMISSIONS_DELETE);
		}
		
		/*
		Parameters
		
		Required Parameters
			fileId	string	 The ID for the file.
		Optional Parameters
			sendNotificationEmails	boolean	 Whether to send notification emails.
		
		
		
		*/
		/**
		 *  
		 * @param fileId The ID for the file.
		 * @param permission A GoogleDrivePermission
		 * @param sendNotificationEmails Whether to send notification emails. (Default: true)
		 * 
		 * 
		 * <pre>
		 * 
		 * In the request body, supply a Permissions resource with the following properties:
		
		Property Name	Value	Description	Notes
		Required Properties
			role	string	The primary role for this user. Allowed values are:
							owner
							reader
							writer
							writable
			type	string	The account type. Allowed values are:
							user
							group
							domain
							anyone
							writable
			value	string	The email address or domain name for the entity. This is not populated in responses.	 writable
		Optional Properties
			additionalRoles[]	list	Additional roles for this user. Only commenter is currently allowed.	 writable
			withLink	boolean	Whether the link is required for this permission.	 writable
			 * 
		 * 
		 * </pre>
		 * 
		 * @return 
		 * 
		 * @see com.panurge.google.drive.model::GoogleDrivePermission
		 * 
		 */
		public function permissions_insert(fileId:String, permission:GoogleDrivePermission, sendNotificationEmails:Boolean = true):DynamicURLLoader
		{
			var optParams:Object = new Object();
			optParams.sendNotificationEmails = sendNotificationEmails;
			
			if (permission.role == ""){
				// TODO dispatch event required parameters error
			}
			if (permission.type == ""){
				// TODO dispatch event required parameters error
			}
			if (permission.value == ""){
				// TODO dispatch event required parameters error
			}
			
			return callService(	"https://www.googleapis.com/drive/v2/"+fileId+"/permissions", 
				URLRequestMethod.POST, 
				GoogleDriveEvent.PERMISSIONS_UPDATE,
				JSON.stringify(buildParams(permission,optParams)),
				"application/json");
		}
		
		override protected function onLoadComplete(event:Event):void
		{
			
			var objectResult:Object = this.parseResult(event, driveClient);
			// we got an error
			if (objectResult == null)
				return;
			
			var urlLoader:* = event.currentTarget;
			removeListeners(urlLoader);
			
			trace("onLoadComplete", urlLoader.eventType, urlLoader);
			
			var eventToDispatch:GoogleDriveEvent;
			
			switch(urlLoader.eventType)
			{
				
				case GoogleDriveEvent.PERMISSIONS_DELETE:
				case GoogleDriveEvent.PERMISSIONS_GET:
				case GoogleDriveEvent.PERMISSIONS_INSERT:
				case GoogleDriveEvent.PERMISSIONS_PATCH:
				case GoogleDriveEvent.PERMISSIONS_DELETE:
				{	
					if (urlLoader.data != null && urlLoader.data != ""){
						var permission:GoogleDrivePermission = new GoogleDrivePermission();
						permission.cast(objectResult);
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType,permission);
					}
					else{
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType);
					}
					
					break;
				}
					
				case GoogleDriveEvent.PERMISSIONS_LIST:
				{	
					var permissionsList:GoogleDrivePermissionsList = new GoogleDrivePermissionsList();
					try{
						permissionsList.cast(objectResult);
					}
					catch(e:Error){
						trace(this, event.currentTarget.data);
					}
					
					eventToDispatch = new GoogleDriveEvent(GoogleDriveEvent.PERMISSIONS_LIST, permissionsList);
					break;
				}
					
				default:
				{
					break;
				}
			}
			
			if (eventToDispatch){
				
				dispatchEvent(eventToDispatch);
				
				// dispatch also in the client
				if (driveClient){ 
					driveClient.dispatchEvent(eventToDispatch);
				}
				
			}
		}

	}
}