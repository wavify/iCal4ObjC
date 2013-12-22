//
//  NSDate+CGICalendar.h
//
//  Created by Satoshi Konno on 5/12/11.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CGICalendar)

extern NSString * const CGNSDateICalendarUTCDateFormat;
extern NSString * const CGNSDateICalendarLocalDatetimeFormat;
extern NSString * const CGNSDateICalendarDateFormat;
extern NSString * const CGNSDateISO8601DatetimeFormat;

+ (id)dateWithICalendarString:(NSString *)aString;
+ (id)dateWithICalendarString:(NSString *)aString format:(NSString *)format;
+ (id)dateWithICalendarString:(NSString *)aString format:(NSString *)format timezone:(NSTimeZone *)timezone;
+ (id)dateWithICalendarISO8601:(NSString *)aString;
@property (nonatomic, readonly) NSString *descriptionICalendar;
@property (nonatomic, readonly) NSString *descriptionISO8601;

@end
