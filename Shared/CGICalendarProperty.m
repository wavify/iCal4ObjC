//
//  CGICalendarProperty.m
//
//  Created by Satoshi Konno on 11/01/27.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "CGICalendarProperty.h"
#import "CGICalendarContentLine.h"
#import "NSDate+CGICalendar.h"

NSString * const CGICalendarPropertyPartstat = @"PARTSTAT";
NSString * const CGICalendarPropertyCompleted = @"COMPLETED";
NSString * const CGICalendarPropertyDtend = @"DTEND";
NSString * const CGICalendarPropertyDue = @"DUE";
NSString * const CGICalendarPropertyDtstart = @"DTSTART";
NSString * const CGICalendarPropertyDescription = @"DESCRIPTION";
NSString * const CGICalendarPropertyPriority = @"PRIORITY";
NSString * const CGICalendarPropertySummary = @"SUMMARY";
NSString * const CGICalendarPropertyLocation = @"LOCATION";
NSString * const CGICalendarPropertyUid = @"UID";
NSString * const CGICalendarPropertyCreated = @"CREATED";
NSString * const CGICalendarPropertyDtstamp = @"DTSTAMP";
NSString * const CGICalendarPropertyLastModified = @"LAST-MODIFIED";
NSString * const CGICalendarPropertySequence = @"SEQUENCE";

@implementation CGICalendarProperty

- (instancetype)init {
	self = [super init];
	if (self)
		self.parameters = [NSMutableArray array];

	return self;
}

#pragma mark -
#pragma mark Parameter

- (BOOL)hasParameterForName:(NSString *)name {
	for (CGICalendarParameter *icalProp in self.parameters)
		if ([icalProp isName: name]) {
			[self.parameters removeObject: icalProp];
			return YES;
		}

	return NO;
}

- (void)addParameter:(CGICalendarParameter *)parameter {
	[self.parameters addObject: parameter];
}

- (void)removeParameterForName:(NSString *)name {
	for (CGICalendarParameter *icalProp in [self parameters])
		if ([icalProp isName: name]) {
			[self.parameters removeObject: icalProp];
			return;
		}
}

- (void)setParameterValue:(NSString *)value forName:(NSString *)name {
	CGICalendarParameter *icalProp = [self parameterForName: name];
	if (!icalProp) {
		icalProp = [CGICalendarParameter new];
		icalProp.name = name;
		[self addParameter: icalProp];
	}
	icalProp.value = value;
}

- (void)setParameterValue:(NSString *)value forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames {
	[self setParameterValue: value forName: name parameterValues: @[] parameterNames: @[]];
}

- (void)setParameterObject:(id)object forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames {
	[self setParameterValue: [object description] forName: name parameterValues: parameterValues parameterNames: parameterNames];
}

- (void)setParameterObject:(id)object forName:(NSString *)name {
	[self setParameterValue: [object description] forName: name];
}

- (void)setParameterDate:(NSDate *)object forName:(NSString *)name {
	[self setParameterValue: object.descriptionICalendar forName: name];
}

- (void)setParameterDate:(NSDate *)object forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames {
	[self setParameterValue: object.descriptionICalendar forName: name parameterValues: parameterValues parameterNames: parameterNames];
}

- (void)setParameterInteger:(NSInteger)value forName:(NSString *)name {
	[self setParameterValue: @(value).stringValue forName: name parameterValues: @[] parameterNames: @[]];
}

- (void)setParameterInteger:(NSInteger)value forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames {
	[self setParameterValue: @(value).stringValue forName: name parameterValues: parameterValues parameterNames: parameterNames];
}

- (void)setParameterFloat:(float)value forName:(NSString *)name {
	[self setParameterValue: @(value).stringValue forName: name parameterValues: @[] parameterNames: @[]];
}

- (void)setParameterFloat:(float)value forName:(NSString *)name parameterValues:(NSArray *)parameterValues parameterNames:(NSArray *)parameterNames {
	[self setParameterValue: @(value).stringValue forName: name parameterValues: parameterValues parameterNames: parameterNames];
}

- (id)parameterAtIndex:(NSUInteger)index {
	return self.parameters[index];
}

- (CGICalendarParameter *)parameterForName:(NSString *)name {
	for (CGICalendarParameter *icalProp in self.parameters)
		if ([icalProp isName: name])
			return icalProp;

	return nil;
}

- (NSArray *)allParameterKeys {
	NSMutableArray *keys = [NSMutableArray array];
	for (CGICalendarParameter *icalProp in self.parameters)
		[keys addObject: icalProp.name];

	return keys;
}

- (NSString *)parameterValueForName:(NSString *)name {
	for (CGICalendarParameter *icalProp in self.parameters)
		if ([icalProp isName: name])
			return icalProp.value;

	return nil;
}

- (NSDate *)parameterDateForName:(NSString *)name {
	for (CGICalendarParameter *icalProp in self.parameters)
		if ([icalProp isName: name])
			return icalProp.dateValue;

	return nil;
}

- (NSInteger)parameterIntegerForName:(NSString *)name {
	for (CGICalendarParameter *icalProp in self.parameters)
		if ([icalProp isName: name])
			return icalProp.integerValue;

	return 0;
}

- (float)parameterFloatForName:(NSString *)name {
	for (CGICalendarParameter *icalProp in self.parameters)
		if ([icalProp isName: name])
			return icalProp.floatValue;

	return 0;
}

#pragma mark -
#pragma mark String

- (NSString *)description {
	NSMutableString *propertyString = [NSMutableString string];
	[propertyString appendFormat: @"%@", self.name];
	for (CGICalendarParameter *icalParam in self.parameters)
		[propertyString appendFormat: @";%@", icalParam.description];
	[propertyString appendFormat: @"%% :%@%@", ((self.value.length > 0) ? self.value : @""), CGICalendarContentlineTerm];
	return propertyString;
}

#pragma mark -
#pragma mark ParticipationStatus

- (NSArray *)participationStatusStrings {
	static NSArray *statusStrings = nil;
	if (!statusStrings)
		statusStrings = @[@"",
						  @"NEEDS-ACTION",
						  @"ACCEPTED",
						  @"DECLINED",
						  @"TENTATIVE",
						  @"DELEGATED",
						  @"COMPLETED",
						  @"IN-PROCESS"];

	return statusStrings;
}

- (void)setParticipationStatus:(CGICalendarParticipationStatus)status{
	NSArray *statusStrings = self.participationStatusStrings;
	if ((statusStrings.count - 1) < status)
		return;

	self.value = statusStrings[status];
}

- (CGICalendarParticipationStatus)participationStatus {
	if (!self.value)
		return CGICalendarParticipationStatusUnkown;

	NSArray *statusStrings = self.participationStatusStrings;
	for (NSUInteger n = 0; n < statusStrings.count; n++)
		if ([self.value isEqualToString: statusStrings[n]])
			return n;

	return CGICalendarParticipationStatusUnkown;
}

- (NSDate *)dateValue {
	// It is a Date, not Date-time
	if ([[self parameterValueForName: @"VALUE"] isEqualToString: @"DATE"])
		return [NSDate dateWithICalendarString: self.value format: CGNSDateICalendarDateFormat];

	// Local time with timezone ID
	if ([self parameterValueForName:@"TZID"]) {
		NSTimeZone *timezone = [NSTimeZone timeZoneWithName: [self parameterValueForName:@"TZID"]];

		return [NSDate dateWithICalendarString: self.value format: CGNSDateICalendarLocalDatetimeFormat timezone: timezone];
	}

	// No parameters, pass the value to NSDate category
	return [NSDate dateWithICalendarString: self.value];
}

@end
