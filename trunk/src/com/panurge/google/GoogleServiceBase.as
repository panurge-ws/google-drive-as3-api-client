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
	import com.adobe.net.DynamicURLLoader;
	import com.panurge.google.drive.events.GoogleDriveEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.utils.ObjectUtil;
	
	
	/**
	 * Google Service base class 
	 * @author
	 * 
	 */
	public class GoogleServiceBase extends EventDispatcher
	{
		
		protected var delayedAction:Object;
		
		/**
		 * The IGoogleOAuth2 needed to manage authentication 
		 */
		public var oauth:IGoogleOAuth2;
		
		
		/**
		 *  
		 * @param oauth The IGoogleOAuth2 needed to manage authentication
		 * 
		 */
		public function GoogleServiceBase(oauth:IGoogleOAuth2){
			this.oauth = oauth;
		}
		
		/**
		 * Helper method to call remote service
		 * 
		 * @param url The URL to call
		 * @param method The UrlRequestMethod
		 * @param eventType The event's type to listen
		 * @param data The URLRequest data to send
		 * @param contentType The type of content sent in the call (e.g. "application/json");
		 * @return 
		 * 
		 */
		public function callService(url:String, method:String, eventType:String, data:* = null, contentType:String = ""):DynamicURLLoader
		{
			
			if (!oauth.checkExpireToken()){
				delayedAction = {func:callService, params:arguments}
				oauth.addEventListener(GoogleOAuth2Event.AUTH_SUCCESS, onRefreshtokenComplete);
				oauth.refreshAuthToken();
				return null;
			}
			
			var urlLoader:DynamicURLLoader = new DynamicURLLoader();
			
			var request:URLRequest = oauth.getAuthURLRequest(url);
			request.method = method;
			
			if (data != null){
				request.data = data;
			}
			if (contentType != ""){
				request.contentType = contentType;
			}
			
			urlLoader.eventType = eventType;
			
			addListeners(urlLoader);
			
			urlLoader.load(request);
			
			return urlLoader;
			
		}
		
		
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onRefreshtokenComplete(event:GoogleOAuth2Event):void
		{
			oauth.removeEventListener(GoogleOAuth2Event.REFRESH_TOKEN_COMPLETE, onRefreshtokenComplete);
			if (delayedAction){
				
				var func:Function = delayedAction.func;
				if (delayedAction.params){
					func.apply(null, delayedAction.params);
				}
				else{
					func.call(null);
				}
				
				delayedAction = null;
			}
		}		
		
		/**
		 * 
		 * @param loader
		 * 
		 */
		protected function addListeners(loader:*):void
		{
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpResponseStatus);
		}
		
		/**
		 * 
		 * @param loader
		 * 
		 */
		protected function removeListeners(loader:*):void
		{
			loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpResponseStatus);
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onSecurityError(event:SecurityErrorEvent):void
		{
			var urlLoader:* = event.currentTarget;
			removeListeners(urlLoader);
			trace("onSecurityError", ObjectUtil.toString(event));
			dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.ERROR_EVENT,{code:event.errorID,message:event.toString()}));
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected function onError(event:IOErrorEvent):void
		{
			var urlLoader:* = event.currentTarget;
			removeListeners(urlLoader);
			trace("onError", ObjectUtil.toString(event));
			if (event.currentTarget.data != null){
				try{
					var errorObject:Object = JSON.parse(event.currentTarget.data);
					trace("onError - Code:", errorObject.error.code);
					trace("onError - Message:", errorObject.error.message);
					trace("onError - Errors:", errorObject.error.errors);
					dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.ERROR_EVENT, errorObject.error));
					return;
				}
				catch(e:Error){
					trace("onError", e);
				}
			}
			
			dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.ERROR_EVENT));
		}
		
		protected function onHttpResponseStatus(event:HTTPStatusEvent):void
		{	
			dispatchEvent(event.clone());
		}
		
		protected function onLoadComplete(event:Event):void
		{
			
		}	
		
		
		
		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public function isNotNull(value:*):Boolean
		{
			if (value is String) return value != "";
			else return value != null;
		}
		
		/**
		 * 
		 * @param params
		 * @param otherParams
		 * @return 
		 * 
		 */
		public function buildParams(params:*,otherParams:* = null):Object
		{
			var paramReturn:Object = {};
			
			if (params != null){
				
				if (getQualifiedClassName(params) == "Object") {
					for (var varString:String in params) {
						if (isNotNull(params[varString])){
							if (params[varString] is Array){
								paramReturn[varString] = params[varString];
							}
							else if (typeof(params[varString]) == "object"){
								paramReturn[varString] = buildParams(params[varString]);
							}
							else{
								paramReturn[varString] = params[varString].toString();
							}
						}
					}
					
				}
				else{
					
					var classVars:XML = describeType(params);
					var properties:XMLList = classVars.variable;
					properties += classVars.accessor;
					for each(var varName:* in properties) 
					{	
						
						if (isNotNull(params[varName.@name])){
							
							if (params[varName.@name] is Array){
								paramReturn[varName.@name] = params[varName.@name];
							}
							else if (typeof(params[varName.@name]) == "object"){
								paramReturn[varName.@name] = buildParams(params[varName.@name]);
							}
							else{
								paramReturn[varName.@name] = params[varName.@name].toString();
							}
						}
						//trace();
					}
					
				}
			}
			
			if (otherParams != null){
				buildParams(otherParams, null);
			}
			
			return paramReturn;
			
		}
		
		
	}
}