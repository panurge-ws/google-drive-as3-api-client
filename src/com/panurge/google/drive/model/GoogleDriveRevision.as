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
	dynamic public class GoogleDriveRevision extends GoogleDriveModelBase
	{
		
			
		public var kind:String = ""; //	This is always drive#permission.	
		public var etag:String = ""; //	The ETag of the revision.	
		public var id:String = ""; //	The ID of the revision.	
		public var selfLink:String = ""; //	A link back to this revision.	
		public var mimeType:String = ""; //	The MIME type of the revision.	
		public var modifiedDate:String = ""; //	datetime Last time this revision was modified (formatted RFC 3339 timestamp).	
		public var pinned:Boolean = false; //	Whether this revision is pinned to prevent automatic purging. This will only be populated and can only be modified on files with content stored in Drive which are not Google Docs. Revisions can also be pinned when they are created through the drive.files.insert/update/copy by using the pinned query parameter.	 writable
		public var published:Boolean = false; // Whether this revision is published. This is only populated and can only be modified for Google Docs.	 writable
		public var publishedLink:String = ""; //	A link to the published revision.	
		public var publishAuto:Boolean = false; //	Whether subsequent revisions will be automatically republished. This is only populated and can only be modified for Google Docs.	 writable
		public var publishedOutsideDomain:Boolean = false; //	Whether this revision is published outside the domain. This is only populated and can only be modified for Google Docs.	 writable
		public var downloadUrl:String = ""; //	Short term download URL for the file. This will only be populated on files with content stored in Drive.	
		public var exportLinks:Object = null; //	object	Links for exporting Google Docs to specific formats.	
												// exportLinks.(key)	string	A mapping from export format to URL	
		public var lastModifyingUserName:String = ""; //	Name of the last user to modify this revision.	
		public var originalFilename:String = ""; //	The original filename when this revision was created. This will only be populated on files with content stored in Drive.	
		public var md5Checksum:String = ""; //	An MD5 checksum for the content of this revision. This will only be populated on files with content stored in Drive.	
		public var fileSize:Number = -1; //	The size of the revision in bytes. This will only be populated on files with content stored in Drive.
				
		public function GoogleDriveRevision()
		{
			super();
		}
	}
}