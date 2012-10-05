package com.panurge.google.drive.services
{
	import com.panurge.google.GoogleServiceBase;
	import com.panurge.google.IGoogleOAuth2;
	import com.panurge.google.drive.events.GoogleDriveEvent;
	
	public class DriveServiceBase extends GoogleServiceBase
	{
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
		public function parseResult(event:*, driveClient:GoogleDriveClient = null):Object
		{
			var urlLoader:* = event.currentTarget;
			
			var resultObject:Object = null;
			var eventToDispatch:GoogleDriveEvent;
			
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
	}
}