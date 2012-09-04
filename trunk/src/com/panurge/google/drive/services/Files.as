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
	import com.adobe.net.MimeTypeMap;
	import com.panurge.google.GoogleOAuth2Event;
	import com.panurge.google.GoogleServiceBase;
	import com.panurge.google.IGoogleOAuth2;
	import com.panurge.google.drive.events.GoogleDriveEvent;
	import com.panurge.google.drive.model.GoogleDriveChange;
	import com.panurge.google.drive.model.GoogleDriveChangesList;
	import com.panurge.google.drive.model.GoogleDriveFile;
	import com.panurge.google.drive.model.GoogleDriveFileList;
	import com.panurge.google.drive.model.GoogleDriveParent;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.utils.ObjectUtil;
	
	import com.panurge.google.net.MultipartURLLoader;
	
	
	/**
	 *
	 * Service for Files 
	 * 
	 * @see https://developers.google.com/drive/v2/reference/files
	 *  
	 * @author panurge_ws
	 * 
	 */
	public class Files extends GoogleServiceBase
	{
		
		public var driveClient:GoogleDriveClient;
		
		
		public function Files(oauth:IGoogleOAuth2)
		{
			super(oauth);
		}
		
		
		
		
		/**
		 *
		 * Insert a new file.

			This method supports media upload. Uploaded files must conform to these constraints:<br>
			<br>
			Maximum file size: 10GB<br>
			Accepted Media MIME types: ./.<br>
			<br>
			Note: Apps creating shortcuts with files.insert must specify the MIME type application/vnd.google-apps.drive-sdk.<br>
			<br>
			Apps should specify a file extension in the title property when inserting files with the API. For example, an operation to insert a JPEG file should specify something like "title": "cat.jpg" in the metadata.<br>
			<br>
			Subsequent GET requests include the read-only fileExtension property populated with the extension originally specified in the title property. When a Google Drive user requests to download a file, or when the file is downloaded through the sync client, Drive builds a full filename (with extension) based on the title. In cases where the extension is missing, Google Drive attempts to determine the extension based on the file's MIME type.<br>
		 *  <br>
		 * 
		 *  In the param <code>file</code>, supply a GoogleDriveFile object with the following properties:<br>
			<br>
			Optional Properties<br>
			 <br>
				description	string	A short description of the file.	 writable<br>
				indexableText.text	string	The text to be indexed for this file.	 writable<br>
				labels.hidden	boolean	Whether this file is hidden from the user.	 writable<br>
				labels.restricted	boolean	Whether viewers are prevented from downloading this file.	 writable<br>
				labels.starred	boolean	Whether this file is starred by the user.	 writable<br>
				labels.trashed	boolean	Whether this file has been trashed.	 writable<br>
				labels.viewed	boolean	Whether this file has been viewed by this user.	 writable<br>
				lastViewedByMeDate	datetime	Last time this file was viewed by the user (formatted RFC 3339 timestamp).	 writable<br>
				mimeType	string	The MIME type of the file.	 writable<br>
				modifiedDate	datetime	Last time this file was modified by anyone (formatted RFC 3339 timestamp). This is only mutable on update when the setModifiedDate parameter is set.	 writable<br>
				parents[]	list	Collection of parent folders which contain this file.<br>
									Setting this field will put the file in all of the provided folders. On insert, if no folders are provided, the file will be placed in the default root folder. writable
				title	string	The title of the this file. Used to identify file or folder name.	 writable<br>
			 
		 * 
		 * @param file The data model of the file to insert
		 * @param data The content data of the file. If you want to insert a file with no content, pass a null value.
		 * @param convert Whether to convert this file to the corresponding Google Docs format.
		 * @param ocr Whether to attempt OCR on .jpg, .png, or .gif uploads.
		 * @param ocrLanguage If ocr is true, hints at the language to use. Valid values are ISO 639-1 codes.
		 * @param pinned Whether to pin the head revision of the uploaded file.
		 * @param sourceLanguage The language of the original file to be translated.
		 * @param targetLanguage Target language to translate the file to. If no sourceLanguage is provided, the API will attempt to detect the language.
		 * @param timedTextLanguage The language of the timed text.
		 * @param timedTextTrackName The timed text track name.
		 * @return 
		 * 
		 */
		public function file_insert(
										file:GoogleDriveFile,
										data:ByteArray = null, 
										convert:Boolean = false, 
										ocr:Boolean = false, 
										ocrLanguage:String = "", 
										pinned:Boolean = false, 
										sourceLanguage:String = "", 
										targetLanguage:String = "", 
										timedTextLanguage:String = "",
										timedTextTrackName:String = ""):URLLoader
			
		{
			
			
			
			var optParams:Object = new Object();
			optParams.ocr = ocr;
			optParams.ocrLanguage = ocrLanguage;
			optParams.pinned = pinned;
			optParams.sourceLanguage = sourceLanguage;
			optParams.targetLanguage = targetLanguage;
			optParams.timedTextLanguage = timedTextLanguage;
			optParams.timedTextTrackName = timedTextTrackName;
			
			if (data == null){
				return callService(	"https://www.googleapis.com/drive/v2/files",
					URLRequestMethod.POST,
					GoogleDriveEvent.FILE_INSERT,
					JSON.stringify(driveClient.buildParams(file,optParams)),
					"application/json");
			}
			else{
				
				if (!oauth.checkExpireToken()){
					delayedAction = {func:callService, params:arguments}
					oauth.addEventListener(GoogleOAuth2Event.AUTH_SUCCESS, onRefreshtokenComplete);
					oauth.refreshAuthToken();
					return null; 
				}
				
				var m:MultipartURLLoader = new MultipartURLLoader();
				m.requestHeaders.push(oauth.getAuthURLRequestHeader());
				m.urlMethod = URLRequestMethod.POST;
				
				// try to get the mimetype
				if (file.mimeType == ""){
					var mimeTypeMap:MimeTypeMap = new MimeTypeMap();
					var ext:String = file.title.substr(file.title.lastIndexOf(".")+1, file.title.length);
					file.mimeType = mimeTypeMap.getMimeType(ext);
					file.mimeType = file.mimeType == null ? "application/octet-stream" : file.mimeType;
				}
				
				
				m.addFile(data, '', 'file', file.mimeType);
				
				m.addEventListener(Event.COMPLETE, onInsertFileComplete);
				m.addEventListener(IOErrorEvent.IO_ERROR, onUploadFileIOError); 
				m.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityErrorHandler);
				
				m.addVariable("",JSON.stringify(driveClient.buildParams(file,optParams)));
				
				m.load("https://www.googleapis.com:443/upload/drive/v2/files");
				
				return m.loader;
			}
		}
		
		
		
		
		/**
		 * Updates file metadata and/or content.
		 * 
		 * This method supports media upload. Uploaded files must conform to these constraints:<br>
			<br>
			Maximum file size: 10GB<br>
			Accepted Media MIME types: ./.<br>
			<br>
			
			In the param <code>file</code>, supply a GoogleDriveFile object with the following properties:<br>
			<br>
			Optional Properties<br>
			 <br>
				description	string	A short description of the file.	 writable<br>
				indexableText.text	string	The text to be indexed for this file.	 writable<br>
				labels.hidden	boolean	Whether this file is hidden from the user.	 writable<br>
				labels.restricted	boolean	Whether viewers are prevented from downloading this file.	 writable<br>
				labels.starred	boolean	Whether this file is starred by the user.	 writable<br>
				labels.trashed	boolean	Whether this file has been trashed.	 writable<br>
				labels.viewed	boolean	Whether this file has been viewed by this user.	 writable<br>
				lastViewedByMeDate	datetime	Last time this file was viewed by the user (formatted RFC 3339 timestamp).	 writable<br>
				mimeType	string	The MIME type of the file.	 writable<br>
				modifiedDate	datetime	Last time this file was modified by anyone (formatted RFC 3339 timestamp). This is only mutable on update when the setModifiedDate parameter is set.	 writable<br>
				parents[]	list	Collection of parent folders which contain this file.<br>
									Setting this field will put the file in all of the provided folders. On insert, if no folders are provided, the file will be placed in the default root folder. writable
				title	string	The title of the this file. Used to identify file or folder name.	 writable<br>
			
		 * @param fileId The ID of the file to update.
		 * @param file The data model of the file to insert (<code>id</code> field is required)
		 * @param data The content data of the file. If you want to update a file with no content, pass a null value.
		 * @param convert Whether to convert this file to the corresponding Google Docs format.
		 * @param ocr Whether to attempt OCR on .jpg, .png, or .gif uploads.
		 * @param ocrLanguage If ocr is true, hints at the language to use. Valid values are ISO 639-1 codes.
		 * @param pinned Whether to pin the head revision of the uploaded file.
		 * @param sourceLanguage The language of the original file to be translated.
		 * @param targetLanguage Target language to translate the file to. If no sourceLanguage is provided, the API will attempt to detect the language.
		 * @param timedTextLanguage The language of the timed text.
		 * @param timedTextTrackName The timed text track name.
		 * @return 
		 * 
		 */
		public function file_update(   fileId:String,
									   file:GoogleDriveFile, 
									   data:ByteArray = null, 
									   convert:Boolean = false, 
									   ocr:Boolean = false, 
									   ocrLanguage:String = "", 
									   pinned:Boolean = false, 
									   sourceLanguage:String = "", 
									   targetLanguage:String = "", 
									   timedTextLanguage:String = "",
									   timedTextTrackName:String = ""):URLLoader
			
		{
			
			
			
			var optParams:Object = new Object();
			optParams.ocr = ocr;
			optParams.ocrLanguage = ocrLanguage;
			optParams.pinned = pinned;
			optParams.sourceLanguage = sourceLanguage;
			optParams.targetLanguage = targetLanguage;
			optParams.timedTextLanguage = timedTextLanguage;
			optParams.timedTextTrackName = timedTextTrackName;
			
			if (data == null){
				
				return callService(	"https://www.googleapis.com/drive/v2/files/" + fileId,
					URLRequestMethod.PUT,
					GoogleDriveEvent.FILE_UPDATE,
					JSON.stringify(driveClient.buildParams(file,optParams)),
					"application/json");
			}
			else{
				
				if (!oauth.checkExpireToken()){
					delayedAction = {func:callService, params:arguments}
					oauth.addEventListener(GoogleOAuth2Event.AUTH_SUCCESS, onRefreshtokenComplete);
					oauth.refreshAuthToken();
					return null;
				}
				
				var m:MultipartURLLoader = new MultipartURLLoader();
				m.urlMethod = URLRequestMethod.PUT;
				m.requestHeaders.push(oauth.getAuthURLRequestHeader());
				
				
				// try to get the mimetype
				if (file.mimeType == ""){
					var mimeTypeMap:MimeTypeMap = new MimeTypeMap();
					var ext:String = file.title.substr(file.title.lastIndexOf(".")+1, file.title.length);
					file.mimeType = mimeTypeMap.getMimeType(ext);
					file.mimeType = file.mimeType == null ? "application/octet-stream" : file.mimeType;
				}
				
				m.addFile(data, '', 'file', file.mimeType);
				
				m.addEventListener(Event.COMPLETE, onUpdateFileComplete);
				m.addEventListener(IOErrorEvent.IO_ERROR, onUploadFileIOError); 
				m.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityErrorHandler);
				
				
				
				m.addVariable("",JSON.stringify(driveClient.buildParams(file,optParams)));
				
				m.load("https://www.googleapis.com:443/upload/drive/v2/files/" + fileId);
				
				return m.loader;
			}
			
		}
		
		
		/**
		 * Updates file metadata and/or content. This method supports patch semantics
		 * 
		 * @see https://developers.google.com/drive/performance#patch
		 * 
		 * @param fileId The ID of the file to patch.
		 * @param file The data model of the file to insert (<code>id</code> field is required)
		 * @param convert Whether to convert this file to the corresponding Google Docs format.
		 * @param newRevision Whether a blob upload should create a new revision. If not set or false, the blob data in the current head revision will be replaced. If true, a new blob is created as head revision, and previous revisions are preserved (causing increased use of the user's data storage quota).
		 * @param ocr Whether to attempt OCR on .jpg, .png, or .gif uploads.
		 * @param ocrLanguage If ocr is true, hints at the language to use. Valid values are ISO 639-1 codes.
		 * @param pinned Whether to pin the head revision of the uploaded file.
		 * @param sourceLanguage The language of the original file to be translated.
		 * @param targetLanguage Target language to translate the file to. If no sourceLanguage is provided, the API will attempt to detect the language.
		 * @param timedTextLanguage The language of the timed text.
		 * @param timedTextTrackName The timed text track name.
		 * @return 
		 * 
		 */
		public function file_patch(fileId:String,
			                       file:GoogleDriveFile,
								   convert:Boolean = false, 
								   newRevision:Boolean = false, 
								   ocr:Boolean = false, 
								   ocrLanguage:String = "", 
								   pinned:Boolean = false, 
								   sourceLanguage:String = "", 
								   targetLanguage:String = "", 
								   timedTextLanguage:String = "",
								   timedTextTrackName:String = ""):URLLoader
			
		{
			
			var optParams:Object = new Object();
			optParams.convert = convert;
			optParams.newRevision = newRevision;
			optParams.ocr = ocr;
			optParams.ocrLanguage = ocrLanguage;
			optParams.pinned = pinned;
			optParams.sourceLanguage = sourceLanguage;
			optParams.targetLanguage = targetLanguage;
			optParams.timedTextLanguage = timedTextLanguage;
			optParams.timedTextTrackName = timedTextTrackName;
			
			
			return callService(	"https://www.googleapis.com/drive/v2/files/" + fileId,
				"PATCH",
				GoogleDriveEvent.FILE_PATCH,
				JSON.stringify(driveClient.buildParams(file,optParams)),
				"application/json");
			
			/* TODO understnad in which way we can patch also content
			
			if (data == null){
				
				return callService(	"https://www.googleapis.com/drive/v2/files/" + file.id,
					"PATCH",
					GoogleDriveEvent.FILE_PATCH,
					JSON.stringify(driveClient.buildParams(file,optParams)),
					"application/json");
			
			}
			else{
				
				if (!oauth.checkExpireToken()){
					delayedAction = {func:callService, params:arguments}
					oauth.addEventListener(GoogleOAuth2Event.AUTH_SUCCESS, onRefreshtokenComplete);
					oauth.refreshAuthToken();
					return null;
				}
				
				var m:MultipartURLLoader = new MultipartURLLoader();
				m.urlMethod = "PATCH";
				m.requestHeaders.push(oauth.getAuthURLRequestHeader());
				
				
				// try to get the mimetype
				if (file.mimeType == ""){
					var mimeTypeMap:MimeTypeMap = new MimeTypeMap();
					var ext:String = file.title.substr(file.title.lastIndexOf(".")+1, file.title.length);
					file.mimeType = mimeTypeMap.getMimeType(ext);
					file.mimeType = file.mimeType == null ? "application/octet-stream" : file.mimeType;
				}
				
				m.addFile(data, '', 'file', file.mimeType);
				
				m.addEventListener(Event.COMPLETE, onPatchFileComplete);
				m.addEventListener(IOErrorEvent.IO_ERROR, onUploadFileIOError); 
				m.addEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityErrorHandler);
				
				
				
				m.addVariable("",JSON.stringify(driveClient.buildParams(file,optParams)));
				
				m.load("https://www.googleapis.com:443/upload/drive/v2/files/" + file.id);
				
				return m.loader;
			}
			*/
			
		}
		
		
		
		
		/**
		 * Creates a copy of the specified file.
		 *  
		 * @param fileId The ID of the file to copy.
		 * @param convert Whether to convert this file to the corresponding Google Docs format.
		 * @param ocr Whether to attempt OCR on .jpg, .png, or .gif uploads.
		 * @param ocrLanguage If ocr is true, hints at the language to use. Valid values are ISO 639-1 codes.
		 * @param pinned Whether to pin the head revision of the uploaded file.
		 * @param sourceLanguage The language of the original file to be translated.
		 * @param targetLanguage Target language to translate the file to. If no sourceLanguage is provided, the API will attempt to detect the language.
		 * @param timedTextLanguage The language of the timed text.
		 * @param timedTextTrackName The timed text track name.
		 * @return 
		 * 
		 */
		public function file_copy( fileId:String, 
								   convert:Boolean = false, 
								   ocr:Boolean = false, 
								   ocrLanguage:String = "", 
								   pinned:Boolean = false, 
								   sourceLanguage:String = "", 
								   targetLanguage:String = "", 
								   timedTextLanguage:String = "",
								   timedTextTrackName:String = ""):DynamicURLLoader
			
		{
			
			
			
			var urlLoader:DynamicURLLoader = new DynamicURLLoader();
			
			var optParams:Object = new Object();
			optParams.convert = convert;
			optParams.ocr = ocr;
			optParams.ocrLanguage = ocrLanguage;
			optParams.pinned = pinned;
			optParams.sourceLanguage = sourceLanguage;
			optParams.targetLanguage = targetLanguage;
			optParams.timedTextLanguage = timedTextLanguage;
			optParams.timedTextTrackName = timedTextTrackName;
			
			return callService(	"https://www.googleapis.com/drive/v2/files/" + fileId + "/copy",
				URLRequestMethod.POST,
				GoogleDriveEvent.FILE_COPY,
				JSON.stringify(driveClient.buildParams(optParams)),
				"application/json");
			
		}
		
		
		/*
		Optional Parameters
			maxResults	integer	 Maximum number of files to return.
			pageToken	string	 Page token for files.
			q	string	 Query string for searching files. q = "title contains 'foo'"; https://developers.google.com/drive/search-parameters
		*/
		
		
		/**
		 * Lists the user's files
		 * 
		 * @param maxResults Maximum number of files to return.
		 * @param pageToken Page token for files.
		 * @param q Query string for searching files. See Searching for files (https://developers.google.com/drive/search-parameters) for more information about supported fields and operations.
		 * @return 
		 * 
		 * @see https://developers.google.com/drive/search-parameters
		 */
		public function files_list(maxResults:int = -1, pageToken:String = "", q:String = ""):DynamicURLLoader
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
			
			return callService("https://www.googleapis.com/drive/v2/files/", URLRequestMethod.GET, GoogleDriveEvent.FILE_LIST_COMPLETE, urlVar);
			
		}
		
		
		private var allFiles:Array = [];
		
		
		/**
		 * Convenience method to get all the files list (<code>file_list</code> method returns only a limited number of results).
		 * 
		 *  
		 * @param pageToken Page token for files.
		 * @param q Query string for searching files. See Searching for files (https://developers.google.com/drive/search-parameters) for more information about supported fields and operations.
		 * @return  
		 * 
		 */
		public function files_all_list(pageToken:String = "", q:String = ""):DynamicURLLoader
		{
			
			var urlVar:URLVariables = new  URLVariables();
			if (q != ""){
				urlVar.q = q;
			}
			if (pageToken != ""){
				urlVar.pageToken = pageToken;
			}
			
			if (pageToken == ""){
				allFiles = [];
			}
			
			var handler:Function = function(event:Event):void{
				loader.removeEventListener(Event.COMPLETE,handler);
				var fileList:GoogleDriveFileList = new GoogleDriveFileList();
				fileList.cast(JSON.parse(event.currentTarget.data as String));
				allFiles = allFiles.concat(fileList.items);
				
				if (fileList.nextPageToken != ""){
					files_all_list(fileList.nextPageToken, q);
				}
				else{
					fileList.items = allFiles;	
					dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.FILE_ALL_LIST, fileList));
				}
			};
			
			var loader:DynamicURLLoader = callService("https://www.googleapis.com/drive/v2/files/", URLRequestMethod.GET, GoogleDriveEvent.FILE_ALL_LIST, urlVar);
			loader.addEventListener(Event.COMPLETE,handler);
			
			return loader;
			
		}
		
		/**
		 * Gets a file's metadata by ID. To download a file's content, send an authorized HTTP GET request to the file's downloadUrl
		 *  
		 * @param fileId The ID for the file in question.
		 * @param updateViewedDate Whether to update the view date after successfully retrieving the file. Default value is false.
		 * @return 
		 * 
		 */
		public function file_get(fileId:String, updateViewedDate:Boolean = false):DynamicURLLoader
		{
			var param:URLVariables = new URLVariables();
			param.updateViewedDate = updateViewedDate;
			
			return callService("https://www.googleapis.com/drive/v2/files/" + fileId, URLRequestMethod.GET, GoogleDriveEvent.FILE_METADATA, param);
		}
		
		
		/**
		 * Permanently deletes a file by ID. Skips the trash.
		 *  
		 * @param fileId The ID of the file to delete.
		 * @return 
		 * 
		 */
		public function file_delete(fileId:String):DynamicURLLoader
		{
			return callService("https://www.googleapis.com/drive/v2/files/" + fileId, URLRequestMethod.DELETE, GoogleDriveEvent.FILE_DELETE);
		}
		
		/**
		 * Set the file's updated time to the current server time.
		 *  
		 * @param fileId
		 * @return 
		 * 
		 */
		public function file_touch(fileId:String):DynamicURLLoader
		{
			return callService("https://www.googleapis.com/drive/v2/files/" + fileId + "/touch", URLRequestMethod.POST, GoogleDriveEvent.FILE_TOUCH);
		}
		
		
		/**
		 * Moves a file to the trash.
		 *  
		 * @param fileId The ID of the file to trash.
		 * @return 
		 * 
		 */
		public function file_trash(fileId:String):DynamicURLLoader
		{
			return callService("https://www.googleapis.com/drive/v2/files/" + fileId + "/trash",URLRequestMethod.POST,GoogleDriveEvent.FILE_TRASH);
		}
		
		/**
		 * Restores a file from the trash.
		 *  
		 * @param fileId The ID of the file to untrash.
		 * @return 
		 * 
		 */
		public function file_untrash(fileId:String):DynamicURLLoader
		{
			return callService("https://www.googleapis.com/drive/v2/files/" + fileId + "/untrash",URLRequestMethod.POST,GoogleDriveEvent.FILE_TRASH);
		}
		
		/**
		 * Convenience method to create a folder.
		 * Note that a folder is a file with myme: "application/vnd.google-apps.folder"
		 *  
		 * @param folderName The foldr name 
		 * @param parentIds An array of ids of the parents where you want to create the folder
		 * @return 
		 * 
		 */
		public function folder_create(folderName:String, parentIds:Array = null):DynamicURLLoader
		{
			var file:GoogleDriveFile = new GoogleDriveFile();
			file.title = folderName;
			file.mimeType = GoogleDriveClient.MIMETYPE_GOOGLE_FOLDER;
			if (parentIds != null && parentIds.length > 0){
				file.parents = [];
				for (var i:int = 0; i < parentIds.length; i++) 
				{
					var gParent:GoogleDriveParent = new GoogleDriveParent();
					gParent.id = parentIds[i];
					file.parents.push(gParent);
				}
				
			}
			
			return callService(	"https://www.googleapis.com/drive/v2/files",
				URLRequestMethod.POST,
				GoogleDriveEvent.FOLDER_INSERT,
				JSON.stringify(driveClient.buildParams(file)),
				"application/json");
		}
		
		/**
		 * Downloads a data's file in binary format. 
		 * 
		 *  
		 * @param file The GoogleDriveFile instance to download.
		 * @return 
		 * 
		 * @see file_get
		 */
		public function file_download(file:GoogleDriveFile):DynamicURLLoader
		{
			if (file.downloadUrl == ""){
				// TODO, throw error
				return null;
			}
			var urlLoader:DynamicURLLoader = new DynamicURLLoader();
			var request:URLRequest = oauth.getAuthURLRequest(file.downloadUrl);
			request.method = URLRequestMethod.GET;
			
			urlLoader.eventType = GoogleDriveEvent.FILE_DOWNLOAD;
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			
			addListeners(urlLoader);
			
			urlLoader.load(request);
			
			return urlLoader;
		}
		
		
		
		override protected function onLoadComplete(event:Event):void
		{
			var urlLoader:* = event.currentTarget;
			removeListeners(urlLoader);
			
			trace("onLoadComplete", urlLoader.eventType, urlLoader);
			
			var eventToDispatch:GoogleDriveEvent;
			
			switch(urlLoader.eventType)
			{
				case GoogleDriveEvent.FILE_METADATA:
				case GoogleDriveEvent.FILE_DELETE:
				case GoogleDriveEvent.FILE_COPY:
				case GoogleDriveEvent.FILE_TOUCH:
				case GoogleDriveEvent.FILE_UNTRASH:
				case GoogleDriveEvent.FILE_TRASH:
				case GoogleDriveEvent.FOLDER_INSERT:
				case GoogleDriveEvent.FILE_INSERT:
				case GoogleDriveEvent.FILE_UPDATE:
				case GoogleDriveEvent.FILE_PATCH:
				{	
					if (urlLoader.data != null && urlLoader.data != ""){
						var file:GoogleDriveFile = new GoogleDriveFile();
						file.cast(JSON.parse(urlLoader.data));
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType,file);
					}
					else{
						eventToDispatch = new GoogleDriveEvent(urlLoader.eventType);
					}
					
					break;
				}
					
					
				case GoogleDriveEvent.FILE_DOWNLOAD:
				{	
					eventToDispatch = new GoogleDriveEvent(GoogleDriveEvent.FILE_DOWNLOAD,urlLoader.data);
					break;
				}
					
				case GoogleDriveEvent.FILE_LIST_COMPLETE:
				{	
					var fileList:GoogleDriveFileList = new GoogleDriveFileList();
					fileList.cast(JSON.parse(urlLoader.data as String));
					
					eventToDispatch = new GoogleDriveEvent(GoogleDriveEvent.FILE_LIST_COMPLETE, fileList);
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
		
		
		protected function onPatchFileComplete(event:Event):void
		{
			(event.currentTarget as MultipartURLLoader).removeEventListener(Event.COMPLETE, onPatchFileComplete);
			(event.currentTarget as MultipartURLLoader).removeEventListener(IOErrorEvent.IO_ERROR, onUploadFileIOError); 
			(event.currentTarget as MultipartURLLoader).removeEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityErrorHandler);
			
			var fileInsert:GoogleDriveFile = new GoogleDriveFile();
			fileInsert.cast(JSON.parse(event.currentTarget.loader.data));
			
			dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.FILE_PATCH, fileInsert));
		}
		
		protected function onUpdateFileComplete(event:Event):void
		{
			(event.currentTarget as MultipartURLLoader).removeEventListener(Event.COMPLETE, onUpdateFileComplete);
			(event.currentTarget as MultipartURLLoader).removeEventListener(IOErrorEvent.IO_ERROR, onUploadFileIOError); 
			(event.currentTarget as MultipartURLLoader).removeEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityErrorHandler);
			
			var fileInsert:GoogleDriveFile = new GoogleDriveFile();
			fileInsert.cast(JSON.parse(event.currentTarget.loader.data));
		
			dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.FILE_UPDATE, fileInsert));
		}
		
		
		protected function onInsertFileComplete(event:Event):void
		{
			(event.currentTarget as MultipartURLLoader).removeEventListener(Event.COMPLETE, onInsertFileComplete);
			(event.currentTarget as MultipartURLLoader).removeEventListener(IOErrorEvent.IO_ERROR, onUploadFileIOError); 
			(event.currentTarget as MultipartURLLoader).removeEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityErrorHandler);
			
			var fileInsert:GoogleDriveFile = new GoogleDriveFile();
			fileInsert.cast(JSON.parse(event.currentTarget.loader.data));
			
			dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.FILE_INSERT, fileInsert));
		}
		
		protected function uploadSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			(event.currentTarget as MultipartURLLoader).removeEventListener(Event.COMPLETE, onPatchFileComplete);
			(event.currentTarget as MultipartURLLoader).removeEventListener(Event.COMPLETE, onUpdateFileComplete);
			(event.currentTarget as MultipartURLLoader).removeEventListener(Event.COMPLETE, onInsertFileComplete);
			(event.currentTarget as MultipartURLLoader).removeEventListener(IOErrorEvent.IO_ERROR, onUploadFileIOError); 
			(event.currentTarget as MultipartURLLoader).removeEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityErrorHandler);
			
			trace("uploadSecurityErrorHandler", event.toString());
			
			dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.UPLOAD_ERROR));
		}
		
		protected function onUploadFileIOError(event:IOErrorEvent):void
		{
			(event.currentTarget as MultipartURLLoader).removeEventListener(Event.COMPLETE, onPatchFileComplete);
			(event.currentTarget as MultipartURLLoader).removeEventListener(Event.COMPLETE, onUpdateFileComplete);
			(event.currentTarget as MultipartURLLoader).removeEventListener(Event.COMPLETE, onInsertFileComplete);
			(event.currentTarget as MultipartURLLoader).removeEventListener(IOErrorEvent.IO_ERROR, onUploadFileIOError); 
			(event.currentTarget as MultipartURLLoader).removeEventListener(SecurityErrorEvent.SECURITY_ERROR, uploadSecurityErrorHandler);
			
			trace("onUploadFileIOError", event.toString());
			
			dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.UPLOAD_ERROR));
		}

	}
}