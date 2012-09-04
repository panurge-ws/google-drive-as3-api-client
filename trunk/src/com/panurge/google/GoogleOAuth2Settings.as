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

package com.panurge.google
{
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.registerClassAlias;

	/**
	 * Utility class to store locally the outh tokens.
	 * In next releases, we'll provide an encryption mode.
	 * 
	 * @author aboschini
	 * 
	 */
	public class GoogleOAuth2Settings
	{
		
		public static var accessToken:String = "";	
		public var _accessToken:String = "";	
		
		public static var refreshToken:String = "";	
		public var _refreshToken:String = "";	
		
		public static var tokenExpireTime:Number = 0;	
		public var _tokenExpireTime:Number = 0;	
		
		private static var classRegistered:Boolean = false;
		
		public static var loaded:Boolean = false;
		
		public function GoogleOAuth2Settings()
		{
			
		}
		
		public static function save():void
		{	
			if (!classRegistered){
				registerClasses();
			}
			var file:File = File.applicationStorageDirectory.resolvePath("DriveGoogleOAuth2Settings.data");
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.WRITE); 
			fileStream.writeObject(getInstanceValuesFromStatic());
			fileStream.close();
		}
		
		private static function registerClasses():void
		{	
			registerClassAlias("GoogleOAuth2Settings", GoogleOAuth2Settings);
			classRegistered = true;
		}
		
		public static function load():void
		{
			if (!classRegistered){
				registerClasses();
			}
			var file:File = File.applicationStorageDirectory.resolvePath("DriveGoogleOAuth2Settings.data");
			if (file.exists){
				var fileStream:FileStream = new FileStream();
				fileStream.open(file,FileMode.READ);
				var appSett:GoogleOAuth2Settings = fileStream.readObject();
				fileStream.close();
				setStaticFromObject(appSett);
			}
			
			loaded = true;
			
		}
		
		public static function reset():void
		{
			
			var file:File = File.applicationStorageDirectory.resolvePath("DriveGoogleOAuth2Settings.data");
			if (file.exists){
				file.deleteFile();
				accessToken = "";
				refreshToken = "";
				tokenExpireTime = -1;
			}
			
			loaded = false;
			
		}
		
		private static function getInstanceValuesFromStatic():GoogleOAuth2Settings
		{
			var appSett:GoogleOAuth2Settings  = new GoogleOAuth2Settings();
			appSett._accessToken = GoogleOAuth2Settings.accessToken;
			appSett._refreshToken = GoogleOAuth2Settings.refreshToken;
			appSett._tokenExpireTime = GoogleOAuth2Settings.tokenExpireTime;
			
			return appSett;
		}
		
		private static function setStaticFromObject(appSett:GoogleOAuth2Settings):void
		{
			GoogleOAuth2Settings.accessToken = appSett._accessToken;
			GoogleOAuth2Settings.refreshToken = appSett._refreshToken;
			GoogleOAuth2Settings.tokenExpireTime = appSett._tokenExpireTime;
		}
		
		
	}
}