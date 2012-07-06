//
//  MainViewController.m
//  MyPhone
//
//  Created by Pavel Gnatyuk on 1/20/12.
//  Copyright (c) 2012 Software Developer. All rights reserved.
//

#import "MainViewController.h"
#import "UIDevice-IOKit.h"
#import "UIDeviceExt.h"

@implementation MainViewController

@synthesize infoLabels, infoDetails;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retriveDeviceInfo];
}

- (void)viewDidUnload
{
    [self setInfoLabels:nil];
    [self setInfoDetails:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Information";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"";
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)] autorelease];
    label.font = [UIFont fontWithName:@"Helvetica" size:20];
    label.text = @"Information";
    label.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.75];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];  
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self infoLabels] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyPhoneTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ( [indexPath section] == 0 ) 
    {
        if ( [indexPath row] < [[self infoLabels] count] ) 
        {
            //cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = [[self infoLabels] objectAtIndex:[indexPath row]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            cell.detailTextLabel.text = [[self infoDetails] objectAtIndex:[indexPath row]];
        }
    }
    
    return cell;
}

#pragma mark - Device Info

- (void)retriveDeviceInfo
{
    NSMutableArray* names = [[NSMutableArray alloc] initWithCapacity:16];
    NSMutableArray* values = [[NSMutableArray alloc] initWithCapacity:16];
    UIDevice *device = [UIDevice currentDevice];
    
    [names addObject:@"Name:"];
    [values addObject:[device name]];
    NSLog(@"value=%@", [device name]);

    [names addObject:@"Model:"];
    [values addObject:[device model]];
    NSLog(@"value=%@", [device model]);

    [names addObject:@"System Name:"];
    [values addObject:[device systemName]];
    NSLog(@"value=%@", [device systemName]);

    [names addObject:@"System Version:"];
    [values addObject:[device systemVersion]];
    NSLog(@"value=%@", [device systemVersion]);

    [names addObject:@"Unique Identifier:"];
    [values addObject:[device uniqueIdentifier]];
    NSLog(@"value=%@", [device uniqueIdentifier]);

    [names addObject:@"MAC:"];
    [values addObject:[device macAddress]];
    NSLog(@"value=%@", [device macAddress]);

    [names addObject:@"IP address:"];
    [values addObject:[device getIPAddress]];
    NSLog(@"value=%@", [device getIPAddress]);

    [names addObject:@"IMEI:"];
    [values addObject:[device imei]];
    NSLog(@"value=%@", [device imei]);
    
    [names addObject:@"Serial Number:"];
    [values addObject:[device serialnumber]];
    NSLog(@"value=%@", [device serialnumber]);

    [names addObject:@"Camera:"];
    [values addObject: [device isCameraAvailable] ? @"Available" : @"Not Available"];
    NSLog(@"value=%@", [device isCameraAvailable] ? @"Available" : @"Not Available");

    [names addObject:@"Front amera:"];
    [values addObject: [device isFrontCameraAvailable] ? @"Available" : @"Not Available"];
    NSLog(@"value=%@", [device isFrontCameraAvailable] ? @"Available" : @"Not Available");
    
    [self setInfoLabels:names];
    [self setInfoDetails:values];
    [names release];
    [values release];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil] autorelease];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)sendMail:(id)sender
{
    if ( [[self infoDetails] count] > 0 ) 
    {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:[[self infoDetails] objectAtIndex:0]];
        [controller setMessageBody:[self info2Text] isHTML:NO]; 
        if (controller) 
        {
            [self presentModalViewController:controller animated:YES];
        }
        [controller release];    
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller  
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) 
    {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (NSString*)info2Text
{
    NSString* result = nil;
    if ( [[self infoDetails] count] > 0 ) 
    {
        __block NSMutableString* text = [[NSMutableString alloc] initWithCapacity:1024];
        [[self infoLabels] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          
            [text appendFormat:@"%@ %@\n", obj, [[self infoDetails] objectAtIndex:idx]];
            
        }];
        
        result = [text copy];
        [text release];
    }
    
    return result;
}

@end
