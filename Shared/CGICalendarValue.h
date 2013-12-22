//
//  CGICalendarValue.h
//
//  Created by Satoshi Konno on 11/01/27.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
	CGICalendarValueTypeUnknown = 0,
	CGICalendarValueTypeBinary,
	CGICalendarValueTypeBoolean,
	CGICalendarValueTypeCalendarUserAddress,
	CGICalendarValueTypeDate,
	CGICalendarValueTypeDateTime,
	CGICalendarValueTypeDuration,
	CGICalendarValueTypeFloat,
	CGICalendarValueTypeInteger,
	CGICalendarValueTypePeriodOfTime,
	CGICalendarValueTypeRecurrenceRule,
	CGICalendarValueTypeText,
	CGICalendarValueTypeTime,
	CGICalendarValueTypeURI,
	CGICalendarValueTypeUTCOffset,
} CGICalendarValueType;

@interface CGICalendarValue : NSObject

@property (nonatomic, assign) CGICalendarValueType type;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *value;

@property (nonatomic, readonly) BOOL hasName;
@property (nonatomic, readonly) BOOL hasValue;

- (BOOL)isName:(NSString *)aName;
- (BOOL)isValue:(NSString *)aValue;

- (void)setObject:(id)value;
- (void)setDate:(NSDate *)value;

- (NSDate *)dateValue;
- (NSInteger)integerValue;
- (float)floatValue;

@end
