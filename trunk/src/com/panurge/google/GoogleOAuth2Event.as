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
	import flash.events.Event;
	
	public class GoogleOAuth2Event extends Event
	{
		
		public static const AUTH_REQUEST_INIT:String = "AUTH_REQUEST_INIT";
		public static const AUTH_REQUEST_COMPLETE:String = "AUTH_REQUEST_COMPLETE";
		public static const AUTH_REQUEST_FAULT:String = "AUTH_REQUEST_FAULT";
		public static const REFRESH_TOKEN_INIT:String = "REFRESH_TOKEN_INIT";
		public static const REFRESH_TOKEN_COMPLETE:String = "REFRESH_TOKEN_COMPLETE";
		public static const REFRESH_TOKEN_FAULT:String = "REFRESH_TOKEN_FAULT";
		public static const AUTH_SUCCESS:String = "AUTH_SUCCESS";
		public static const AUTH_FAULT:String = "AUTH_FAULT";
		
		public var message:String = null;
		public var code:String = null;
			
		public function GoogleOAuth2Event(type:String, code:String = null, message:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{	
			this.code = code;
			this.message = message;
			super(type, bubbles, cancelable);
		}
	}
}