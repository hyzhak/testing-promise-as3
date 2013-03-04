package org.hyzhak.promise.unittesting
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class TestingPromiseTest
	{
		
		[Test(async)]
		public function testSimpleFullfilledPromise():void {
			var operation:SimpleAsyncOperation = new SimpleAsyncOperation();
			
			operation.execute(true).then.apply(null, 
				TestingPromise.at(this)
					.by(function(value : *) : void {
						trace("1: onFullfilled", value);
						assertThat(value, equalTo("ok"));
					})
			);
		}
		
		[Test(async)]
		public function testSimpleRejectedPromise():void {
			var operation:SimpleAsyncOperation = new SimpleAsyncOperation();
			operation.execute(false).then.apply(null, 
				TestingPromise.at(this)
					.by( 
						null, 
					function(value : *) : void {
						trace("2: onRejected", value);
						assertThat(value, equalTo("error"));
					}));
		}
	}
}