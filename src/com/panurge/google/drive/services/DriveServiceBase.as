package com.panurge.google.drive.services
{
	import com.panurge.google.GoogleServiceBase;
	import com.panurge.google.IGoogleOAuth2;
	import com.panurge.google.drive.events.GoogleDriveEvent;
	
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	
	import mx.utils.ObjectUtil;
	
	public class DriveServiceBase extends GoogleServiceBase
	{
		public var driveClient:GoogleDriveClient;
		
		public function DriveServiceBase(oauth:IGoogleOAuth2)
		{
			super(oauth);
		}
		
		/**
		 * parse the result from an operation
		 * checking if there ar errors
		 * 
		 * @param event
		 * @return 
		 * 
		 */
		public function parseResult(event:*):Object
		{
			var urlLoader:* = event.currentTarget;
			
			var resultObject:Object = null;
			var eventToDispatch:GoogleDriveEvent;
			
			if (urlLoader.data is ByteArray){
				resultObject = urlLoader.data;
				return resultObject;
			}
			
			if (urlLoader.data != null && urlLoader.data != ""){
				// let try catch to avoid JSON casting problems
				try{
					resultObject = JSON.parse(urlLoader.data as String);
				}
				catch(e:Error){}
				
				if (resultObject == null || resultObject.error != undefined){
					eventToDispatch = new GoogleDriveEvent(GoogleDriveEvent.ERROR_EVENT, resultObject == null ? urlLoader.data : resultObject.error);
					
					dispatchEvent(eventToDispatch);
					// dispatch also in client
					if (driveClient){
						driveClient.dispatchEvent(eventToDispatch);
					}
					
					removeListeners(urlLoader); // now we can remove listeners
					return null;
				}
			}
			else{
				
				// geric event not an error
				eventToDispatch = new GoogleDriveEvent(urlLoader.eventType);
				
				dispatchEvent(eventToDispatch);
				// dispatch also in client
				if (driveClient){
					driveClient.dispatchEvent(eventToDispatch);
				}
				
				removeListeners(urlLoader); // now we can remove listeners
				return null;
			}
			
			return resultObject;
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected override function onSecurityError(event:SecurityErrorEvent):void
		{
			var urlLoader:* = event.currentTarget;
			removeListeners(urlLoader);
			trace("onSecurityError", ObjectUtil.toString(event));
			dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.ERROR_EVENT,{code:event.errorID,message:event.toString()}));
			if (driveClient){
				driveClient.dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.ERROR_EVENT,{code:event.errorID,message:event.toString()}));
			}
		}
		
		/**
		 * 
		 * @param event
		 * 
		 */
		protected override function onError(event:IOErrorEvent):void
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
					if (driveClient){
						driveClient.dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.ERROR_EVENT, errorObject.error));
					}
					return;
				}
				catch(e:Error){
					trace("onError", e);
				}
			}
			
			
			
			dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.ERROR_EVENT));
			if (driveClient){
				driveClient.dispatchEvent(new GoogleDriveEvent(GoogleDriveEvent.ERROR_EVENT));
			}
		}
	}
}