//
//  AlertQueue.m
//  LifeStyleLock
//
//  Created by Nick Brook on 03/02/2017.
//  Copyright © 2017 LifeStyleLock. All rights reserved.
//

#import "AlertQueue.h"

@protocol AlertRootViewControllerDelegate;

@interface AlertRootViewController : UIViewController

@property(nonatomic, nullable, weak) id<AlertRootViewControllerDelegate> delegate;

@end

@protocol AlertRootViewControllerDelegate <NSObject>
@required
- (void)viewControllerAlertDismissed:(AlertRootViewController *)viewController;

@end

@implementation AlertRootViewController

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
    [self.delegate viewControllerAlertDismissed:self];
}

@end

@interface AlertQueueItem()

@property(nonatomic, strong) UIAlertController *alert;
@property(nonatomic, strong, nullable) NSDictionary * userInfo;

@end

@implementation AlertQueueItem

@end

@interface AlertQueue() <AlertRootViewControllerDelegate>

@property(nonatomic, strong, nonnull) NSMutableArray<AlertQueueItem *> *internalQueuedAlerts;
@property(nonatomic, strong, nullable) AlertQueueItem *displayedAlert;
@property(nonatomic, strong) UIWindow *window;

@end

@implementation AlertQueue

+ (nonnull instancetype)sharedQueue {
    static AlertQueue *sharedQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = [AlertQueue new];
    });
    return sharedQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.window = [UIWindow new];
        self.window.windowLevel = UIWindowLevelAlert;
        self.window.backgroundColor = nil;
        self.window.opaque = NO;
        AlertRootViewController *rvc = [[AlertRootViewController alloc] init];
        rvc.delegate = self;
        rvc.view.backgroundColor = nil;
        rvc.view.opaque = NO;
        self.window.rootViewController = rvc;
        self.internalQueuedAlerts = [NSMutableArray arrayWithCapacity:1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeHidden:) name:UIWindowDidBecomeHiddenNotification object:nil];
        
        self.presented = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidBecomeHidden:(NSNotification *)notification {
    [self displayAlertIfPossible];
}

- (void)viewControllerAlertDismissed:(AlertRootViewController *)viewController {
    AlertQueueItem *item = self.displayedAlert;
    [self.presented addObject:item];
    self.displayedAlert = nil;
    [self.internalQueuedAlerts removeObjectAtIndex:0];
    if([item.delegate respondsToSelector:@selector(alertDismissed:)]) {
        [item.delegate alertDismissed:(AlertQueueItem * _Nonnull)item];
    }
    [self displayAlertIfPossible];
}

- (void)displayAlertIfPossible {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if(self.displayedAlert != nil || (keyWindow != self.window && keyWindow.windowLevel >= UIWindowLevelAlert)) {
        return;
    }
    if(self.internalQueuedAlerts.count == 0) {
        self.window.hidden = YES;
        [self.window resignKeyWindow];
        return;
    }
    self.displayedAlert = self.internalQueuedAlerts[0];
    self.window.frame = [UIScreen mainScreen].bounds;
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:(UIViewController * _Nonnull)self.displayedAlert.alert animated:YES completion:nil];
    if([self.displayedAlert.delegate respondsToSelector:@selector(alertDisplayed:)]) {
        [self.displayedAlert.delegate alertDisplayed:(AlertQueueItem * _Nonnull)self.displayedAlert];
    }
}

- (AlertQueueItem *)displayAlert:(UIAlertController *)alert delegate:(id<AlertQueueItemDelegate>)delegate userInfo:(NSDictionary *)userInfo {
    if(alert.preferredStyle != UIAlertControllerStyleAlert) { // cannot display action sheets
        return nil;
    }
    AlertQueueItem * item = [AlertQueueItem new];
    item.alert = alert;
    item.delegate = delegate;
    item.userInfo = userInfo;
    [self.internalQueuedAlerts addObject:item];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayAlertIfPossible];
    });
    return item;
}

- (void)cancelAlert:(AlertQueueItem *)item {
    if(item == self.displayedAlert) {
        [self.displayedAlert.alert dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.internalQueuedAlerts removeObject:item];
    }
}

- (NSArray<AlertQueueItem *> *)queuedAlerts {
    return _internalQueuedAlerts;
}

@end
