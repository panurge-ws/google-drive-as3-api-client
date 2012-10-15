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

package com.panurge.google.drive.model
{
	/**
	 * A list of GoogleDriveFile(s)
	 *  
	 * @author
	 * 
	 */
	dynamic public class GoogleDriveFileList extends GoogleDriveModelBase
	{
		
		/**
		 * This is always drive#fileList.	
		 */
		public var kind:String = ""; //	string	
		/**
		 * The ETag of the list.
		 */
		public var etag:String = ""; //	etag		
		/**
		 * A link back to this list.
		 */
		public var selfLink:String = "";//	string		
		/**
		 * The page token for the next page of files.	
		 */
		public var nextPageToken:String = ""; //	string	
		/**
		 * A link to the next page of files.
		 */
		public var nextLink:String = ""; //	string		
		
		protected var _items:Array = [];
		
			
		/**
		 * The actual list of files.
		 * @return 
		 * 
		 */
		public function get items():Array
		{
			return _items;
		}

		public function set items(value:Array):void
		{
			if (value != null){
				_items = [];
				for (var i:int = 0; i < value.length; i++) 
				{
					if (value[i] is GoogleDriveFile){
						_items.push(value[i]);
					}
					else{
						var gFile:GoogleDriveFile = new GoogleDriveFile();
						gFile.cast(value[i]);
						_items.push(gFile);
					}
				}
			}
			
		}
						
		public function GoogleDriveFileList()
		{
			
		}
		
	}
}