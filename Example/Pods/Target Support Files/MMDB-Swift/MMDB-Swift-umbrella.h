#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "data-pool.h"
#import "maxminddb-compat-util.h"
#import "maxminddb.h"
#import "maxminddb_config.h"
#import "maxminddb_unions.h"

FOUNDATION_EXPORT double MMDB_SwiftVersionNumber;
FOUNDATION_EXPORT const unsigned char MMDB_SwiftVersionString[];

