RACifying Non-Reactive Code by Dave Lee
https://www.youtube.com/watch?v=sek0ohbboNU&index=3&list=PL0lo9MOBetEEXnrrP5pwZxSkGvaDBGdOC

Non-RAC code has the following patterns that can be "RACified".

* Blocks
* Delegates
* Notifications
* Errors
* Target-Action
* KVO (RACObserve)
* Method Overriding (rac_signalForSelector)


* Don't use RACSubject.



// Blocks -> Signal

// Groups code that happens on subscriptions, returns a single value when block
// executes. defer is a general pattern to turn a function into a signal.
//
// This can be used to enclose a long-running function into an
// async signal.

[RACSignal defer:^ {
  // Test for sending a value and completing
  return [RACSignal return:@(arc4random())];
}];

// The same thing as above can be done (more explicitly)
// with createSignal

[RACSignal createSignal:^(id(<RACSubscriber> subscriber) {
  // Perform per-subscription side effects.
  [subscription sendNext:@(arc4random())];
  [subscription sendCompleted];
  return nil;
}];

// Blocks -> Signal

// AFNetworking Example:

[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
  [manager GET:URLString parameters:params
    success:^(AFHTTPRequestOperation *op, id response) {
      [subscriber sendNext:response];
      [subscriber sendCompleted];
    }
    failure:^(AFHTTPRequestOperation *op, NSError *e) {
      [subscriber:sendError:e];
    }];
}];

// Using disposables w/ operations to cancel

[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
  NSOperation *operation = [manager GET:URLString parameters:params
    success:^(AFHTTPRequestOperation *op, id response) {
      [subscriber sendNext:response];
      [subscriber sendCompleted];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
      [subscriber sendError:e];
    }];
  return [RACDisposable disposableWithBlock:^ {
    [operation cancel];
  }];
}];


// Core Data : switchToLatest on a search request : automatically cancel old requests.

[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
  RACDisposable *disposable = [RACDisposable new];

  [managedObjectContext performBlock:^ {
    if (disposable.disposed) return;

    NSError *error;
    NSArray *results = [moc performFetch:fetchRequest error:&error];

    if (results != nil) {
      [subscriber sendNext:results];
      [subscriber sendCompleted];
    } else {
      [subscriber sendError:error];
    }
  }];
  return disposable;
}];


// Delegates : creating a signal version of a delegate.

// Shows the general pattern of wrapping delegate callbacks into
// signals. Also how to perform side-effect actions based on the
// subscriber count. In this example, CL is turned on when the
// first subscriber subscribes and turned off after all subscribers
// have unsubscribed.
//
// Notice we are setting `self` as the CL delegate but the
// delegate methods are not implemented - rather subscribed
// to via rac_signalForSelector. This translates
// delegate callbacks into signal values.

// reduceEach is like map. In this case, we use it to return only
// the values in the tuple that matter (the locations / error object).

// flattenMap takes a value and creates a signal from it.

CLLocationManager *locationManager = ...
locationManager.delegate = self; //
static volatile int32_t subscriberCount = 0;

[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
  RACSignal *locations = [[self rac_signalForSeletor:(@selector(...didUpdateLocations:)
    fromProtocol:@protocol(CLLocationManagerDelegate)]
    reduceEach^(id _, NSArray *locations) {
      return locations;
    }];

  RACSignal *error = [[self rac_signalForSeletor:(@selector(...didFailWithError:)
    fromProtocol:@protocol(CLLocationManagerDelegate)]
    reduceEach^(id _, NSError *error) {
      return error;
    }]
    filter:^BOOL (NSError *error) {
      // Documentation says CL will keep trying after kCLErrorLocationUnknown
      return error.code != kCLErrorLocationUnknown;
    }]
    flattenMap:^(NSError *error){
      return [RACSignal error:error]; // create a new signal that will send error.
    }];

    RACDisposable *disposable = [[RACSignal
      merge:@[ locations, error ]]
      subscribe:subscriber];

    // manage side effects if you have multiple subscribers
    if (OSAtomicIncrement32(&subscriberCount) == 1) {
      [locationManager startUpdatingLocation];
    } else {
      [subscriber sendNext:locationManager.location];
    }

    return [RACDisposable disposableWithBlock:^{
      [disposable dispose];
      if (OSAtomicDecrement32(&subscriberCount) == 0) {
        [locationManager stopUpdateLocation];
      }
    }];
}];



// KVO

RACSignal *isReachable = [RACObserve(reachabilityManager, networkReachabilityStatus)
  map:^(NSNumber *networkReachabilityStatus) {
    switch (networkReachabilityStatus.intValue) {
      case AFNetworkReachabilityStatusReachableViaWWAN:
      case AFNetworkReachabilityStatusReachableViaWiFi:
        return @YES;
    }
    return @NO;
  }];

// Notifications

RACSignal *isForeground = [RACSignal merge:@[
  [[defaultCenter rac_addObserverForName:WillEnterForeground ...]
    mapReplace:@YES]
  [[defaultCenter rac_addObserverForName:DidEnterBackground ...]
    mapReplace:@NO]
]];


// Listens to the foreground. When isForeground == @YES, sends values from
// the "didBecomeActive" signal. This would allow your VM to *not* bind to
// the
RACSignal *hasLaunchedActive = [RAC]
