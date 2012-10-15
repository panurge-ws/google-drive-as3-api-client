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
	import com.panurge.google.drive.model.GoogleDriveChild;
	import com.panurge.google.drive.model.GoogleDriveChildrenList;
	import com.panurge.google.drive.model.GoogleDriveParent;
	import com.panurge.google.drive.model.GoogleDriveParentsList;
	
	import flash.events.Event;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	
	public class Parents extends DriveServiceBase
	{
		
		public var driveClient:GoogleDriveClient;
		
		
		public function Parents(oauth:IGoogleOAuth2)
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
		public function parents_list(fileId:String, fields:String = ""):DynamicURLLoader
		{	
			var urlVar:URLVariables = new  URLVariables();
			
			if (fields != ""){
				urlVar.fields = fields;
			}
			return callService("https://www.googleapis.com/drive/v2/files/" + fileId + "/parents", URLRequestMethod.GET, GoogleDriveEvent.PARENTS_LIST, urlVar)	
		}
		
		/**
		 * 
		 * @param fileId
		 * @param parentId
		 * @return 
		 * 
		 */
		public function parent_get(fileId:String, parentId:String):DynamicURLLoader
		{			
			return callService("https://www.googleapis.com/drive/v2/files/" + fileId + "/parents/" + parentId, URLRequestMethod.GET, GoogleDriveEvent.PARENT_GET);	
		}
		
		/**
		 * 
		 * @param fileId
		 * @param parentId
		 * @return 
		 * 
		 */
		public function parent_delete(fileId:String, parentId:String):DynamicURLLoader
		{			
			return callService("https://www.googleapis.com/drive/v2/files/" + fileId + "/parents/" + parentId, URLRequestMethod.DELETE, GoogleDriveEvent.PARENT_DELETE);	
		}
		
		/**
		 * 
		 * @param fileId
		 * @param parent
		 * @return 
		 * 
		 */
		public function parent_insert(fileId:String, parent:GoogleDriveParent):DynamicURLLoader
		{			
			
			return callService(	"https://www.googleapis.com/drive/v2/files/" + fileId + "/parents", 
				URLRequestMethod.POST, 
				GoogleDriveEvent.PARENT_INSERT,
				JSON.stringify(buildParams(parent)),
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
				
				case GoogleDriveEvent.PARENT_GET:
				case GoogleDriveEvent.PARENT_DELETE:
				case GoogleDriveEvent.PARENT_INSERT:
				{	
					if (urlLoader.data != null && urlLoader.data != ""){
						trace(urlLoader.data);
						var parent:GoogleDriveParent = new GoogleDriveParent();
						parent.cast(objectResult);
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType,parent);
					}
					else{
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType, null);
					}
					break;
				}
				case GoogleDriveEvent.PARENTS_LIST:
				{	
					var parentsList:GoogleDriveParentsList = new GoogleDriveParentsList();
					parentsList.cast(objectResult);
					
					eventToDispatch = new GoogleDriveEvent(GoogleDriveEvent.PARENTS_LIST, parentsList);
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