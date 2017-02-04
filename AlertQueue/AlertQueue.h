//
//  AlertQueue.h
//  LifeStyleLock
//
//  Created by Nick Brook on 03/02/2017.
//  Copyright © 2017 LifeStyleLock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertQueueItemDelegate;

@interface AlertQueueItem : NSObject

@property(nonatomic, weak, nullable) id<AlertQueueItemDelegate> delegate;
@property(nonatomic, readonly, nullable) NSDictionary * userInfo;

@end

@interface AlertQueue : NSObject

@property(nonatomic, readonly, nonnull) NSArray<AlertQueueItem *> *queuedAlerts;
@property(nonatomic, readonly, nullable) AlertQueueItem *displayedAlert;

+ (nonnull instancetype)sharedQueue;

- (nonnull AlertQueueItem *)displayAlert:(nonnull UIAlertController *)alert delegate:(nullable id<AlertQueueItemDelegate>)delegate userInfo:(nullable NSDictionary *)userInfo;

- (void)cancelAlert:(nonnull AlertQueueItem *)item;

@end

@protocol AlertQueueItemDelegate <NSObject>

- (void)alertDisplayed:(nonnull AlertQueueItem *)alertItem;
- (void)alertDismissed:(nonnull AlertQueueItem *)alertItem;

@end
