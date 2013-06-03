<a href="https://github.com/promises-aplus/promises-spec"><img src="http://promises-aplus.github.com/promises-spec/assets/logo-small.png" align="right" /></a>

Testing promise-as3
===================

Utility to testing as3 async functionality that based on [CodeCatalyst's Promises as3](https://github.com/CodeCatalyst/promise-as3) (implementation of [Promise/A+ specification](https://github.com/promises-aplus/promises-spec))

# API

## Tested API

Library on promises like this:

```actionscript

public function process(args:Boolean):void {
	var operation:SimpleAsyncOperation = new SimpleAsyncOperation();	
	operation.execute(args)
		.then(function(value:*) : void {
			trace("onFullfilled", value);
		}, function(value:*) : void {
			trace("onRejected", value);
		});
}

```

## Testing

We can use such unittesting:

```actionscript

[Test(async)]
public function testLiteFullfilledPromiseWithThat():void {
    var operation:SimpleAsyncOperation = new SimpleAsyncOperation();
    TestingPromise.fulfills(this, operation.execute(true));
}

[Test(async)]
public function testLiteRejectedPromiseWithThat():void {
    var operation:SimpleAsyncOperation = new SimpleAsyncOperation();
    TestingPromise.rejects(this, operation.execute(false));
}

//end-point style

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

//Then-style

[Test(async)]
public function testSimpleFullfilledPromise():void {
	var operation:SimpleAsyncOperation = new SimpleAsyncOperation();
	
	operation.execute(true).then.apply(null, 
		TestingPromise.at(this)
			.fullfill(function(value : *) : void {
				assertThat(value, equalTo("ok"));
			})
	);
}

[Test(async)]
public function testSimpleRejectedPromise():void {
	var operation:SimpleAsyncOperation = new SimpleAsyncOperation();
	operation.execute(false).then.apply(null, 
		TestingPromise.at(this)
			.reject(function(value : *) : void {
				assertThat(value, equalTo("error"));
			}));
}
```
