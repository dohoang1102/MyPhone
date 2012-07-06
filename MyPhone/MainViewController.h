//
//  MainViewController.h
//  MyPhone
//
//  Created by Pavel Gnatyuk on 1/20/12.
//  Copyright (c) 2012 Software Developer. All rights reserved.
//

#import "FlipsideViewController.h"
#import <MessageUI/MessageUI.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, 
UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) NSMutableArray* infoLabels;
@property (nonatomic, retain) NSMutableArray* infoDetails;

- (NSString*)info2Text;

- (IBAction)showInfo:(id)sender;
- (IBAction)sendMail:(id)sender;

- (void)retriveDeviceInfo;

@end
