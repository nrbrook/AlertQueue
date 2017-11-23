//
//  AlertQueue.m
//  LifeStyleLock
//
//  Created by Nick Brook on 03/02/2017.
//  Copyright © 2017 LifeStyleLock. All rights reserved.
//

#import "AlertQueue.h"

@protocol AlertQueueAlertControllerInternalDelegate
@required
- (void)alertQueueAlertControllerDidDismiss:(AlertQueueAlertController *)alert;

@end

@interface AlertQueueAlertController()

@property(nonatomic, strong, nullable) NSDictionary * userInfo;
@property (nonatomic, weak, nullable) id<AlertQueueAlertControllerInternalDelegate> internalDelegate;
@property(nonatomic, weak) UIViewController *presentingController;

@end

@implementation AlertQueueAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message userInfo:(NSDictionary *)userInfo {
    AlertQueueAlertController *ac = [super alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    ac.userInfo = userInfo;
    return ac;
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.internalDelegate alertQueueAlertControllerDidDismiss:self];
}

@end

@interface AlertQueue() <AlertQueueAlertControllerInternalDelegate>

@property(nonatomic, strong, nonnull) NSMutableArray<AlertQueueAlertController *> *internalQueuedAlerts;
@property(nonatomic, strong, nullable) AlertQueueAlertController *displayedAlert;
@property(nonatomic, strong) UIWindow *window;
@property(nonatomic, strong) UIWindow *previousKeyWindow;

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
        UIViewController *rvc = [UIViewController new];
        rvc.view.backgroundColor = nil;
        rvc.view.opaque = NO;
        self.window.rootViewController = rvc;
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

- (void)alertQueueAlertControllerDidDismiss:(AlertQueueAlertController *)alert {
    if(self.displayedAlert != alert) { return; }
    self.displayedAlert = nil;
    [self.internalQueuedAlerts removeObjectAtIndex:0];
    if([alert.delegate respondsToSelector:@selector(alertDismissed:)]) {
        [alert.delegate alertDismissed:(AlertQueueAlertController * _Nonnull)alert];
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
        [self.previousKeyWindow makeKeyWindow];
        self.previousKeyWindow = nil;
        return;
    }
    self.displayedAlert = self.internalQueuedAlerts[0];
    self.window.frame = [UIScreen mainScreen].bounds;
    if(!self.window.isKeyWindow) {
        self.previousKeyWindow = UIApplication.sharedApplication.keyWindow;
        [self.window makeKeyAndVisible];
    }
    [self.window.rootViewController presentViewController:(UIViewController * _Nonnull)self.displayedAlert animated:YES completion:nil];
    if([self.displayedAlert.delegate respondsToSelector:@selector(alertDisplayed:)]) {
        [self.displayedAlert.delegate alertDisplayed:(AlertQueueAlertController * _Nonnull)self.displayedAlert];
    }
}

- (void)displayAlert:(AlertQueueAlertController *)alert {
    [self displayAlert:alert userInfo:nil];
}

- (void)displayAlert:(AlertQueueAlertController *)alert userInfo:(NSDictionary *)userInfo {
    [self displayAlert:alert fromController:nil userInfo:userInfo];
}

- (void)displayAlert:(AlertQueueAlertController *)alert fromController:(UIViewController *)viewController userInfo:(NSDictionary *)userInfo {
    if(alert.preferredStyle != UIAlertControllerStyleAlert) { // cannot display action sheets
        return;
    }
    alert.internalDelegate = self;
    if(userInfo) {
        if(alert.userInfo) {
            NSMutableDictionary *d = alert.userInfo.mutableCopy;
            [d setValuesForKeysWithDictionary:userInfo];
            alert.userInfo = d;
        } else {
            alert.userInfo = userInfo;
        }
    }
    alert.presentingController = viewController;
    [self.internalQueuedAlerts addObject:alert];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayAlertIfPossible];
    });
}

- (void)cancelAlert:(AlertQueueAlertController *)alert {
    if(alert == self.displayedAlert) {
        [self.displayedAlert dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.internalQueuedAlerts removeObject:alert];
    }
}

- (void)invalidateAllAlertsFromController:(UIViewController *)controller {
    NSArray<AlertQueueAlertController *> *queuedAlerts = [self.internalQueuedAlerts copy];
    for(AlertQueueAlertController *alert in queuedAlerts) {
        if(alert.presentingController == controller) {
            [self cancelAlert:alert];
        }
    }
}

- (NSArray<AlertQueueAlertController *> *)queuedAlerts {
    // returns new array so original can be manipulated (alerts cancelled) while enumerating
    return [NSArray arrayWithArray:_internalQueuedAlerts];
}

@end
