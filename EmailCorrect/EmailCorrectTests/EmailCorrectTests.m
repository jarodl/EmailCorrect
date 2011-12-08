//
//  EmailCorrectTests.m
//  EmailCorrectTests
//
//  Created by Jarod Luebbert on 11/19/11.
//  Copyright (c) 2011 Jarod Luebbert. All rights reserved.
//

#import "EmailCorrectTests.h"
#import "EmailCorrect.h"

// via http://mrox.net/blog/2011/08/04/a-tip-for-testing-block-based-apis/
#define TEST_WAIT_UNTIL_TRUE_SLEEP_SECONDS (0.25)
#define TEST_WAIT_UNTIL_TRUE(expr) \
while( (expr) == NO ) [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:TEST_WAIT_UNTIL_TRUE_SLEEP_SECONDS]];

@implementation EmailCorrectTests

@synthesize emailCorrector;

- (void)setUp
{
    [super setUp];
    self.emailCorrector = [[EmailCorrect alloc] init];
}

- (void)tearDown
{
    self.emailCorrector = nil;
    [super tearDown];
}

- (void)testIsValidEmail
{
    STAssertTrue([emailCorrector isValidEmail:@"niceandsimple@example.com"], @"Valid email was marked as invalid");
    STAssertTrue([emailCorrector isValidEmail:@"a.little.unusual@example.com"], @"Valid email was marked as invalid");
    STAssertTrue([emailCorrector isValidEmail:@"a.little.more.unusual@dept.example.com"], @"Valid email was marked as invalid");
    STAssertFalse([emailCorrector isValidEmail:@"Abc.example.com"], @"Invalid email was marked as valid");
    STAssertFalse([emailCorrector isValidEmail:@"A@b@c@example.com"], @"Invalid email was marked as valid");
    STAssertFalse([emailCorrector isValidEmail:@"'(),:;<>[\\]@example.com"], @"Invalid email was marked as valid");
}

- (void)testUppercaseLettersInEmailRemainValid
{
    STAssertTrue([emailCorrector isValidEmail:@"niceandsimple@Example.com"], @"Valid email was marked as invalid");
    STAssertTrue([emailCorrector isValidEmail:@"A.Little.Unusual@ExaMplE.Com"], @"Valid email was marked as invalid");
}

- (void)testIsValidDomain
{
    STAssertTrue([emailCorrector isValidDomain:@".com"],
                 @"Valid top level domain was marked as invalid");
    STAssertTrue([emailCorrector isValidDomain:@".COM"],
                 @"Valid top level domain was marked as invalid");
    STAssertFalse([emailCorrector isValidDomain:@".con"],
                  @"Invalid top level domain was marked as valid");
}

- (void)testSimilarityBetweenDomains
{
    int similarity = [emailCorrector similarityBetween:@".com" and:@".con"];
    STAssertEquals(similarity, 1, @"Similarity between '.com' and '.con' was not 1");
    similarity = [emailCorrector similarityBetween:@".COM" and:@".com"];
    STAssertEquals(similarity, 0, @"Similarity between '.COM' and '.com' was not 0");
    similarity = [emailCorrector similarityBetween:@".bon" and:@".com"];
    STAssertEquals(similarity, 2, @"Similarity between '.bon' and '.com' was not 2");
    similarity = [emailCorrector similarityBetween:@"sitting" and:@"kitten"];
    STAssertEquals(similarity, 3, @"Similarity between 'sitting' and 'kitten' was not 3");
    similarity = [emailCorrector similarityBetween:@"Saturday" and:@"Sunday"];
    STAssertEquals(similarity, 3, @"Similarity between 'Saturday' and 'Sunday' was not 3");    
}

- (void)testSimilarityForValidDomain
{
    NSString *correction = [emailCorrector correctionForDomain:@".com"];
    STAssertNil(correction, @"Correction for valid domain was not nil");
    correction = [emailCorrector correctionForDomain:@".COM"];
    STAssertNil(correction, @"Correction for valid domain was not nil");
}

- (void)testGetTopLevelDomain
{
    NSString *topLevelDomain = [emailCorrector topLevelDomainFor:@"john@example.com"];
    STAssertTrue([topLevelDomain isEqualToString:@".com"], @"Incorrect top level domain for john@example.com");
    topLevelDomain = [emailCorrector topLevelDomainFor:@"john@example.co.uk"];
    STAssertTrue([topLevelDomain isEqualToString:@".co.uk"], @"Incorrect top level domain for john@example.co.uk");
    topLevelDomain = [emailCorrector topLevelDomainFor:@"John@Example.COM"];
    STAssertTrue([topLevelDomain isEqualToString:@".com"], @"Incorrect top level domain for John@Example.COM");
}

- (void)testCorrectionForInvalidDomain
{
    NSString *correction = [emailCorrector correctionForDomain:@".con"];
    STAssertTrue([correction isEqualToString:@".com"], @"Correction for '.com' was not '.con'");
    correction = [emailCorrector correctionForDomain:@".bero"];
    STAssertTrue([correction isEqualToString:@".aero"], @"Correction for '.bero' was not '.aero'");
    correction = [emailCorrector correctionForDomain:@".bad"];
    STAssertTrue([correction isEqualToString:@".ba"], @"Correction for '.bad' was not '.ba'");
    correction = [emailCorrector correctionForDomain:@".COn"];
    STAssertTrue([correction isEqualToString:@".com"], @"Correction for '.COn' was not '.com'");
}

- (void)testRunsCorrectionHandler
{
    __block BOOL done = NO;
    
    NSString *needsCorrection = @"john@domain.con";
    
    EmailCorrectionHandler correctionHandler = ^(NSString *triedEmail, NSString *correction, NSString *corrected) {
        STAssertTrue([triedEmail isEqualToString:needsCorrection], @"Did not return correct email");
        STAssertTrue([correction isEqualToString:@".com"], @"Did not receive a valid correction");
        STAssertTrue([corrected isEqualToString:@"john@domain.com"], @"Did not correct email properly");
        done = YES;
    };
    
    [emailCorrector validateEmailAddress:needsCorrection
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
    
    [emailCorrector validateEmailAddress:validEmail
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
    
    [emailCorrector validateEmailAddress:invalidEmail
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
