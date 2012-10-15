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
	 * Change https://developers.google.com/drive/v2/reference/changes 
	 * @author aboschini
	 * 
	 * @see https://developers.google.com/drive/v2/reference/changes
	 */
	dynamic public class GoogleDriveChange extends GoogleDriveModelBase
	{
		
		/**
		 * This is always drive#change.
		 */
		public var kind:String = ""; //	string		
		/**
		 * The ID of the change.
		 */
		public var id:Number = -1; //	unsigned long		
		/**
		 * The ID of the file associated with this change.	
		 */
		public var fileId:String = ""; //	string	
		/**
		 * A link back to this change.
		 */
		public var selfLink:String = ""; //	string		
		/**
		 * Whether the file has been deleted.	
		 */
		public var deleted:Boolean = false; //	boolean	
		
		private var _file:GoogleDriveFile = null;
		
			
		/**
		 * The updated state of the file. Present if the file has not been deleted.
		 * @return 
		 * 
		 */
		public function get file():Object
		{
			return _file;
		}

		public function set file(value:Object):void
		{
			if (value){
				_file = new GoogleDriveFile();
				_file.cast(value);
			}
		}

 
								
		public function GoogleDriveChange()
		{
			
		}
	}
}