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
	import com.adobe.protocols.oauth2.OAuth2;
	import com.adobe.protocols.oauth2.event.GetAccessTokenEvent;
	import com.adobe.protocols.oauth2.event.RefreshAccessTokenEvent;
	import com.adobe.protocols.oauth2.grant.AuthorizationCodeGrant;
	import com.adobe.protocols.oauth2.grant.IGrantType;
	import com.panurge.google.drive.events.GoogleDriveEvent;
	import com.panurge.google.drive.services.GoogleDriveClient;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	
	import mx.utils.ObjectUtil;
	
	import org.as3commons.logging.setup.LogSetupLevel;
	
	/**
	 * Class to provide OAuth2 authentication.
	 * 
	 * 
	 * <pre>
	 * <code>
	 * 
	 * var oAuth:GoogleOAuth2 = new GoogleOAuth2();
	   oAuth.CLIENT_ID = YOUR_CLIENT_ID;
	   oAuth.CLIENT_SECRET = YOUR_CLIENT_SECRET;
	   oAuth.REDIRECT_URI = "http://www.yoursite.com/";
	   oAuth.SCOPES = "https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile";
	   oAuth.manageSession = true;
				
	   var driveClient:GoogleDriveClient = new GoogleDriveClient(oAuth);
	   driveClient.addEventListener(GoogleDriveEvent.ERROR_EVENT, onApiError);
	   driveClient.addEventListener(GoogleDriveEvent.UPLOAD_ERROR, onApiError);
				
	   var stageWebView:StageWebView = new StageWebView();
	   stageWebView.viewPort = new Rectangle(0,0,400,400);
				
	   oAuth.stageWebView = stageWebView;
	   oAuth.addEventListener(GoogleOAuth2Event.AUTH_REQUEST_INIT, onAuthRequestInit);
	   oAuth.addEventListener(GoogleOAuth2Event.AUTH_FAULT, onAuthFault);
	   oAuth.addEventListener(GoogleOAuth2Event.AUTH_SUCCESS, onAuthSuccess);
	   oAuth.init();		
	
	 * 
	 * </code>
	 * </pre>
	 *  
	 * @author 
	 * 
	 */
	public class GoogleOAuth2 extends EventDispatcher implements IGoogleOAuth2
	{
		
		/**
		 * Your client ID 
		 */
		public var CLIENT_ID:String = "";
		/**
		 * Your client secret 
		 */
		public var CLIENT_SECRET:String = "";
		/**
		 * The redirect URL 
		 */
		public var REDIRECT_URI:String = "";
		/**
		 * Your desired scopes 
		 */
		public var SCOPES:String = "";
		
		
		/**
		 * The refresh token 
		 */
		public var refreshToken:String = "";
		
		/**
		 * The access token 
		 */
		public var accessToken:String = "";
		/**
		 * The timestamp (in ms) when the token will expire. 
		 */
		public var tokenExpireTime:Number = -1;
		
		/**
		 * Setting to true (default), the class will manage
		 * the session and access token internally.
		 * Setting to false, no session management will occur
		 * and the end developer must save the session manually
		 * and pass to the class in <code>refreshToken</code>, 
		 * <code>accessToken</code>, <code>tokenExpireTime</code> parameters
		 *
		 */
		public var manageSession:Boolean = true;
		
		/**
		 * The StageWebView used to prompt the login/aouth page 
		 */
		public var stageWebView:StageWebView;
		
		
		
		
		public function GoogleOAuth2(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		/**
		 * Initialize the class. 
		 * After you have set all the parameters, you can simply call this method to start the the oauth process. 
		 * 
		 */
		public function init():void
		{
			if (manageSession) {
				if(!GoogleOAuth2Settings.loaded) GoogleOAuth2Settings.load();
				accessToken = accessToken == "" ? GoogleOAuth2Settings.accessToken : accessToken;
				refreshToken = refreshToken == "" ? GoogleOAuth2Settings.refreshToken : refreshToken;
				tokenExpireTime = tokenExpireTime == -1 ? GoogleOAuth2Settings.tokenExpireTime : tokenExpireTime;
			}
			
			if (accessToken == "" || refreshToken == "" || refreshToken == null){
				requestToken();
			}
			else{
				refreshAuthToken();
			}
		}
		
		/**
		 * Request the OAuth token 
		 * 
		 */
		public function requestToken():void
		{
			
			trace("requestToken");
			
			var oauth2:OAuth2 = new OAuth2("https://accounts.google.com/o/oauth2/auth", "https://accounts.google.com/o/oauth2/token", LogSetupLevel.ALL);
			var grant:IGrantType = new AuthorizationCodeGrant(stageWebView, // the StageWebView object for which to display the user consent screen
				CLIENT_ID,          // your client ID
				CLIENT_SECRET,      // your client secret
				REDIRECT_URI,       // your redirect URI
				SCOPES,              // (optional) your scope
				"INSERT_STATE_HERE");// (optional) your state
			
			// make the call
			dispatchEvent(new GoogleOAuth2Event(GoogleOAuth2Event.AUTH_REQUEST_INIT));
			
			oauth2.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);
			oauth2.getAccessToken(grant);
		}
		
		protected function onGetAccessToken(getAccessTokenEvent:GetAccessTokenEvent):void
		{
			if (getAccessTokenEvent.errorCode == null && getAccessTokenEvent.errorMessage == null)
			{
				// success!
				trace("Your access token value is: " + getAccessTokenEvent.accessToken);
				trace(ObjectUtil.toString(getAccessTokenEvent));
				
				accessToken = getAccessTokenEvent.accessToken;
				refreshToken = getAccessTokenEvent.refreshToken;
				tokenExpireTime = new Date().time + (getAccessTokenEvent.expiresIn * 1000);
				
				if (manageSession){
				
					GoogleOAuth2Settings.accessToken = accessToken;
					GoogleOAuth2Settings.refreshToken = refreshToken;
					GoogleOAuth2Settings.tokenExpireTime = tokenExpireTime;
					GoogleOAuth2Settings.save();
				
				}

				dispatchEvent(new GoogleOAuth2Event(GoogleOAuth2Event.AUTH_REQUEST_COMPLETE)); 
				dispatchEvent(new GoogleOAuth2Event(GoogleOAuth2Event.AUTH_SUCCESS)); 
				
			}
			else
			{
				
				
				dispatchEvent(new GoogleOAuth2Event(GoogleOAuth2Event.AUTH_REQUEST_FAULT, getAccessTokenEvent.errorCode, getAccessTokenEvent.errorMessage)); 
				dispatchEvent(new GoogleOAuth2Event(GoogleOAuth2Event.AUTH_FAULT, getAccessTokenEvent.errorCode, getAccessTokenEvent.errorMessage)); 
			}
		}		
		
		/**
		 * Check if the current refresh token is expired
		 *  
		 * @return 
		 * 
		 */
		public function checkExpireToken():Boolean
		{ 
			
			if (new Date().time > tokenExpireTime-(1000*60)){
				return false;
			}
			return true;
		}
		
		
		/**
		 * Refresh a token 
		 * 
		 */
		public function refreshAuthToken():void
		{
			//trace("refreshToken", refreshToken);
			
			dispatchEvent(new GoogleOAuth2Event(GoogleOAuth2Event.REFRESH_TOKEN_INIT));
			
			var oauth2:OAuth2 = new OAuth2("https://accounts.google.com/o/oauth2/auth", "https://accounts.google.com/o/oauth2/token", LogSetupLevel.ALL);
			oauth2.addEventListener(RefreshAccessTokenEvent.TYPE, onRefreshTokenSuccess);
			oauth2.refreshAccessToken(refreshToken, CLIENT_ID, CLIENT_SECRET, SCOPES);
		}
		
		protected function onRefreshTokenSuccess(event:RefreshAccessTokenEvent):void
		{
			
			trace("onRefreshTokenSuccess", ObjectUtil.toString(event));
			
			if (event.errorCode == null && event.errorMessage == null)
			{
				
				
				accessToken = event.accessToken;
				tokenExpireTime = new Date().time + (event.expiresIn * 1000);
				
				if (manageSession){
					
					GoogleOAuth2Settings.accessToken = accessToken;
					GoogleOAuth2Settings.tokenExpireTime = tokenExpireTime;
					GoogleOAuth2Settings.save();
					
				}
				
				dispatchEvent(new GoogleOAuth2Event(GoogleOAuth2Event.REFRESH_TOKEN_COMPLETE));
				
				dispatchEvent(new GoogleOAuth2Event(GoogleOAuth2Event.AUTH_SUCCESS));
				
			}
			else{
				// TODO fault login what to do, reset local credentials?
				dispatchEvent(new GoogleOAuth2Event(GoogleOAuth2Event.AUTH_REQUEST_FAULT, event.errorCode, event.errorMessage));
				dispatchEvent(new GoogleOAuth2Event(GoogleOAuth2Event.AUTH_FAULT, event.errorCode, event.errorMessage));
			}
			
		}
		
		/**
		 * Return a URLRequest with authenticated headers
		 *  
		 * @param url
		 * @param params
		 * @param method
		 * @return 
		 * 
		 */
		public function getAuthURLRequest(url:String, params:* = null, method:String = "GET"):URLRequest
		{
			var urlReq:URLRequest = new URLRequest(url);
			urlReq.requestHeaders.push(getAuthURLRequestHeader());
			urlReq.method = method;
			
			//trace("getAuthURLRequest", ObjectUtil.toString(urlReq.requestHeaders));
			
			return urlReq;
		}
		
		/**
		 * Returns a URLRequestHeader with authenticated tokens
		 * @return 
		 * 
		 */
		public function getAuthURLRequestHeader():URLRequestHeader
		{
			var authHeader:URLRequestHeader = new URLRequestHeader("Authorization", "OAuth " + accessToken);
			return authHeader;
		}
	}
}