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
	import com.panurge.google.drive.model.GoogleDriveChange;
	import com.panurge.google.drive.model.GoogleDriveChangesList;
	
	import flash.events.Event;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import com.panurge.google.IGoogleOAuth2;
	
	/**
	 * Changes service class
	 * 
	 * @author 
	 * 
	 * @see https://developers.google.com/drive/v2/reference/changes
	 * 
	 */
	public class Changes extends DriveServiceBase
	{
		
		public var driveClient:GoogleDriveClient;
		
		
		public function Changes(oauth:IGoogleOAuth2)
		{
			super(oauth);
		}
		
		/**
		 * Lists the changes for a user.
		 *  
		 * @param includeDeleted Whether to include deleted items.
		 * @param includeSubscribed Whether to include subscribed items.
		 * @param maxResults Maximum number of changes to return.
		 * @param pageToken Page token for changes.
		 * @param startChangeId Change ID to start listing changes from.
		 * @param fields Selector specifying which fields to include in a partial response.
		 * @return 
		 * 
		 */
		public function change_list(includeDeleted:Boolean = false, includeSubscribed:Boolean = false, maxResults:int = -1, pageToken:String = "", startChangeId:Number = -1, fields:String = ""):DynamicURLLoader
		{
			
			var urlVar:URLVariables = new  URLVariables();
			
			urlVar.includeDeleted = includeDeleted;
			urlVar.includeSubscribed = includeSubscribed;
			
			if (maxResults != -1){
				urlVar.maxResults = maxResults;
			}
			if (pageToken != ""){
				urlVar.pageToken = pageToken;
			}
			if (startChangeId != -1){
				urlVar.startChangeId = startChangeId;
			}
			if (fields != ""){
				urlVar.fields = fields;
			}
			
			return callService("https://www.googleapis.com/drive/v2/changes", URLRequestMethod.GET, GoogleDriveEvent.CHANGES_LIST, urlVar);
			
		}
		
		
		private var allChanges:Array = [];
		public function change_all_list(includeDeleted:Boolean = false, includeSubscribed:Boolean = false, pageToken:String = "", startChangeId:Number = -1):DynamicURLLoader
		{
		
		
			var urlVar:URLVariables = new  URLVariables();
			
			urlVar.includeDeleted = includeDeleted;
			urlVar.includeSubscribed = includeSubscribed;
			
			if (pageToken != ""){
				urlVar.pageToken = pageToken;
			}
			if (startChangeId != -1){
				urlVar.startChangeId = startChangeId;
			}
			
			var handler:Function = function(event:Event):void{
				loader.removeEventListener(Event.COMPLETE, handler);
				var changesList:GoogleDriveChangesList = new GoogleDriveChangesList();
				changesList.cast(JSON.parse(event.currentTarget.data as String));
				allChanges = allChanges.concat(changesList.items);
				
				if (changesList.nextPageToken != ""){
					change_all_list(includeDeleted, includeSubscribed, pageToken, startChangeId);
				}
				else{
					changesList.items = allChanges;	
					dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.CHANGES_ALL_LIST, changesList));
				}
			};
			
			var loader:DynamicURLLoader = callService("https://www.googleapis.com/drive/v2/changes/", URLRequestMethod.GET, GoogleDriveEvent.CHANGES_ALL_LIST, urlVar);
			loader.addEventListener(Event.COMPLETE,handler);
			
			return loader;
			
		}
		
		public function change_get(changeId:String):DynamicURLLoader
		{
			return callService("https://www.googleapis.com/drive/v2/changes/" + changeId, URLRequestMethod.GET, GoogleDriveEvent.CHANGE_GET);
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
				
				case GoogleDriveEvent.CHANGE_GET:
				{	
					if (urlLoader.data != null && urlLoader.data != ""){
						var change:GoogleDriveChange = new GoogleDriveChange();
						change.cast(objectResult);
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType,change);
					}
					else{
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType);
					}
					
					break;
				}
					
				case GoogleDriveEvent.CHANGES_LIST:
				{	
					var changesList:GoogleDriveChangesList = new GoogleDriveChangesList();
					changesList.cast(objectResult);
					
					eventToDispatch = new GoogleDriveEvent(GoogleDriveEvent.CHANGES_LIST, changesList);
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