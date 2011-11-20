//
//  EmailCorrectTests.m
//  EmailCorrectTests
//
//  Created by Jarod Luebbert on 11/19/11.
//  Copyright (c) 2011 Jarod Luebbert. All rights reserved.
//

#import "EmailCorrectTests.h"
#import "EmailCorrect.h"

@implementation EmailCorrectTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testIsValidEmail
{
    STAssertTrue([[EmailCorrect sharedInstance] isValidEmail:@"niceandsimple@example.com"], @"Valid email was marked as invalid");
    STAssertTrue([[EmailCorrect sharedInstance] isValidEmail:@"a.little.unusual@example.com"], @"Valid email was marked as invalid");
    STAssertTrue([[EmailCorrect sharedInstance] isValidEmail:@"a.little.more.unusual@dept.example.com"], @"Valid email was marked as invalid");
    STAssertFalse([[EmailCorrect sharedInstance] isValidEmail:@"Abc.example.com"], @"Invalid email was marked as valid");
    STAssertFalse([[EmailCorrect sharedInstance] isValidEmail:@"A@b@c@example.com"], @"Invalid email was marked as valid");
    STAssertFalse([[EmailCorrect sharedInstance] isValidEmail:@"'(),:;<>[\\]@example.com"], @"Invalid email was marked as valid");
}

- (void)testIsValidDomain
{
    STAssertTrue([[EmailCorrect sharedInstance] isValidDomain:@".com"],
                 @"Valid top level domain was marked as invalid");
    STAssertFalse([[EmailCorrect sharedInstance] isValidDomain:@".con"],
                  @"Invalid top level domain was marked as valid");
}

- (void)testSimilarityBetweenDomains
{
    int similarity = [[EmailCorrect sharedInstance] similarityBetween:@".com" and:@".con"];
    STAssertEquals(similarity, 1, @"Similarity between '.com' and '.con' was not 1");
    similarity = [[EmailCorrect sharedInstance] similarityBetween:@".bon" and:@".com"];
    STAssertEquals(similarity, 2, @"Similarity between '.bon' and '.com' was not 2");
    similarity = [[EmailCorrect sharedInstance] similarityBetween:@"sitting" and:@"kitten"];
    STAssertEquals(similarity, 3, @"Similarity between 'sitting' and 'kitten' was not 3");
    similarity = [[EmailCorrect sharedInstance] similarityBetween:@"Saturday" and:@"Sunday"];
    STAssertEquals(similarity, 3, @"Similarity between 'Saturday' and 'Sunday' was not 3");    
}

- (void)testSimilarityForValidDomain
{
    NSString *correction = [[EmailCorrect sharedInstance] correctionForDomain:@".com"];
    STAssertNil(correction, @"Correction for valid domain was not nil");
}

- (void)testCorrectionForInvalidDomain
{
    NSString *correction = [[EmailCorrect sharedInstance] correctionForDomain:@".con"];
    STAssertTrue([correction isEqualToString:@".com"], @"Correction for '.com' was not '.con'");
    correction = [[EmailCorrect sharedInstance] correctionForDomain:@".bero"];
    STAssertTrue([correction isEqualToString:@".aero"], @"Correction for '.bero' was not '.aero'");
    correction = [[EmailCorrect sharedInstance] correctionForDomain:@".bad"];
    STAssertTrue([correction isEqualToString:@".ba"], @"Correction for '.bad' was not '.ba'");
}

@end
