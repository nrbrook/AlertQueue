//
//  ViewController.m
//  AlertQueue
//
//  Created by Nick Brook on 03/02/2017.
//  Copyright © 2017 Nick Brook. All rights reserved.
//

#import "ViewController.h"
#import "AlertQueue.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)alertViewTest:(id)sender {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"av" message:@"av test" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [av show];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Test1" message:@"Test1" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    AlertQueueItem *item = [[AlertQueue sharedQueue] displayAlert:ac delegate:nil userInfo:nil];
    
}


- (IBAction)twoAlerts:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Test1" message:@"Test1" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    AlertQueueItem *item = [[AlertQueue sharedQueue] displayAlert:ac delegate:nil userInfo:nil];
    UIAlertController *ac2 = [UIAlertController alertControllerWithTitle:@"Test2" message:@"Test2" preferredStyle:UIAlertControllerStyleAlert];
    [ac2 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    AlertQueueItem *item2 = [[AlertQueue sharedQueue] displayAlert:ac2 delegate:nil userInfo:nil];
}

- (IBAction)cancelDisplayed:(id)sender {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Test1" message:@"Test1" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    AlertQueueItem *item = [[AlertQueue sharedQueue] displayAlert:ac delegate:nil userInfo:nil];
    UIAlertController *ac2 = [UIAlertController alertControllerWithTitle:@"Test2" message:@"Test2" preferredStyle:UIAlertControllerStyleAlert];
    [ac2 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    AlertQueueItem *item2 = [[AlertQueue sharedQueue] displayAlert:ac2 delegate:nil userInfo:nil];
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [[AlertQueue sharedQueue] cancelAlert:item];
    }];
}

- (IBAction)cancelQueued:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Test1" message:@"Test1" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    AlertQueueItem *item = [[AlertQueue sharedQueue] displayAlert:ac delegate:nil userInfo:nil];
    UIAlertController *ac2 = [UIAlertController alertControllerWithTitle:@"Test2" message:@"Test2" preferredStyle:UIAlertControllerStyleAlert];
    [ac2 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    AlertQueueItem *item2 = [[AlertQueue sharedQueue] displayAlert:ac2 delegate:nil userInfo:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [[AlertQueue sharedQueue] cancelAlert:item2];
    }];
}

@end
