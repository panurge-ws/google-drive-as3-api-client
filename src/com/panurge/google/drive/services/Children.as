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
	import com.panurge.google.drive.events.GoogleDriveEvent;
	
	import flash.events.Event;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import com.panurge.google.IGoogleOAuth2;
	import com.panurge.google.drive.model.GoogleDriveChild;
	import com.panurge.google.drive.model.GoogleDriveChildrenList;

	
	public class Children extends DriveServiceBase
	{
		
		public var driveClient:GoogleDriveClient;
		
		
		public function Children(oauth:IGoogleOAuth2)
		{
			super(oauth);
		}
		
		/**
		 * Lists a folder's children.
		 * Requests with children.list accept the q parameter, which is a search query combining one or more search terms. 
		 * 
		 * @param folderId string	 The ID of the folder.
		 * @param maxResults integer	 Maximum number of children to return.
		 * @param pageToken string	 Page token for children.
		 * @param q string	 Query string for searching children.
		 * @return 
		 * 
		 */
		public function children_list(folderId:String, maxResults:int = -1, pageToken:String = "", q:String = ""):DynamicURLLoader
		{
			
			var urlVar:URLVariables = new  URLVariables();
			if (maxResults != -1){
				urlVar.maxResults = maxResults;
			}
			if (pageToken != ""){
				urlVar.pageToken = pageToken;
			}
			if (q != ""){
				urlVar.q = q;
			}
			
			return callService("https://www.googleapis.com/drive/v2/files/" + folderId + "/children", URLRequestMethod.GET, GoogleDriveEvent.CHILDREN_LIST, urlVar);
			
		}
		
		/**
		 * Gets a specific child reference. 
		 * @param folderId string	 The ID of the child.
		 * @param childId string	 The ID of the folder.
		 * @return 
		 * 
		 */
		public function child_get(folderId:String, childId:String):DynamicURLLoader
		{			
			return callService("https://www.googleapis.com/drive/v2/files/" + folderId + "/children/" + childId, URLRequestMethod.GET, GoogleDriveEvent.CHILD_GET);	
		}
		
		/**
		 * Removes a child from a folder. 
		 * @param folderId string	 The ID of the folder.
		 * @param childId string	 The ID of the child.
		 * @return 
		 * 
		 */
		public function child_delete(childId:String, folderId:String):DynamicURLLoader
		{			
			return callService("https://www.googleapis.com/drive/v2/files/" + folderId + "/children/" + childId, URLRequestMethod.DELETE, GoogleDriveEvent.CHILD_DELETE);	
		}
		
		/**
		 * Inserts a file into a folder. 
		 * In the request body, supply a Children resource with the following properties:
		 * 
		 * Required Properties
		 * id	string	The ID of the child.
		 *
		 * @param folderId The ID of the folder.
		 * @param child a GoogleDriveChild object
		 * @return 
		 * 
		 */
		public function child_insert(folderId:String, child:GoogleDriveChild):DynamicURLLoader
		{			
			
			return callService(	"https://www.googleapis.com/drive/v2/files/" + folderId + "/children", 
				URLRequestMethod.POST, 
				GoogleDriveEvent.CHILD_INSERT,
				JSON.stringify(buildParams(child)),
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
				
				case GoogleDriveEvent.CHILD_GET:
				case GoogleDriveEvent.CHILD_DELETE:
				case GoogleDriveEvent.CHILD_INSERT:
				{	
					if (urlLoader.data != null && urlLoader.data != ""){
						var child:GoogleDriveChild = new GoogleDriveChild();
						child.cast(objectResult);
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType,child);
					}
					else{
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType, null);
					}
					break;
				}
				case GoogleDriveEvent.CHILDREN_LIST:
				{	
					var childrenList:GoogleDriveChildrenList = new GoogleDriveChildrenList();
					childrenList.cast(objectResult);
					
					eventToDispatch = new GoogleDriveEvent(GoogleDriveEvent.CHILDREN_LIST, childrenList);
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