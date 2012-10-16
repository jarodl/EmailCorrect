//
//  EmailCorrect.m
//  EmailCorrect
//
//  Created by Jarod Luebbert on 11/19/11.
//  Copyright (c) 2011 Jarod Luebbert. All rights reserved.
//

#import "EmailCorrect.h"
#import "EmailCorrect+Private.h"

@interface EmailCorrect ()
@property (nonatomic, retain) NSSet *topLevelDomains;
@property (nonatomic, retain) NSSet *commonEmailDomains;
@end

@implementation EmailCorrect

#pragma mark - Set up

- (id)init
{
    if ((self = [super init]))
    {
        self.topLevelDomains = [NSSet setWithObjects:@"aero", @"asia", @"biz",
                                @"cat", @"com", @"coop", @"edu", @"gov",
                                @"info", @"int", @"jobs", @"mil", @"mobi",
                                @"museum", @"name", @"net", @"org", @"pro",
                                @"tel", @"travel", @"ac", @"ad", @"ae",
                                @"af", @"ag", @"ai", @"al", @"am", @"an",
                                @"ao", @"aq", @"ar", @"as", @"at", @"au",
                                @"aw", @"ax", @"az", @"ba", @"bb", @"bd",
                                @"be", @"bf", @"bg", @"bh", @"bi", @"bj",
                                @"bm", @"bn", @"bo", @"br", @"bs", @"bt",
                                @"bv", @"bw", @"by", @"bz", @"ca", @"cc",
                                @"cd", @"cf", @"cg", @"ch", @"ci", @"ck",
                                @"cl", @"cm", @"cn", @"co", @"co.uk", @"cr",
                                @"cu", @"cv", @"cx", @"cy", @"cz", @"de",
                                @"dj", @"dk", @"dm", @"do", @"dz", @"ec",
                                @"ee", @"eg", @"er", @"es", @"et", @"eu",
                                @"fi", @"fj", @"fk", @"fm", @"fo", @"fr",
                                @"ga", @"gb", @"gd", @"ge", @"gf", @"gg",
                                @"gh", @"gi", @"gl", @"gm", @"gn", @"gp",
                                @"gq", @"gr", @"gs", @"gt", @"gu", @"gw",
                                @"gy", @"hk", @"hm", @"hn", @"hr", @"ht",
                                @"hu", @"id", @"ie", @"No", @"il", @"im",
                                @"in", @"io", @"iq", @"ir", @"is", @"it",
                                @"je", @"jm", @"jo", @"jp", @"ke", @"kg",
                                @"kh", @"ki", @"km", @"kn", @"kp", @"kr",
                                @"kw", @"ky", @"kz", @"la", @"lb", @"lc",
                                @"li", @"lk", @"lr", @"ls", @"lt", @"lu",
                                @"lv", @"ly", @"ma", @"mc", @"md", @"me",
                                @"mg", @"mh", @"mk", @"ml", @"mm", @"mn",
                                @"mo", @"mp", @"mq", @"mr", @"ms", @"mt",
                                @"mu", @"mv", @"mw", @"mx", @"my", @"mz",
                                @"na", @"nc", @"ne", @"nf", @"ng", @"ni",
                                @"nl", @"no", @"np", @"nr", @"nu", @"nz",
                                @"om", @"pa", @"pe", @"pf", @"pg", @"ph",
                                @"pk", @"pl", @"pm", @"pn", @"pr", @"ps",
                                @"pt", @"pw", @"py", @"qa", @"re", @"ro",
                                @"rs", @"ru", @"rw", @"sa", @"sb", @"sc",
                                @"sd", @"se", @"sg", @"sh", @"si", @"sj",
                                @"sk", @"sl", @"sm", @"sn", @"so", @"sr",
                                @"st", @"su", @"sv", @"sy", @"sz", @"tc",
                                @"td", @"tf", @"tg", @"th", @"tj", @"tk",
                                @"tl", @"tm", @"tn", @"to", @"tp", @"tr",
                                @"tt", @"tv", @"tw", @"tz", @"ua", @"ug",
                                @"uk", @"us", @"uy", @"uz", @"va", @"vc",
                                @"ve", @"vg", @"vi", @"vn", @"vu", @"wf",
                                @"ws", @"ye", @"yt", @"za", @"zm", @"zw",
                                @"xxx",
                                nil];
        self.commonEmailDomains = [NSSet setWithObjects:
                                   @"yahoo.com",
                                   @"msn.com",
                                   @"comcast.net",
                                   @"verizon.net",
                                   @"earthlink.net",
                                   @"icloud.com",
                                   @"gmail.com",
                                   @"aol.com",
                                   @"hotmail.com",
                                   nil];
    }
    
    return self;
}

#pragma mark - Helpers

- (BOOL)isValidEmail:(NSString *)emailAddress;
{
    NSString *regex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; 
    return [test evaluateWithObject:[emailAddress lowercaseString]];
}

- (BOOL)isValidDomain:(NSString *)topLevelDomain
{
    return [_topLevelDomains containsObject:[topLevelDomain lowercaseString]];
}

- (NSString *)correctionForDomain:(NSString *)invalidDomain
{
    NSString *correction = nil;

    if ([self isValidDomain:invalidDomain] == NO)
    {
        int minimumDistance = [invalidDomain length];
        for (NSString *validDomain in [_topLevelDomains allObjects])
        {
            int distance = [self similarityBetween:validDomain and:invalidDomain];
            if (distance < minimumDistance)
            {
                correction = validDomain;
                minimumDistance = distance;
            }
        }
    }
    
    return correction;
}

- (NSString *)topLevelDomainFor:(NSString *)email
{
    NSString *domain = [[[email componentsSeparatedByString:@"@"] lastObject] lowercaseString];
    NSString *result = nil;
    
    do 
    {
        domain = [domain substringFromIndex:[domain rangeOfString:@"."].location + 1];
        
        if ([self isValidDomain:domain] || [domain rangeOfString:@"."].location == NSNotFound)
            result = domain;
    } while (result == nil);
    
    return result;
}

- (int)similarityBetween:(NSString *)firstDomain and:(NSString *)secondDomain
{
    firstDomain = [firstDomain lowercaseString];
    secondDomain = [secondDomain lowercaseString];
    int distances[[firstDomain length] + 1][[secondDomain length] + 1];
    memset(distances, 0, sizeof(distances));
    
    for (int i = 0; i < [firstDomain length] + 1; i++)
        distances[i][0] = i;
    for (int j = 0; j < [secondDomain length] + 1; j++)
        distances[0][j] = j;
    
    for (int j = 1; j < [secondDomain length] + 1; j++)
    {
        for (int i = 1; i < [firstDomain length] + 1; i++)
        {
            NSString *firstLetter = [firstDomain substringWithRange:NSMakeRange(i - 1, 1)];
            NSString *secondLetter = [secondDomain substringWithRange:NSMakeRange(j - 1, 1)];
            if ([firstLetter isEqualToString:secondLetter])
            {
                distances[i][j] = distances[i - 1][j - 1];
            }
            else
            {
                distances[i][j] = MIN(MIN(distances[i - 1][j] + 1,
                                          distances[i][j - 1] + 1),
                                      distances[i - 1][j - 1] + 1);
            }
        }
    }
    
    return distances[[firstDomain length]][[secondDomain length]];
}

- (void)validateEmailAddress:(NSString *)emailAddress
                validHandler:(EmailValidHandler)validHandler
              invalidHandler:(EmailInvalidHandler)invalidHandler
           correctionHandler:(EmailCorrectionHandler)correctionHandler
{
    if ([self isValidEmail:emailAddress])
    {
        NSString *domain = [self topLevelDomainFor:emailAddress];
        if ([self isValidDomain:domain])
        {
            validHandler(emailAddress);
        }
        else
        {
            NSString *correction = [self correctionForDomain:domain];
            NSString *correctedEmail = [emailAddress stringByReplacingOccurrencesOfString:domain
                                                                               withString:correction];
            correctionHandler(emailAddress, correction, correctedEmail);
        }
    }
    else
    {
        invalidHandler(emailAddress);
    }
}

#pragma mark - Clean up

- (void)dealloc
{
    [_topLevelDomains release];
    [_commonEmailDomains release];
    [super dealloc];
}

@end
