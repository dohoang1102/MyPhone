/*
 *  device_utils.c
 *  PhoneNumber
 *
 *  Created by Pavel Gnatyuk on 8/4/11.
 *  Copyright 2011 Software Developer. All rights reserved.
 *
 */

#include "device_utils.h"

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h> 
#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h> 
#include <mach/mach_host.h>


#import <arpa/inet.h>
#import <netdb.h>
#import <net/if.h>
#import <ifaddrs.h>

char* hw_machine()
{
	int mib[2] = { 0 };
	size_t len = 0;
	char *p = 0;
	
	mib[0] = CTL_HW;
	mib[1] = HW_MACHINE;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	if (len > 0)
	{
		p = (char*)malloc(len);
		sysctl(mib, 2, p, &len, NULL, 0);		
	}
	return p;
}

char* hw_machine_model()
{
	int mib[2] = { 0 };
	size_t len = 0;
	char *p = 0;
	
	mib[0] = CTL_HW;
	mib[1] = HW_MODEL;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	if (len > 0)
	{
		p = malloc(len);
		sysctl(mib, 2, p, &len, NULL, 0);		
	}
	return p;
}

char* os_type()
{
	int mib[2] = { 0 };
	size_t len = 0;
	char *p = 0;
	
	mib[0] = CTL_KERN;
	mib[1] = KERN_OSTYPE;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	if (len > 0)
	{
		p = malloc(len);
		sysctl(mib, 2, p, &len, NULL, 0);		
	}
	return p;
}

char* os_version()
{
	int mib[2] = { 0 };
	size_t len = 0;
	char *p = 0;
	
	mib[0] = CTL_KERN;
	mib[1] = KERN_VERSION;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	if (len > 0)
	{
		p = malloc(len);
		sysctl(mib, 2, p, &len, NULL, 0);		
	}
	return p;
}

int phys_mem()
{
	int mib[2] = { 0 };
	size_t len = 0;
	int p = 0;
	
	mib[0] = CTL_HW;
	mib[1] = HW_PHYSMEM;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	if (len > 0)
		sysctl(mib, 2, &p, &len, NULL, 0);		
	return p;
}

int user_mem()
{
	int mib[2] = { 0 };
	size_t len = 0;
	int p = 0;
	
	mib[0] = CTL_HW;
	mib[1] = HW_USERMEM;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	if (len > 0)
		sysctl(mib, 2, &p, &len, NULL, 0);		
	return p;
}

int page_size()
{
	int mib[2] = { 0 };
	size_t len = 0;
	int p = 0;
	
	mib[0] = CTL_HW;
	mib[1] = HW_PAGESIZE;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	if (len > 0)
		sysctl(mib, 2, &p, &len, NULL, 0);		
	return p;
}

int number_of_cpu()
{
	int mib[2] = { 0 };
	size_t len = 0;
	int p = 0;
	
	mib[0] = CTL_HW;
	mib[1] = HW_NCPU;
	sysctl(mib, 2, NULL, &len, NULL, 0);
	if (len > 0)
		sysctl(mib, 2, &p, &len, NULL, 0);		
	return p;
}

bool mac_address(char* address, const unsigned int capacity)
{
	int					mib[6];
	size_t				len;
	char				*buf;
	unsigned char		*ptr;
	struct if_msghdr	*ifm;
	struct sockaddr_dl	*sdl;
	
	mib[0] = CTL_NET;
	mib[1] = AF_ROUTE;
	mib[2] = 0;
	mib[3] = AF_LINK;
	mib[4] = NET_RT_IFLIST;
	
	if ((mib[5] = if_nametoindex("en0")) == 0) 
		return false;
	
	if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) 
		return false;
	
	buf = malloc(len);
	sysctl(mib, 6, buf, &len, NULL, 0);
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	
	if (address != 0 && capacity > 0)
		sprintf(address, "%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5));
	free(buf);
	
	return true;
}

unsigned int get_free_memory() 
{
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
	
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);        
	
    vm_statistics_data_t vm_stat;
	
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) 
        return 0;
	
    /* Stats in bytes */ 
    natural_t mem_free = vm_stat.free_count * pagesize;
    return (unsigned int)mem_free;
}

bool local_WiFi_address(char* address, unsigned int capacity)
{
	bool success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	
	success = getifaddrs(&addrs) == 0;
	if (success) 
	{
		cursor = addrs;
		while (cursor != NULL) 
		{
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
			{
				success = (strcmp(cursor->ifa_name, "en0") == 0);
				if (success)
				{
					strncpy(address, inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr), capacity);
					break;
				}
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return success;
}
