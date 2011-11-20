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
// Offers a suggestion for a possibly mis-spelled domain
// returns nil if the domain is valid
- (NSString *)correctionForDomain:(NSString *)invalidDomain;
- (NSString *)topLevelDomainFor:(NSString *)email;
// Returns the levenshtein distance between the domains
// The lower the number, the closer the match
- (int)similarityBetween:(NSString *)firstDomain and:(NSString *)secondDomain;
- (void)validateEmailAddress:(NSString *)emailAddress
                validHandler:(EmailValidHandler)validHandler
              invalidHandler:(EmailInvalidHandler)invalidHandler
           correctionHandler:(EmailCorrectionHandler)correctionHandler;

@end
