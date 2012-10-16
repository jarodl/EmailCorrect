//
//  EmailCorrectTests.m
//  EmailCorrectTests
//
//  Created by Jarod Luebbert on 11/19/11.
//  Copyright (c) 2011 Jarod Luebbert. All rights reserved.
//

#import "EmailCorrectTests.h"
#import "EmailCorrect.h"
#import "EmailCorrect+Private.h"

// via http://mrox.net/blog/2011/08/04/a-tip-for-testing-block-based-apis/
#define TEST_WAIT_UNTIL_TRUE_SLEEP_SECONDS (0.25)
#define TEST_WAIT_UNTIL_TRUE(expr) \
while( (expr) == NO ) [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:TEST_WAIT_UNTIL_TRUE_SLEEP_SECONDS]];

@implementation EmailCorrectTests

- (void)setUp
{
    [super setUp];
    self.emailCorrector = [[EmailCorrect alloc] init];
}

- (void)tearDown
{
    [_emailCorrector release];
    [super tearDown];
}

- (void)testIsValidEmail
{
    STAssertTrue([_emailCorrector isValidEmail:@"niceandsimple@example.com"], @"Valid email was marked as invalid");
    STAssertTrue([_emailCorrector isValidEmail:@"a.little.unusual@example.com"], @"Valid email was marked as invalid");
    STAssertTrue([_emailCorrector isValidEmail:@"a.little.more.unusual@dept.example.com"], @"Valid email was marked as invalid");
    STAssertFalse([_emailCorrector isValidEmail:@"Abc.example.com"], @"Invalid email was marked as valid");
    STAssertFalse([_emailCorrector isValidEmail:@"A@b@c@example.com"], @"Invalid email was marked as valid");
    STAssertFalse([_emailCorrector isValidEmail:@"'(),:;<>[\\]@example.com"], @"Invalid email was marked as valid");
}

- (void)testUppercaseLettersInEmailRemainValid
{
    STAssertTrue([_emailCorrector isValidEmail:@"niceandsimple@Example.com"], @"Valid email was marked as invalid");
    STAssertTrue([_emailCorrector isValidEmail:@"A.Little.Unusual@ExaMplE.Com"], @"Valid email was marked as invalid");
}

- (void)testIsValidDomain
{
    STAssertTrue([_emailCorrector isValidDomain:@"com"],
                 @"Valid top level domain was marked as invalid");
    STAssertTrue([_emailCorrector isValidDomain:@"COM"],
                 @"Valid top level domain was marked as invalid");
    STAssertFalse([_emailCorrector isValidDomain:@"con"],
                  @"Invalid top level domain was marked as valid");
    STAssertTrue([_emailCorrector isValidDomain:@"xxx"],
                  @"Valid top level domain was marked as invalid");
}

- (void)testSimilarityBetweenDomains
{
    int similarity = [_emailCorrector similarityBetween:@"com" and:@"con"];
    STAssertEquals(similarity, 1, @"Similarity between '.com' and '.con' was not 1");
    similarity = [_emailCorrector similarityBetween:@"COM" and:@"com"];
    STAssertEquals(similarity, 0, @"Similarity between '.COM' and '.com' was not 0");
    similarity = [_emailCorrector similarityBetween:@"bon" and:@"com"];
    STAssertEquals(similarity, 2, @"Similarity between '.bon' and '.com' was not 2");
    similarity = [_emailCorrector similarityBetween:@"sitting" and:@"kitten"];
    STAssertEquals(similarity, 3, @"Similarity between 'sitting' and 'kitten' was not 3");
    similarity = [_emailCorrector similarityBetween:@"Saturday" and:@"Sunday"];
    STAssertEquals(similarity, 3, @"Similarity between 'Saturday' and 'Sunday' was not 3");
}

- (void)testSimilarityForValidDomain
{
    NSString *correction = [_emailCorrector correctionForDomain:@"com"];
    STAssertNil(correction, @"Correction for valid domain was not nil");
    correction = [_emailCorrector correctionForDomain:@"COM"];
    STAssertNil(correction, @"Correction for valid domain was not nil");
}

- (void)testGetTopLevelDomain
{
    NSString *topLevelDomain = [_emailCorrector topLevelDomainFor:@"john@example.com"];
    STAssertTrue([topLevelDomain isEqualToString:@"com"], @"Incorrect top level domain for john@example.com");
    topLevelDomain = [_emailCorrector topLevelDomainFor:@"john@example.co.uk"];
    STAssertTrue([topLevelDomain isEqualToString:@"co.uk"], @"Incorrect top level domain for john@example.co.uk");
    topLevelDomain = [_emailCorrector topLevelDomainFor:@"John@Example.COM"];
    STAssertTrue([topLevelDomain isEqualToString:@"com"], @"Incorrect top level domain for John@Example.COM");
    topLevelDomain = [_emailCorrector topLevelDomainFor:@"John@alumni.stanford.com"];
    STAssertTrue([topLevelDomain isEqualToString:@"com"], @"Incorrect top level domain for John@alumni.stanford.com");
}

- (void)testCorrectionForInvalidDomain
{
    NSString *correction = [_emailCorrector correctionForDomain:@"con"];
    STAssertTrue([correction isEqualToString:@"com"], @"Correction for '.com' was not '.con'");
    correction = [_emailCorrector correctionForDomain:@"bero"];
    STAssertTrue([correction isEqualToString:@"aero"], @"Correction for '.bero' was not '.aero'");
    correction = [_emailCorrector correctionForDomain:@"bad"];
    STAssertTrue([correction isEqualToString:@"ad"], @"Correction for '.bad' was not '.ad'");
    correction = [_emailCorrector correctionForDomain:@"COn"];
    STAssertTrue([correction isEqualToString:@"com"], @"Correction for '.COn' was not '.com'");
}

- (void)testRunsCorrectionHandler
{
    __block BOOL done = NO;

    NSString *needsCorrection = @"john@domain.con";

    EmailCorrectionHandler correctionHandler = ^(NSString *triedEmail, NSString *correction, NSString *corrected) {
        STAssertTrue([triedEmail isEqualToString:needsCorrection], @"Did not return correct email");
        STAssertTrue([correction isEqualToString:@"com"], @"Did not receive a valid correction");
        STAssertTrue([corrected isEqualToString:@"john@domain.com"], @"Did not correct email properly");
        done = YES;
    };

    [_emailCorrector validateEmailAddress:needsCorrection
                             validHandler:^(NSString *email){
                                 STAssertTrue(FALSE, @"Wrong handler");
                                 done = YES;
                             }
                           invalidHandler:^(NSString *email){
                               STAssertTrue(FALSE, @"Wrong handler");
                               done = YES;
                           }
                        correctionHandler:correctionHandler];

    TEST_WAIT_UNTIL_TRUE(done);
}

- (void)testRunsValidHandler
{
    __block BOOL done = NO;

    NSString *validEmail = @"john@domain.com";

    EmailCorrectionHandler correctionHandler = ^(NSString *triedEmail, NSString *correction, NSString *corrected) {
        STAssertTrue(FALSE, @"Wrong handler");
        done = YES;
    };

    [_emailCorrector validateEmailAddress:validEmail
                             validHandler:^(NSString *email){
                                 STAssertTrue([validEmail isEqualToString:email], @"Email did not match");
                                 done = YES;
                             }
                           invalidHandler:^(NSString *email){
                               STAssertTrue(FALSE, @"Wrong handler");
                               done = YES;
                           }
                        correctionHandler:correctionHandler];

    TEST_WAIT_UNTIL_TRUE(done);
}

- (void)testRunsInvalidHandler
{
    __block BOOL done = NO;

    NSString *invalidEmail = @"johndomain";

    EmailCorrectionHandler correctionHandler = ^(NSString *triedEmail, NSString *correction, NSString *corrected) {
        STAssertTrue(FALSE, @"Wrong handler");
        done = YES;
    };

    [_emailCorrector validateEmailAddress:invalidEmail
                             validHandler:^(NSString *email){
                                 STAssertTrue(FALSE, @"Wrong handler");
                                 done = YES;
                             }
                           invalidHandler:^(NSString *email){
                               STAssertTrue([invalidEmail isEqualToString:email], @"Email did not match");
                               done = YES;
                           }
                        correctionHandler:correctionHandler];

    TEST_WAIT_UNTIL_TRUE(done);
}

@end
