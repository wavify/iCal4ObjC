//
//  NSDate+CGICalendar.m
//
//  Created by Satoshi Konno on 5/12/11.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "NSDate+CGICalendar.h"

NSString * const CGNSDateICalendarUTCDateFormat = @"yyyyMMdd'T'HHmmss'Z'";
NSString * const CGNSDateICalendarLocalDatetimeFormat = @"yyyyMMdd'T'HHmmss";
NSString * const CGNSDateICalendarDateFormat = @"yyyyMMdd";
NSString * const CGNSDateISO8601DatetimeFormat = @"yyyy-MM-dd HH:mm:ss";

@implementation NSDate(CGICalendar)

+ (id)dateWithICalendarString:(NSString *)aString {
	if ([aString characterAtIndex: aString.length - 1] == 'Z')
		return [self dateWithICalendarString: aString format: CGNSDateICalendarUTCDateFormat];
	else
		return [self dateWithICalendarString: aString format: CGNSDateICalendarLocalDatetimeFormat];
}

+ (id)dateWithICalendarString:(NSString *)aString format:(NSString *)format {
	if ([format isEqualToString: CGNSDateICalendarUTCDateFormat])
		return [self dateWithICalendarString: aString format: format timezone: [NSTimeZone timeZoneWithName: @"UTC"]];
	else
		return [self dateWithICalendarString: aString format: format timezone: nil];
}

+ (id)dateWithICalendarString:(NSString *)aString format:(NSString *)format timezone:(NSTimeZone *)timezone {
	NSDateFormatter *dateFormatter = [NSDateFormatter new];

	dateFormatter.timeZone = timezone;
	dateFormatter.dateFormat = format;
	dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"];

	return [dateFormatter dateFromString: aString];
}

+ (id)dateWithICalendarISO8601:(NSString *)aString {
	NSDateFormatter *dateFormatter = [NSDateFormatter new];

	dateFormatter.timeZone = [NSTimeZone timeZoneWithName: @"UTC"];
	dateFormatter.timeStyle = NSDateFormatterFullStyle;
	dateFormatter.dateFormat = CGNSDateISO8601DatetimeFormat;

	return [dateFormatter dateFromString: aString];
}

- (NSString *)descriptionICalendar {
	NSDateFormatter *dateFormatter = [NSDateFormatter new];

	dateFormatter.timeZone = [NSTimeZone timeZoneWithName: @"UTC"];
	dateFormatter.dateFormat = CGNSDateICalendarUTCDateFormat;

	return [dateFormatter stringFromDate: self];
}

- (NSString *)descriptionISO8601 {
	NSDateFormatter *dateFormatter = [NSDateFormatter new];

	dateFormatter.locale = NSLocale.systemLocale;
	dateFormatter.dateFormat = CGNSDateISO8601DatetimeFormat;
	
	return [dateFormatter stringFromDate: self];
}

@end
