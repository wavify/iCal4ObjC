//
//  CGICalendarValue.m
//
//  Created by Satoshi Konno on 11/01/27.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "CGICalendarValue.h"
#import "NSDate+CGICalendar.h"

@implementation CGICalendarValue

- (BOOL)hasName {
	return (self.name && self.name.length > 0);
}

- (BOOL)hasValue {
	return (self.value && self.value.length > 0);
}

- (BOOL)isName:(NSString *)aName {
	if (!aName || aName.length <= 0)
		return NO;

	return [aName isEqualToString: self.name];
}

- (BOOL)isValue:(NSString *)aValue {
	if (!aValue || aValue.length <= 0)
		return NO;

	return [aValue isEqualToString: self.value];
}

- (void)setObject:(id)aValue {
	self.value = [aValue description];
}

- (void)setDate:(NSDate *)aValue {
	self.value = aValue.descriptionICalendar;
}

- (NSDate *)dateValue {
	return [NSDate dateWithICalendarString: self.value];
}

- (NSInteger)integerValue {
	return self.value.integerValue;
}

- (float)floatValue {
	return self.value.floatValue;
}

@end
