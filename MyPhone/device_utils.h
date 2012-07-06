/*
 *  device_utils.h
 *
 *  Created by Pavel Gnatyuk on 8/4/11.
 *  Copyright 2011 Eyekon. All rights reserved.
 *
 */

#if !defined(__DEVICE_UTILS__)

#define __DEVICE_UTILS__

#include <stdbool.h>

#if defined(__cplusplus)
#define DEVICE_UTILS_EXTERN extern "C"
#else
#define DEVICE_UTILS_EXTERN extern
#endif

DEVICE_UTILS_EXTERN char* hw_machine();
DEVICE_UTILS_EXTERN char* hw_machine_model();
DEVICE_UTILS_EXTERN int number_of_cpu();
DEVICE_UTILS_EXTERN bool mac_address(char* address, const unsigned int capacity);
DEVICE_UTILS_EXTERN unsigned int get_free_memory();

DEVICE_UTILS_EXTERN char* os_type();
DEVICE_UTILS_EXTERN char* os_version();

DEVICE_UTILS_EXTERN bool local_WiFi_address(char* address, unsigned int capacity);


#endif




