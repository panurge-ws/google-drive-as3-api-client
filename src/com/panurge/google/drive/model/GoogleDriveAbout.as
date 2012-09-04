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
	 * https://developers.google.com/drive/v2/reference/about 
	 * @author aboschini
	 * 
	 * @see https://developers.google.com/drive/v2/reference/about
	 */
	public class GoogleDriveAbout extends GoogleDriveModelBase
	{
		
		public var kind:String = ""; //	string	This is always drive#about.	
		public var etag:String = ""; //	etag The ETag of the item.	
		public var selfLink:String = ""; //	string	A link back to this item.	
		public var name:String = ""; //	string	The name of the current user.	
		public var quotaBytesTotal:Number = -1; //	long	The total number of quota bytes.	
		public var quotaBytesUsed:Number = -1; //	long	The number of quota bytes used.	
		public var quotaBytesUsedInTrash:Number = -1; //	long	The number of quota bytes used by trashed items.	
		public var largestChangeId:Number = -1; //	long	The largest change id.	
		public var remainingChangeIds:Number = -1; //	long	The number of remaining change ids.	
		public var rootFolderId:String = ""//	string	The id of the root folder.	
		public var domainSharingPolicy:String = ""; //	string	The domain sharing policy for the current user.	
		public var importFormats:Array = null ; //[]	list	The allowable import formats.	
				//importFormats[].source	string	The imported file's content type to convert from.	
				//importFormats[].targets[]	list	The possible content types to convert to.	
		public var exportFormats:Array = null ; //	list	The allowable export formats.	
				//exportFormats[].source	string	The content type to convert from.	
				//exportFormats[].targets[]	list	The possible content types to convert to.	
		public var additionalRoleInfo:Array = null ; //[]	list	Additional ACL role info.	
				//additionalRoleInfo[].type	string	The content type for this ACL role info item.	
				//additionalRoleInfo[].roleSets[]	list	The role sets for this role info item.	
				//additionalRoleInfo[].roleSets[].primaryRole	string	The primary role for this role set.	
				//additionalRoleInfo[].roleSets[].additionalRoles[]	list	The list of additional roles for this role set.	
		public var features:Array = null ; //[]	list	List of additional features enabled on this account.	
				//features[].featureName	string	The name of the feature.	
				//features[].featureRate	double	The request limit rate for this feature, in queries per second.	
		public var maxUploadSizes:Array = null ; //[]	list	List of max upload sizes for each file type.	
				//maxUploadSizes[].type	string	The file type.	
				//maxUploadSizes[].size	long	The max upload size for this type.	
		public var permissionId:String = ""; // string	The current user's ID as visible in the permissions collection.	
		public var isCurrentAppInstalled:Boolean = false; //	boolean	A boolean indicating whether the authenticated app is installed by the authenticated user.
				
				
		public function GoogleDriveAbout()
		{
			
		}
		
		
	}
}