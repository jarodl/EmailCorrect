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

/**
 * @discussion Tests the entire email for validity
 */
- (BOOL)isValidEmail:(NSString *)emailAddress;

/**
 * @discussion Tests a domain for validity
 */
- (BOOL)isValidDomain:(NSString *)topLevelDomain;

/**
 * @discussion Offers a suggestion for a possibly mis-spelled domain
 *             returns nil if the domain is valid
 */
- (NSString *)correctionForDomain:(NSString *)invalidDomain;

/**
 * @discussion Parses out the TLD for the given email
 */
- (NSString *)topLevelDomainFor:(NSString *)email;

/**
 * @discussion Attempts to validate the email and calls the respective handler
 */
- (void)validateEmailAddress:(NSString *)emailAddress
                validHandler:(EmailValidHandler)validHandler
              invalidHandler:(EmailInvalidHandler)invalidHandler
           correctionHandler:(EmailCorrectionHandler)correctionHandler;

@end
