package org.hyzhak.promise.unittesting
{
    import com.codecatalyst.promise.Promise;

    import flash.events.Event;
	import flash.events.EventDispatcher;
    import flash.utils.getDefinitionByName;

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
        private static var Async:Object;
//        private static var Async:Object = getDefinitionByName('org.flexunit.async.Async');

        public static function fulfills(testCase:Object, promise: Promise, handler:Function, timeout:Number = 1500) : void {
            var dispatcher:TestingPromise = new TestingPromise(testCase);
            promise.then.apply(null, dispatcher.fullfill(handler, timeout));
        }

        public static function rejects(testCase:Object, promise: Promise, handler:Function, timeout:Number = 1500) : void {
            var dispatcher:TestingPromise = new TestingPromise(testCase);
            promise.then.apply(null, dispatcher.reject(handler, timeout));
        }

        public static function at(testCase:Object) : TestingPromise {
            return new TestingPromise(testCase);
		}

        public function TestingPromise(testCase:Object) {
            _testCase = testCase;
            Async = getDefinitionByName('org.flexunit.async.Async');
            if (Async == null) {
                throw new Error("Need to import org.flexunit.async.Async, by adding: \"private var async:Async;\" to your unittests.");
            }
        }
		
		public function fullfill(fullfilledCallback:Function, timeout:Number = 1500) : Array {
			if(fullfilledCallback != null) {
				_fullfilledCallback = fullfilledCallback;
				addEventListener(ASYNC_FULL_FILLED_EVENT, Async.asyncHandler(_testCase, fullfilledAsyncEventHandler, timeout));				
			}
			
			_rejectedCallback = null;
			
			return [fullfilledAsyncCallbackHandler, rejectedAsyncCallbackHandler];
		}
		
		public function reject(rejectedCallback: Function = null, timeout:Number = 1500) : Array {
			_fullfilledCallback = null;
			
			if (rejectedCallback != null) {
				_rejectedCallback = rejectedCallback;
				addEventListener(ASYNC_REJECTED_EVENT, Async.asyncHandler(_testCase, rejectedAsyncEventHandler, timeout));				
			}
			
			return [fullfilledAsyncCallbackHandler, rejectedAsyncCallbackHandler];
		}
		
		private function fullfilledAsyncEventHandler(ev:Event, flexUnitPassThroughArgs:Object = null):void {
			_fullfilledCallback.apply(null, _callbackArgs);
		}
		
		private function fullfilledAsyncCallbackHandler(...args:Array):void {
			_callbackArgs = args;
			if (_fullfilledCallback != null) {
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
			if (_rejectedCallback != null) {
				dispatchEvent(new Event(ASYNC_REJECTED_EVENT));
			} else {
				throw new Error("rejected");
			}
		}
	}
}