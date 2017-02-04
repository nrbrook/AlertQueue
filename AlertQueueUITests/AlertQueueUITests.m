//
//  AlertQueueUITests.m
//  AlertQueueUITests
//
//  Created by Nick Brook on 03/02/2017.
//  Copyright © 2017 Nick Brook. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AlertQueue.h"

@interface AlertQueueUITests : XCTestCase

@end

@implementation AlertQueueUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAlertView {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"alert view test"] tap];
    [app.alerts[@"av"].buttons[@"Cancel"] tap];
    [app.alerts[@"Test1"].buttons[@"OK"] tap];
    
}

- (void)testTwoAlerts {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"two alerts"] tap];
    [app.alerts[@"Test1"].buttons[@"OK"] tap];
    [app.alerts[@"Test2"].buttons[@"OK"] tap];
    
}

- (void)testCancelDisplayed {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"cancel displayed"] tap];
    [NSThread sleepForTimeInterval:1.1];
    [app.alerts[@"Test2"].buttons[@"OK"] tap];
    
}

- (void)testCancelQueued {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"cancel queued"] tap];
    [NSThread sleepForTimeInterval:1.1];
    [app.alerts[@"Test1"].buttons[@"OK"] tap];
    
}

@end
