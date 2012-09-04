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

package com.panurge.google.drive.utils
{
	public class DateUtils
	{
		public function DateUtils()
		{
		}
		
		/*
		credits: http://www.computus.org/journal/?p=2701
		*/
		public static function parseRFC3339( rfc3339:String ):Date
		{ 
			var datetime:Array    = rfc3339.split("T");
			
			var date:Array     = datetime[0].split("-");
			var year:int    = int(date[0])
			var month:int    = int(date[1]-1)
			var day:int     = int(date[2])
			
			var time:Array     = datetime[1].split(":");
			var hour:int    = int(time[0])
			var minute:int    = int(time[1])
			var second:Number
			
			// parse offset
			var offsetString:String  = time[2];
			var offsetUTC:int
			
			if ( offsetString.charAt(offsetString.length -1) == "Z" )
			{
				// Zulu time indicator
				offsetUTC  = 0;
				second  = parseFloat( offsetString.slice(0,offsetString.length-1) )
			}
			else
			{
				// split off UTC offset
				var a:Array
				if (offsetString.indexOf("+") != -1)
				{
					a = offsetString.split("+")
					offsetUTC = 1
				}
				else if (offsetString.indexOf("-") != -1)
				{
					a = offsetString.split("-")  
					offsetUTC = -1
				}
				else
				{
					throw new Error( "Invalid Format: cannot parse RFC3339 String." )
				}
				
				// set seconds
				second = parseFloat( a[0] )
				
				// parse UTC offset in millisceonds
				var ms:Number = 0
				if ( time[3] )
				{
					ms = parseFloat(a[1]) * 3600000   
					ms += parseFloat(time[3]) * 60000   
				}
				else
				{
					ms = parseFloat(a[1]) * 60000   
				}
				offsetUTC = offsetUTC * ms   
			}
			
			return new Date( Date.UTC( year, month, day, hour, minute, second) + offsetUTC );
		}
	}
}