//
//  AlertQueue.m
//  LifeStyleLock
//
//  Created by Nick Brook on 03/02/2017.
//  Copyright © 2017 LifeStyleLock. All rights reserved.
//

#import "AlertQueue.h"

@interface AlertQueue()

@property(nonatomic, strong, nonnull) NSMutableArray<AlertQueueItem *> *internalQueuedAlerts;
@property(nonatomic, strong, nullable) AlertQueueItem *displayedAlert;
@property(nonatomic, strong) UIWindow *window;

- (void)alertControllerDismissed:(nonnull UIAlertController *)alert;

@end

@interface AlertViewController : UIAlertController

@end

@implementation AlertViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[AlertQueue sharedQueue] alertControllerDismissed:self];
}

@end

@interface AlertQueueItem()

@property(nonatomic, strong) AlertViewController *alert;
@property(nonatomic, strong, nullable) NSDictionary * userInfo;

@end

@implementation AlertQueueItem

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
        self.window.rootViewController = [[UIViewController alloc] init];
        self.window.rootViewController.view.backgroundColor = nil;
        self.window.rootViewController.view.opaque = NO;
        self.internalQueuedAlerts = [NSMutableArray arrayWithCapacity:1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeHidden:) name:UIWindowDidBecomeHiddenNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidBecomeHidden:(NSNotification *)notification {
    [self displayAlertIfPossible];
}

- (void)alertControllerDismissed:(UIAlertController *)alert {
    if(alert != self.displayedAlert.alert) {
        return;
    }
    AlertQueueItem *item = self.displayedAlert;
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
    [self.window.rootViewController presentViewController:(AlertViewController * _Nonnull)self.displayedAlert.alert animated:YES completion:nil];
    if([self.displayedAlert.delegate respondsToSelector:@selector(alertDisplayed:)]) {
        [self.displayedAlert.delegate alertDisplayed:(AlertQueueItem * _Nonnull)self.displayedAlert];
    }
}

- (AlertQueueItem *)displayAlert:(UIAlertController *)alert delegate:(id<AlertQueueItemDelegate>)delegate userInfo:(id)userInfo {
    AlertQueueItem * item = [AlertQueueItem new];
    item.alert = [AlertViewController alertControllerWithTitle:alert.title message:alert.message preferredStyle:alert.preferredStyle];
    for(UIAlertAction *a in alert.actions) {
        [item.alert addAction:a];
    }
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
