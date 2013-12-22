//
//  CGICalendar.m
//
//  Created by Satoshi Konno on 11/01/28.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "CGICalendar.h"
#import "CGICalendarContentLine.h"

NSString * const CGICalendarHeaderContentline = @"BEGIN:VCALENDAR";
NSString * const CGICalendarFooterContentline = @"END:VCALENDAR";

@interface CGICalendar()

@property (strong) NSMutableArray *parserStack;

- (id)peekParserObject;
- (id)popParserObject;
- (void)pushParserObject:(id)object;
- (void)clearParserObjects;

@end

@implementation CGICalendar

#pragma mark -
#pragma mark Class Methods

+ (NSString *)UUID {
	CFUUIDRef uuid = CFUUIDCreate(nil);
	NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
	CFRelease(uuid);
	return uuidString;
}

#pragma mark -
#pragma mark Initialize

- (id)init {
	if ((self = [super init])) {
		[self setObjects: [NSMutableArray array]];
 	}
	return self;
}

- (id)initWithString:(NSString *)aString {
	if ((self = [self init])) {
		[self parseWithString: aString error: nil];
	}
	return self;
}

- (id)initWithPath:(NSString *)aPath {
	if ((self = [self init])) {
		[self parseWithPath: aPath error: nil];
	}
	return self;
}

#pragma mark -
#pragma mark Object

- (void)addObject:(CGICalendarObject *)object {
	[self.objects addObject: object];
}

- (CGICalendarObject *)objectAtIndex:(NSUInteger)index {
	return self.objects[index];
}

#pragma mark -
#pragma mark Parser

- (NSError *)createErrorAt:(NSUInteger)lineNumber lineString:(NSString *)lineString {
	return [NSError errorWithDomain: @"iCalForObjC" code: -1 userInfo: @{
			 @"LineNumber": [NSString stringWithFormat: @"%lu", (unsigned long)lineNumber],
			 @"ContentLine": lineString
			 }];
}

- (BOOL)parseWithString:(NSString *)aString error:(NSError **)error {
	self.objects = [NSMutableArray array];
	[self clearParserObjects];
	if (!aString)
		return NO;

	NSArray *foldingContentLines = [aString componentsSeparatedByCharactersInSet: NSCharacterSet.newlineCharacterSet];
	NSMutableArray *contentLines = [NSMutableArray array];
	for (NSString *foldingContentLine in foldingContentLines) {
		if (!foldingContentLine)
			continue;

		if (![CGICalendarContentLine IsFoldingLineString: foldingContentLine]) {
			[contentLines addObject: [NSMutableString stringWithString: foldingContentLine]];
			continue;
		}
		NSMutableString *lastLineString = contentLines.lastObject;
		if (!lastLineString)
			continue;

		[lastLineString appendString: [foldingContentLine substringWithRange: NSMakeRange(1, (foldingContentLine.length - 1))]];
	}
	NSUInteger contentLineNumber = 0;
	for (NSString *contentLine in contentLines) {
		contentLineNumber++;
		CGICalendarContentLine *icalContentLine = [[CGICalendarContentLine alloc] initWithString: contentLine];
		CGICalendarComponent *icalParentComponent = [self peekParserObject];
		// BEGIN
		if (icalContentLine.isBegin) {
			CGICalendarComponent *icalComponent;
			if (!icalParentComponent) {
				icalComponent = [CGICalendarObject new];
				[self addObject: (CGICalendarObject *)icalComponent];
			} else {
				icalComponent = [CGICalendarComponent new];
				[icalParentComponent addComponent: icalComponent];
			}
			icalComponent.type = icalContentLine.value;
			[self pushParserObject: icalComponent];
			continue;
		}
		// END
		if (icalContentLine.isEnd) {
			[self popParserObject];
			continue;
		}

		NSString *propertyName = icalContentLine.name;
		CGICalendarProperty *icalProperty = [icalParentComponent propertyForName: propertyName];
		if (!icalProperty) {
			icalProperty = [CGICalendarProperty new];
			icalProperty.name = propertyName;
			[icalParentComponent addProperty: icalProperty];
		}
		icalProperty.value = icalContentLine.value;
		for (CGICalendarParameter *icalParameter in icalContentLine.parameters)
			[icalProperty setParameterValue: icalParameter.value forName: icalParameter.name];
	}
	return YES;
}

- (BOOL)parseWithPath:(NSString *)path  error:(NSError **)error {
	NSData *fileData = [NSData dataWithContentsOfFile: path];
	if (!fileData)
		return NO;

	return [self parseWithString: [[NSString alloc] initWithData: fileData encoding: NSUTF8StringEncoding] error: error];
}

#pragma mark -
#pragma mark Parser Stack Methods

- (id)peekParserObject {
	return self.parserStack.lastObject;
}

- (id)popParserObject {
	id lastObject = self.parserStack.lastObject;
	[self.parserStack removeLastObject];
	return lastObject;
}

- (void)pushParserObject:(id)object {
	[self.parserStack addObject: object];
}

- (void)clearParserObjects {
	[self setParserStack: [NSMutableArray array]];
}

#pragma mark -
#pragma mark String

- (NSString *)description {
	NSMutableString *descriptionString = [NSMutableString string];
	for (CGICalendarObject *icalObject in self.objects)
		[descriptionString appendString: icalObject.description];

	return descriptionString;
}

#pragma mark -
#pragma mark File

- (BOOL)writeToFile:(NSString *)path {
	NSString *desc = self.description;
	if (!desc)
		return NO;

	NSData *data = [desc dataUsingEncoding: NSUTF8StringEncoding];
	if (!data)
		return NO;

	return [data writeToFile: path atomically: YES];
}

@end
