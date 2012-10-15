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
	import com.panurge.google.drive.model.GoogleDriveChange;
	import com.panurge.google.drive.model.GoogleDriveChangesList;
	import com.panurge.google.drive.model.GoogleDrivePermission;
	import com.panurge.google.drive.model.GoogleDrivePermissionsList;
	import com.panurge.google.drive.model.GoogleDriveRevision;
	import com.panurge.google.drive.model.GoogleDriveRevisionsList;
	
	import flash.events.Event;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	
	public class Revisions extends DriveServiceBase
	{
		
		public var driveClient:GoogleDriveClient;
		
		
		public function Revisions(oauth:IGoogleOAuth2)
		{
			super(oauth);
		}
		
		
			
		/**
		 * 
		 * @param fileId
		 * @param fields Selector specifying which fields to include in a partial response.
		 * @return 
		 * 
		 */
		public function revisions_list(fileId:String = "", fields:String = ""):DynamicURLLoader
		{	
			var urlVar:URLVariables = new  URLVariables();
			
			if (fields != ""){
				urlVar.fields = fields;
			}
			
			return callService("https://www.googleapis.com/drive/v2/"+fileId+"/revisions", URLRequestMethod.GET, GoogleDriveEvent.REVISIONS_LIST, urlVar);
			
		}
		
		public function revisions_get(fileId:String, revisionId:String):DynamicURLLoader
		{
			return callService("https://www.googleapis.com/drive/v2/"+fileId+"/revisions/" + revisionId, URLRequestMethod.GET, GoogleDriveEvent.REVISIONS_GET);
		}
		
		/*
		In the request body, supply a Revisions resource with the following properties:
		
		Optional Properties
		pinned	boolean	Whether this revision is pinned to prevent automatic purging. This will only be populated and can only be modified on files with content stored in Drive which are not Google Docs. Revisions can also be pinned when they are created through the drive.files.insert/update/copy by using the pinned query parameter.	 writable
		publishAuto	boolean	Whether subsequent revisions will be automatically republished. This is only populated and can only be modified for Google Docs.	 writable
		published	boolean	Whether this revision is published. This is only populated and can only be modified for Google Docs.	 writable
		publishedOutsideDomain	boolean	Whether this revision is published outside the domain. This is only populated and can only be modified for Google Docs.	 writable
		*/
		public function revisions_update(fileId:String, revisionId:String, revision:GoogleDriveRevision):DynamicURLLoader
		{
			
			return callService(	"https://www.googleapis.com/drive/v2/"+fileId+"/revisions/" + revisionId, 
								URLRequestMethod.PUT, 
								GoogleDriveEvent.REVISIONS_UPDATE,
								JSON.stringify(buildParams(revision)),
								"application/json");
		}
		
		public function revisions_delete(fileId:String, revisionId:String):DynamicURLLoader
		{
			return callService("https://www.googleapis.com/drive/v2/"+fileId+"/revisions/" + revisionId, URLRequestMethod.DELETE, GoogleDriveEvent.REVISIONS_DELETE);
		}
		
		public function revisions_patch(fileId:String, revisionId:String, revision:GoogleDriveRevision):DynamicURLLoader
		{
			
			return callService(	"https://www.googleapis.com/drive/v2/" + fileId + "/revisions/" + revisionId, 
				"PATCH", 
				GoogleDriveEvent.REVISIONS_PATCH,
				JSON.stringify(buildParams(revision)),
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
				
				case GoogleDriveEvent.REVISIONS_DELETE:
				case GoogleDriveEvent.REVISIONS_GET:
				case GoogleDriveEvent.REVISIONS_PATCH:
				case GoogleDriveEvent.REVISIONS_UPDATE:
				{	
					if (urlLoader.data != null && urlLoader.data != ""){
						var revision:GoogleDriveRevision = new GoogleDriveRevision();
						revision.cast(objectResult);
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType, revision);
					}
					else{
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType);
					}
					
					break;
				}
					
				case GoogleDriveEvent.REVISIONS_LIST:
				{	
					var revisionsList:GoogleDriveRevisionsList = new GoogleDriveRevisionsList();
					try{
						revisionsList.cast(objectResult);
					}
					catch(e:Error){
						trace(this, event.currentTarget.data, e.toString());
					}
					
					eventToDispatch = new GoogleDriveEvent(GoogleDriveEvent.REVISIONS_LIST, revisionsList);
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