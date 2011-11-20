//
//  EmailCorrect.h
//  EmailCorrect
//
//  Created by Jarod Luebbert on 11/19/11.
//  Copyright (c) 2011 Jarod Luebbert. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EmailCorrectionHandler)(NSString *triedEmail, NSString* domainCorrection, NSString *correctedEmail);
typedef void (^EmailValidHandler)(NSString *email);
typedef void (^EmailInvalidHandler)(NSString *email);

@interface EmailCorrect : NSObject

+ (id)sharedInstance;
- (BOOL)isValidEmail:(NSString *)emailAddress;
- (BOOL)isValidDomain:(NSString *)topLevelDomain;
- (NSString *)correctionForDomain:(NSString *)invalidDomain;
- (NSString *)topLevelDomainFor:(NSString *)email;
- (int)similarityBetween:(NSString *)firstDomain and:(NSString *)secondDomain;
- (void)validateEmailAddress:(NSString *)emailAddress
                validHandler:(EmailValidHandler)validHandler
              invalidHandler:(EmailInvalidHandler)invalidHandler
           correctionHandler:(EmailCorrectionHandler)correctionHandler;

@end
