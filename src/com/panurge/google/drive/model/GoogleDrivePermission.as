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
	dynamic public class GoogleDrivePermission extends GoogleDriveModelBase
	{
		
		public var kind:String = ""; //	string	This is always drive#permission.	
		public var etag:String = ""; //	etag	The ETag of the permission.	
		public var id:String = ""; //	string	The ID of the permission.	
		public var selfLink:String = ""; //	string	A link back to this permission.	
		public var name:String = ""; //	string	The name for this permission.	
		public var role:String = ""; //	string	The primary role for this user. Allowed values are:
										/*
										owner
										reader
										writer
										writable
										*/
		public var additionalRoles:Array = null; //[]	list	Additional roles for this user. Only commenter is currently allowed.	 writable
		public var type:String = ""; //string	The account type. Allowed values are:
												// user
												// group
												// 	domain
												// anyone
												// writable
		public var authKey:String = ""; //	string	The authkey parameter required for this permission.	
		public var withLink:Boolean = false; //	boolean	Whether the link is required for this permission.	 writable
		public var photoLink:String = ""; //	string	A link to the profile photo, if available.	
		public var value:String = ""; //	string	The email address or domain name for the entity. This is not populated in responses.	 writable
				
		public function GoogleDrivePermission()
		{
			super();
		}
	}
}