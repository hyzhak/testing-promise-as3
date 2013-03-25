package org.hyzhak.promise.unittesting
{
    import org.flexunit.async.Async;
    import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class TestingPromiseTest
	{
		
		[Test(async)]
		public function testSimpleFullfilledPromise():void {
			var operation:SimpleAsyncOperation = new SimpleAsyncOperation();
			
			operation.execute(true).then.apply(null, 
				TestingPromise.at(this)
					.fullfill(function(value : *) : void {
						trace("1: onFullfilled", value);
						assertThat(value, equalTo("ok"));
					})
			);
		}
		
		[Test(async)]
		public function testSimpleRejectedPromise():void {
            org.flexunit.async.Async;

			var operation:SimpleAsyncOperation = new SimpleAsyncOperation();
			operation.execute(false).then.apply(null, 
				TestingPromise.at(this)
					.reject(function(value : *) : void {
						trace("2: onRejected", value);
						assertThat(value, equalTo("error"));
					}));
		}

        [Test(async)]
        public function testSimpleFullfilledPromiseWithThat():void {
            var operation:SimpleAsyncOperation = new SimpleAsyncOperation();

            TestingPromise.fulfills(this, operation.execute(true), function(value:*):void {
                assertThat(value, equalTo("ok"));
            });
        }

        [Test(async)]
        public function testSimpleRejectedPromiseWithThat():void {
            var operation:SimpleAsyncOperation = new SimpleAsyncOperation();

            TestingPromise.rejects(this, operation.execute(false), function(value:*):void {
                assertThat(value, equalTo("error"));
            });
        }
	}
}