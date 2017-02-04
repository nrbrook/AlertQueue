# AlertQueue

This class provides a neat interface to manage global queuing of displayed `UIAlertController`s. It will even wait for `UIAlertView`s to dismiss before displaying the next controller. It also provides storage of an associated userInfo dictionary with each alert and a delegate for displayed and dismissed events. It does not use swizzling to achieve this.

## Installation

Just drag AlertQueue{.m,.h} in to your project. Check to copy files if you are not using a submodule.

## Usage

Create your alert controller as normal, and then display using the singleton queue:

```Objective-C
UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Test1" message:@"Test1" preferredStyle:UIAlertControllerStyleAlert];
[ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
AlertQueueItem *item = [[AlertQueue sharedQueue] displayAlert:ac delegate:nil userInfo:nil];
```

This will display an alert immediately if no alert is currently displayed, or otherwise add it to the end of the queue.

To dismiss or cancel an alert at any point:

```Objective-C
[[AlertQueue sharedQueue] cancelAlert:item];
```
