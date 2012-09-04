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

package com.panurge.google.drive.events
{
	import flash.events.Event;
	
	
	/**
	 * The class to provide all the events types needed to manage the Google Drive 
	 * @author 
	 * 
	 */
	public class GoogleDriveEvent extends Event
	{
		
		public static const UPLOAD_ERROR:String = "UPLOAD_ERROR";
		public static const FILE_INSERT:String = "FILE_INSERT";
		public static const FILE_LIST_COMPLETE:String = "FILE_LIST_COMPLETE";
		public static const FILE_METADATA:String = "FILE_METADATA";
		public static const FILE_DELETE:String = "FILE_DELETE";
		public static const FILE_UPDATE:String = "FILE_UPDATE";
		public static const FILE_COPY:String = "FILE_COPY";
		public static const FILE_TOUCH:String = "FILE_TOUCH";
		public static const FILE_UNTRASH:String = "FILE_UNTRASH";
		public static const FILE_TRASH:String = "FILE_TRASH";
		public static const FILE_DOWNLOAD:String = "FILE_DOWNLOAD";
		public static const FILE_PATCH:String = "FILE_PATCH";
		public static const FILE_ALL_LIST:String = "FILE_ALL_LIST";
		public static const FOLDER_INSERT:String = "FOLDER_INSERT";
		
		public static const CHILDREN_LIST:String = "CHILDREN_LIST";
		public static const CHILD_GET:String = "CHILD_GET";
		public static const CHILD_DELETE:String = "CHILD_DELETE";
		public static const CHILD_INSERT:String = "CHILD_INSERT";
		
		public static const PARENTS_LIST:String = "PARENTS_LIST";
		public static const PARENT_GET:String = "PARENT_GET";
		public static const PARENT_DELETE:String = "PARENT_DELETE";
		public static const PARENT_INSERT:String = "PARENT_INSERT";
		
		public static const ABOUT_GET:String = "ABOUT_GET";
		public static const APPS_LIST:String = "APPS_LIST";
		
		public static const CHANGES_LIST:String = "CHANGES_LIST";
		public static const CHANGES_ALL_LIST:String = "CHANGES_ALL_LIST";
		public static const CHANGE_GET:String = "CHANGE_GET";
		
		public static const PERMISSIONS_LIST:String = "PERMISSIONS_LIST";
		public static const PERMISSIONS_GET:String = "PERMISSIONS_GET";
		public static const PERMISSIONS_DELETE:String = "PERMISSIONS_DELETE";
		public static const PERMISSIONS_UPDATE:String = "PERMISSIONS_UPDATE";
		public static const PERMISSIONS_INSERT:String = "PERMISSIONS_INSERT";
		public static const PERMISSIONS_PATCH:String = "PERMISSIONS_PATCH";
		
		public static const REVISIONS_LIST:String = "REVISIONS_LIST";
		public static const REVISIONS_GET:String = "REVISIONS_GET";
		public static const REVISIONS_DELETE:String = "REVISIONS_DELETE";
		public static const REVISIONS_UPDATE:String = "REVISIONS_UPDATE";
		public static const REVISIONS_PATCH:String = "REVISIONS_PATCH";
		
		
		public static const ERROR_EVENT:String = "ERROR_EVENT";
		
		
		public var data:* = null;
		
		public function GoogleDriveEvent(type:String, data:* = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{	
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}