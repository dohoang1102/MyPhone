//
//  UIDeviceExt.m
//  PhoneNumber
//
//  Created by Pavel Gnatyuk on 8/4/11.
//  Copyright 2011 Software Developer. All rights reserved.
//

#import "UIDeviceExt.h"
#import "device_utils.h"
#import "AudioToolbox/AudioToolbox.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation UIDevice(Ext)

- (NSString *)macAddress
{
	char address[256] = { 0 };
	if (!mac_address(address, 256))
		return nil;
	NSString *outstring = [NSString stringWithCString: address encoding: NSUTF8StringEncoding];
	return [outstring uppercaseString];
}

- (NSString *)platformName
{
    NSString *platform = [self platform];
	
    if ([platform isEqualToString:@"iPhone1,1"])    
		return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    
		return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    
		return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    
		return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    
		return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      
		return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      
		return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      
		return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      
		return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      
		return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      
		return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      
		return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      
		return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"i386"])         
		return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])         
		return @"Simulator";
    return platform;
}

-(NSString*)platform
{
	char *name = hw_machine();
	if (name == 0)
		return nil;
	NSString* str = [NSString stringWithCString: name encoding: NSUTF8StringEncoding];
	free(name);
	return str;
}

-(NSString*)modelName
{
	char *name = hw_machine_model();
	if (name == 0)
		return nil;
	NSString* str = [NSString stringWithCString: name encoding: NSUTF8StringEncoding];
	free(name);
	return str;
}

-(NSString*)osType
{
	char *name = os_type();
	if (name == 0)
		return nil;
	NSString* str = [NSString stringWithCString: name encoding: NSUTF8StringEncoding];
	free(name);
	return str;
}

-(NSString*)osVersion
{
	char *name = os_version();
	if (name == 0)
		return nil;
	NSString* str = [NSString stringWithCString: name encoding: NSUTF8StringEncoding];
	free(name);
	return str;
}

-(NSInteger)getFreeMem
{
	int p = get_free_memory();
	return (NSInteger)p;
}

-(BOOL)isRetina
{
	UIScreen *screen = [UIScreen mainScreen];
	return ([screen respondsToSelector:@selector(scale)] && [screen scale] == 2.0); 
}

-(BOOL)silenced {
#if TARGET_IPHONE_SIMULATOR
	// return NO in simulator. Code causes crashes for some reason.
	return NO;
#endif
	
    CFStringRef state;
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &state);
    if(CFStringGetLength(state) > 0)
        return NO;
    else
        return YES;
	
}

- (NSNumber *) totalDiskSpace
{
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileSystemSize];
}

- (NSNumber *) freeDiskSpace
{
	NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
	return [fattributes objectForKey:NSFileSystemFreeSize];
}

- (NSString *) localWiFiIPAddress
{
	char address[256] = { 0 };
	if (local_WiFi_address(address, 256))
		return [NSString stringWithUTF8String: address];
	return nil;
}


// Get IP Address
- (NSString *)getIPAddress 
{    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];               
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
} 

- (BOOL)isCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable
{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

@end
