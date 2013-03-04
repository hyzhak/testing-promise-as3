package org.hyzhak.promise.unittesting
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.flexunit.async.Async;
	
	/**
	 * Based on
	 * http://www.betriebsraum.de/blog/2010/07/20/asynchronous-callback-functions-in-flexunit/
	 * 
	 */
	
	public class TestingPromise extends EventDispatcher
	{
		public static const ASYNC_FULL_FILLED_EVENT:String = "asyncFullfilledEvent";
		public static const ASYNC_REJECTED_EVENT:String = "asyncRejectedEvent";
		
		private var _testCase:Object;
		private var _fullfilledCallback:Function;
		private var _rejectedCallback:Function;
		private var _passThroughArgs:Array;
		private var _callbackArgs:Array;
		
		public static function at(testCase:Object) : TestingPromise { 
			return new TestingPromise(testCase);
		}
		
		public function by(fullfilledCallback:Function, rejectedCallback: Function = null, passThroughArgs:Array = null, timeout:Number = 1500) : Array {
			if(fullfilledCallback != null) {
				_fullfilledCallback = fullfilledCallback;
				addEventListener(ASYNC_FULL_FILLED_EVENT, Async.asyncHandler(_testCase, fullfilledAsyncEventHandler, timeout));				
			}
			
			if (rejectedCallback != null) {
				_rejectedCallback = rejectedCallback;
				addEventListener(ASYNC_REJECTED_EVENT, Async.asyncHandler(_testCase, rejectedAsyncEventHandler, timeout));				
			}
			
			return [fullfilledAsyncCallbackHandler, rejectedAsyncCallbackHandler];
		}
		
		public function TestingPromise(testCase:Object) {
			_testCase = testCase;
		}
		
		private function fullfilledAsyncEventHandler(ev:Event, flexUnitPassThroughArgs:Object = null):void {
			if (_passThroughArgs) {
				_callbackArgs = _callbackArgs.concat(_passThroughArgs);
			}
			_fullfilledCallback.apply(null, _callbackArgs);
		}
		
		private function fullfilledAsyncCallbackHandler(...args:Array):void {
			_callbackArgs = args;
			dispatchEvent(new Event(ASYNC_FULL_FILLED_EVENT));            
		}
		
		private function rejectedAsyncEventHandler(ev:Event, flexUnitPassThroughArgs:Object = null):void {
			if (_passThroughArgs) {
				_callbackArgs = _callbackArgs.concat(_passThroughArgs);
			}
			_rejectedCallback.apply(null, _callbackArgs);
		}
		
		private function rejectedAsyncCallbackHandler(...args:Array):void {
			_callbackArgs = args;
			dispatchEvent(new Event(ASYNC_REJECTED_EVENT));            
		}
	}
}