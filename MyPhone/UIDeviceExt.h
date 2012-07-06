//
//  UIDeviceExt.h
//  PhoneNumber
//
//  Created by Pavel Gnatyuk on 8/4/11.
//  Copyright 2011 Eyekon. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIDevice(Ext)

-(NSString*)platformName;
-(NSString*)modelName;
-(NSString*)platform;
-(NSInteger)getFreeMem;
-(NSString*)macAddress;
- (NSString*)getIPAddress;

-(NSString*)osType;
-(NSString*)osVersion;

- (BOOL)isRetina;
- (BOOL)silenced;
- (BOOL)isCameraAvailable;
- (BOOL)isFrontCameraAvailable;

- (NSString*)localWiFiIPAddress;

@end
