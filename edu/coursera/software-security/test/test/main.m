//
//  main.m
//  test
//
//  Created by Damon Allison on 10/15/15.
//  Copyright © 2015 Recursive Awesome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "BufferOverflow.h"

int main(int argc, char * argv[]) {

    overflowAuth("auth1");

    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
