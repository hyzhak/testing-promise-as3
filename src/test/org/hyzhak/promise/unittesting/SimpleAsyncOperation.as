package org.hyzhak.promise.unittesting
{
	import com.codecatalyst.promise.Deferred;
	import com.codecatalyst.promise.Promise;

	public class SimpleAsyncOperation
	{
		private var _iterators:Vector.<SimpleAsyncIterator> = new Vector.<SimpleAsyncIterator>();  
		
		public function execute( fullfilled : Boolean) : Promise {
			var deferred:Deferred = new Deferred();
			var promise:Promise = deferred.promise;
			
			var iterator:SimpleAsyncIterator = new SimpleAsyncIterator(deferred, fullfilled);			
			_iterators.push(iterator);
			
			return promise;
		}
		
	}
}