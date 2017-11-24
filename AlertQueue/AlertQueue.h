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

/**
 The alert delegate
 */
@property(nonatomic, weak, nullable) id<AlertQueueAlertControllerDelegate> delegate;

/**
 Any relevant user info for this alert
 */
@property(nonatomic, readonly, nullable) NSDictionary * userInfo;

/**
 The view controller that requested the alert be displayed, if one was passed when adding to the queue
 */
@property(nonatomic, weak, readonly, nullable) UIViewController *presentingController;

/**
 Create an alert with a title, message and user info

 @param title The title for the alert
 @param message The message for the alert
 @param userInfo The user info dictionary
 @return An alert
 */
+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message userInfo:(nullable NSDictionary *)userInfo;

/**
 - Warning: This method is not available on this subclass. Use +alertControllerWithTitle:message:userInfo: instead.
 */
+ (nonnull instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle NS_UNAVAILABLE;

@end

@interface AlertQueue : NSObject

/**
 The queue of alerts including the currently displayed alerts. The current alert is at index 0 and the next alert to be displayed is at 1. Alerts are displayed on a FIFO basis.
 */
@property(nonatomic, readonly, nonnull) NSArray<AlertQueueAlertController *> *queuedAlerts;

/**
 The currently displayed alert
 */
@property(nonatomic, readonly, nullable) AlertQueueAlertController *displayedAlert;

+ (nonnull instancetype)sharedQueue;

/**
 Display an alert, or add to queue if an alert is currently displayed

 @param alert The alert to display
 */
- (void)displayAlert:(nonnull AlertQueueAlertController *)alert;

/**
 Display an alert, or add to queue if an alert is currently displayed

 @param alert The alert to display
 @param userInfo Any relevant information related to the alert for later reference. If a userinfo dictionary already exists on the alert, the dictionaries will be merged with the userinfo here taking precedence on conflicting keys.
 */
- (void)displayAlert:(nonnull AlertQueueAlertController *)alert userInfo:(nullable NSDictionary *)userInfo;

/**
 Display an alert, or add to queue if an alert is currently displayed
 
 @param alert The alert to display
 @param viewController The presenting view controller, stored on the alert for future reference
 @param userInfo Any relevant information related to the alert for later reference. If a userinfo dictionary already exists on the alert, the dictionaries will be merged with the userinfo here taking precedence on conflicting keys.
 */
- (void)displayAlert:(nonnull AlertQueueAlertController *)alert fromController:(nullable UIViewController *)viewController userInfo:(nullable NSDictionary *)userInfo;

/**
 Cancel a displayed or queued alert

 @param alert The alert to cancel
 */
- (void)cancelAlert:(nonnull AlertQueueAlertController *)alert;

/**
 Cancel all alerts from a specific view controller, useful if the controller is dimissed.

 @param controller The controller to cancel alerts from
 */
- (void)invalidateAllAlertsFromController:(nonnull UIViewController *)controller;

@end

@protocol AlertQueueAlertControllerDelegate <NSObject>

/**
 The alert was displayed

 @param alertItem The alert displayed
 */
- (void)alertDisplayed:(nonnull AlertQueueAlertController *)alertItem;

/**
 The alert was dismissed

 @param alertItem The alert dismissed
 */
- (void)alertDismissed:(nonnull AlertQueueAlertController *)alertItem;

@end
