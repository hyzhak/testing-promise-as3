package org.hyzhak.promise.unittesting
{
	import com.codecatalyst.promise.Deferred;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class SimpleAsyncIterator
	{
		private var _deferred : Deferred;
		
		private var _fullfilled : Boolean;
		private var _timer:Timer;
		
		public function SimpleAsyncIterator(deferred : Deferred, fullfilled : Boolean)
		{
			_deferred = deferred;
			_fullfilled = fullfilled;
			
			_timer = new Timer(1000, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			_timer.start();
		}
		
		protected function onTimerComplete(event:TimerEvent):void
		{
			if (_fullfilled) {
				_deferred.resolve("ok");
			} else {
				_deferred.reject("error");				
			}
		}
	}
}