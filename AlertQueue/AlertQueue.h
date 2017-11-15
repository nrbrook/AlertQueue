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

@end

@interface AlertQueue : NSObject

@property(nonatomic, readonly, nonnull) NSArray<AlertQueueAlertController *> *queuedAlerts;
@property(nonatomic, readonly, nullable) AlertQueueAlertController *displayedAlert;
@property(nonatomic, strong, nonnull) NSMutableArray *presented;

+ (nonnull instancetype)sharedQueue;

- (void)displayAlert:(nonnull AlertQueueAlertController *)alert userInfo:(nullable NSDictionary *)userInfo;

- (void)cancelAlert:(nonnull AlertQueueAlertController *)alert;

@end

@protocol AlertQueueAlertControllerDelegate <NSObject>

- (void)alertDisplayed:(nonnull AlertQueueAlertController *)alertItem;
- (void)alertDismissed:(nonnull AlertQueueAlertController *)alertItem;

@end
