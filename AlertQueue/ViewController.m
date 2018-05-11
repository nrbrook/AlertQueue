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
    
    AlertQueueAlertController *ac = [AlertQueueAlertController alertControllerWithTitle:@"Test1" message:@"Test1" userInfo:nil];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Alert!");
    }]];
	[[AlertQueue sharedQueue] displayAlert:ac fromController:self userInfo:nil];
    
}


- (IBAction)twoAlerts:(id)sender {
	AlertQueueAlertController *ac = [AlertQueueAlertController alertControllerWithTitle:@"Test1" message:@"Test1" userInfo:nil];
	[ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSLog(@"Alert!");
	}]];
	[[AlertQueue sharedQueue] displayAlert:ac fromController:self userInfo:nil];
	AlertQueueAlertController *ac2 = [AlertQueueAlertController alertControllerWithTitle:@"Test2" message:@"Test2" userInfo:nil];
	[ac2 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSLog(@"Alert2!");
	}]];
	[[AlertQueue sharedQueue] displayAlert:ac2 fromController:self userInfo:nil];
}

- (IBAction)cancelDisplayed:(id)sender {
	AlertQueueAlertController *ac = [AlertQueueAlertController alertControllerWithTitle:@"Test1" message:@"Test1" userInfo:nil];
	[ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSLog(@"Alert!");
	}]];
	[[AlertQueue sharedQueue] displayAlert:ac fromController:self userInfo:nil];
	AlertQueueAlertController *ac2 = [AlertQueueAlertController alertControllerWithTitle:@"Test2" message:@"Test2" userInfo:nil];
	[ac2 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSLog(@"Alert2!");
	}]];
	[[AlertQueue sharedQueue] displayAlert:ac2 fromController:self userInfo:nil];
	[NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
		[[AlertQueue sharedQueue] cancelAlert:ac];
	}];
	
}

- (IBAction)cancelQueued:(id)sender {
	AlertQueueAlertController *ac = [AlertQueueAlertController alertControllerWithTitle:@"Test1" message:@"Test1" userInfo:nil];
	[ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSLog(@"Alert!");
	}]];
	[[AlertQueue sharedQueue] displayAlert:ac fromController:self userInfo:nil];
	AlertQueueAlertController *ac2 = [AlertQueueAlertController alertControllerWithTitle:@"Test2" message:@"Test2" userInfo:nil];
	[ac2 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSLog(@"Alert2!");
	}]];
	[[AlertQueue sharedQueue] displayAlert:ac2 fromController:self userInfo:nil];
	[NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
		[[AlertQueue sharedQueue] cancelAlert:ac2];
	}];
}

@end
