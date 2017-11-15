//
//  AlertQueue.h
//  LifeStyleLock
//
//  Created by Nick Brook on 03/02/2017.
//  Copyright © 2017 LifeStyleLock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertQueueAlertControllerDelegate;

@interface AlertQueueAlertController : UIAlertController

@property(nonatomic, weak, nullable) id<AlertQueueAlertControllerDelegate> delegate;
@property(nonatomic, readonly, nullable) NSDictionary * userInfo;
@property(nonatomic, weak, readonly, nullable) UIViewController *presentingController;

@end

@interface AlertQueue : NSObject

@property(nonatomic, readonly, nonnull) NSArray<AlertQueueAlertController *> *queuedAlerts;
@property(nonatomic, readonly, nullable) AlertQueueAlertController *displayedAlert;

+ (nonnull instancetype)sharedQueue;

- (void)displayAlert:(nonnull AlertQueueAlertController *)alert userInfo:(nullable NSDictionary *)userInfo;

- (void)displayAlert:(nonnull AlertQueueAlertController *)alert fromController:(nullable UIViewController *)viewController userInfo:(nullable NSDictionary *)userInfo;

- (void)cancelAlert:(nonnull AlertQueueAlertController *)alert;

- (void)invalidateAllAlertsFromController:(nonnull UIViewController *)controller;

@end

@protocol AlertQueueAlertControllerDelegate <NSObject>

- (void)alertDisplayed:(nonnull AlertQueueAlertController *)alertItem;
- (void)alertDismissed:(nonnull AlertQueueAlertController *)alertItem;

@end
