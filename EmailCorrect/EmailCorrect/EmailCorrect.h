//
//  EmailCorrect.h
//  EmailCorrect
//
//  Created by Jarod Luebbert on 11/19/11.
//  Copyright (c) 2011 Jarod Luebbert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmailCorrect : NSObject

+ (id)sharedInstance;
- (BOOL)isValidEmail:(NSString *)emailAddress;
- (BOOL)isValidDomain:(NSString *)topLevelDomain;
- (NSString *)correctionForDomain:(NSString *)invalidDomain;
- (int)similarityBetween:(NSString *)firstDomain and:(NSString *)secondDomain;

@end
