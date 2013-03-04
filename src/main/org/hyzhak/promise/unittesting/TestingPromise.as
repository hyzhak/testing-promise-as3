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
		
		public function fullfill(fullfilledCallback:Function, timeout:Number = 1500) : Array {
			if(fullfilledCallback != null) {
				_fullfilledCallback = fullfilledCallback;
				addEventListener(ASYNC_FULL_FILLED_EVENT, Async.asyncHandler(_testCase, fullfilledAsyncEventHandler, timeout));				
			}
			
			_rejectedCallback = null;
			
			return [fullfilledAsyncCallbackHandler, rejectedAsyncCallbackHandler];
		}
		
		public function reject(rejectedCallback: Function = null, passThroughArgs:Array = null, timeout:Number = 1500) : Array {
			_fullfilledCallback = null;
			
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
			_fullfilledCallback.apply(null, _callbackArgs);
		}
		
		private function fullfilledAsyncCallbackHandler(...args:Array):void {
			_callbackArgs = args;
			if (_fullfilledCallback) {
				dispatchEvent(new Event(ASYNC_FULL_FILLED_EVENT));           				
			} else {
				throw new Error("fullfilled");
			}
		}
		
		private function rejectedAsyncEventHandler(ev:Event, flexUnitPassThroughArgs:Object = null):void {
			_rejectedCallback.apply(null, _callbackArgs);
		}
		
		private function rejectedAsyncCallbackHandler(...args:Array):void {
			_callbackArgs = args;
			if (_rejectedCallback) {
				dispatchEvent(new Event(ASYNC_REJECTED_EVENT));
			} else {
				throw new Error("rejected");
			}
		}
	}
}