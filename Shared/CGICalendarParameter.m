//
//  CGICalendarParameter.m
//
//  Created by Satoshi Konno on 11/01/27.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "CGICalendarParameter.h"

NSString * const CGICalendarParameterDelimiter = @"=";

@implementation CGICalendarParameter

- (id)initWithString:(NSString *)aString {
	if ((self = [self init])) {
		self.string = aString;
	}
	return self;
}

- (void)setString:(NSString *)aString {
	NSArray *values = [aString componentsSeparatedByString: CGICalendarParameterDelimiter];
	if (values.count < 2)
		return;

	self.name = values[0];
	self.value = values[1];
}

- (NSString *)string {
	return [NSString stringWithFormat:@"%@%@%@",
			self.name ?: @"",
			CGICalendarParameterDelimiter,
			self.value ?: @""];
}

- (NSString *)description {
	return self.string;
}

@end
