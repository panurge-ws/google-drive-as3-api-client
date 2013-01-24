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
	
	dynamic public class GoogleDriveFile extends GoogleDriveModelBase
	{
		
		/**
		 * The type of file. This is always drive#file.
		 */
		public var kind:String = ""; 		
		/**
		 *  The ID of the file.	
		 */
		public var id:String = ""; //	string	
		/**
		 * 
		 */
		public var etag:String = null; //	etag	ETag of the file.	
		/**
		 *  A link back to this file.
		 */
		public var selfLink:String = ""; //	string		
		/**
		 * The title of the this file. Used to identify file or folder name.
		 */
		public var title:String = ""; //	string		
		/**
		 * The MIME type of the file.	
		 */
		public var mimeType:String = ""; //	string	
		/**
		 * A short description of the file.
		 */
		public var description:String = ""; //	string		
		/**
		 * 
		 */
		public var labels:Object = null; //	object	A group of labels for the file.	
		//public var labels.starred	boolean	Whether this file is starred by the user.	
		//public var labels.hidden	boolean	Whether this file is hidden from the user.	
		//public var labels.trashed	boolean	Whether this file has been trashed.	
		/**
		 * Create time for this file (formatted ISO8601 timestamp).
		 */
		public var createdDate:String = ""; //	datetime		
		/**
		 * Last time this file was modified by anyone (formatted RFC 3339 timestamp).
		 */
		public var modifiedDate:String = ""; //	datetime		
		/**
		 * Last time this file was modified by the currently authenticated user (formatted RFC 3339 timestamp).	
		 */
		public var modifiedByMeDate:String = ""; //	datetime	
		/**
		 * Short lived download URL for the file. This is only populated for files with content stored in Drive.
		 */
		public var downloadUrl:String = ""; //	string	
		
		// TODO model object
		/**
		 * Indexable text attributes for the file.  This property can only be written, and is not returned by files.get. For more information, see Saving indexable text.
		 */
		public var indexableText:Object = null; //	object		
		//public var indexableText.text	string	The text to be indexed for this file.	
		/**
		 * The permissions for the authenticated user on this file.
		 */
		public var userPermission:Object = null; //	nested object		
		/**
		 * The file extension used when downloading this file. This field is read only. To set the extension, include it on title when creating the file. This is populated only for files with content stored in Drive.	
		 */
		public var fileExtension:String = ""; //	string	
		/**
		 * An MD5 checksum for the content of this file. This is populated only for files with content stored in Drive.	
		 */
		public var md5Checksum:String = ""; //	string	
		/**
		 * The size of the file in bytes. This is populated only for files with content stored in Drive.	
		 */
		public var fileSize:Number = 0; // //	long	
		/**
		 * A link for opening the file in a browser.	
		 */
		public var alternateLink:String = ""; //	string		
		/**
		 * A link for embedding the file.
		 */
		public var embedLink:String = ""; //	string		
		/**
		 * A link to the permissions collection.
		 * - restricted	boolean	Whether viewers are prevented from downloading this file.
		 * - viewed	boolean	Whether this file has been viewed by this user.		
		 * 
		 */
		public var permissionsLink:String = ""; //	string	

		/**
		 * Time at which this file was shared with the user (formatted RFC 3339 timestamp).	
		 */
		public var sharedWithMeDate:String = ""; //	datetime
		
		/**
		 * Links for exporting Google Docs to specific formats.
		 * A mapping from export format to URL	
		 */
		public var exportLinks:Object = null; //	object		
		//public var exportLinks.(key)	string	
		/**
		 * The filename when uploading this file. This will only be populated on files with content stored in Drive.	
		 */
		public var originalFilename:String = "";	
		/**
		 * The number of quota bytes used by this file.
		 */
		public var quotaBytesUsed:Number = 0;		
		/**
		 * Name(s) of the owner(s) of this file.	
		 */
		public var ownerNames:Array = null;	
		/**
		 * Name of the last user to modify this file. This will only be populated if a user has edited this file.
		 */
		public var lastModifyingUserName:String = "";		
		/**
		 * Whether the file can be edited by the current user.
		 */
		public var editable:Boolean = false;		
		/**
		 * 	Whether writers can share the document with other users.
		 */
		public var writersCanShare:Boolean = false;	
		/**
		 * A link to the file's thumbnail.
		 */
		public var thumbnailLink:String = "";		
		/**
		 * Last time this file was viewed by the user (formatted RFC 3339 timestamp).
		 */
		public var lastViewedByMeDate:String = "";	
		
		/**
		 * 	A link for downloading the content of the file in a browser using cookie based authentication. In cases where the content is shared publicly, the content can be downloaded without any credentials.	
		 */
		public var webContentLink:String = ""; 
		
		/**
		 * A link providing access to static web assets (HTML, CSS, JS, etc) in a public folder hierarchy using filenames in a relative path. 
		 */
		public var webViewLink:String = "";
		
		/**
		 * A link to the file's icon.
		 */
		public var iconLink:String = "";
		
		/**
		 * Whether this file has been explicitly trashed, as opposed to recursively trashed. This will only be populated if the file is trashed.	
		
		 */
		public var explicitlyTrashed:Boolean; 
		// TODO set object model
		/**
		 * Metadata about image media. This will only be present for image types, and its contents will depend on what can be parsed from the image content.
		
		 */
		public var imageMediaMetadata:Object; 
		
		
		public function GoogleDriveFile()
		{
		
		}	

		private var _parents:Array = null; //	list	
		//On insert, setting this field will put the file in all of the provided folders. If no folders are provided, the file will be placed in the default root folder. On update, this field is ignored.
		
		/**
		 * Collection of parent folders which contain this file.
		 * @return 
		 * 
		 */
		public function get parents():Array
		{
			return _parents;
		}

		public function set parents(value:Array):void
		{
			if (value != null){
				_parents = [];
				for (var i:int = 0; i < value.length; i++) 
				{
					if (value[i] is GoogleDriveParent){
						_parents.push(value[i]);
					}
					else{
						var gParent:GoogleDriveParent = new GoogleDriveParent();
						gParent.cast(value[i]);
						_parents.push(gParent);
					}
				}
				
			}
		}

		
	}
}