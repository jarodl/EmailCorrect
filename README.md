EmailCorrect
============

![Preview](http://s3.amazonaws.com/jarodlrandom/emailcorrect.png)

Intelligently validate email addresses.

## Usage

	EmailCorrect *emailCorrector = [[[EmailCorrect alloc] init] autorelease];

	// Validate an email address, offer a suggestion if the domain is invalid
    EmailCorrectionHandler correctionHandler = ^(NSString *triedEmail, NSString *correction, NSString *email) {
		UIAlertView *alert = [[[UIAlertView alloc] init] autorelease];
		[alert setTitle:[NSString stringWithFormat:@"Did you mean %@?", correction]];
		NSString *message = [NSString stringWithFormat:@"Tried to use the invalid email %@, did you mean %@?", triedEmail, email];
		[alert setMessage:message];
		[alert addButtonWithTitle:@"Yes"];
		[alert addButtonWithTitle:@"No"];
		[alert show];
    };
	EmailValidHandler validHandler = ^(NSString *email) {
		NSLog(@"%@", [NSString stringWithFormat:@"Success! Email address '%@' is valid", email]);
    };
	EmailInvalidHandler invalidHandler = ^(NSString *invalidEmail) {
		NSLog(@"%@", [NSString stringWithFormat:@"Failed! Email address '%@' is invalid", invalidEmail]);
	};
	NSString *needsCorrection = @"john@domain.con";
	// Shows an alert view suggesting the domain be changed to '.com'
    [emailCorrector validateEmailAddress:needsCorrection
                                           validHandler:validHandler
                                         invalidHandler:invalidHandler
                                      correctionHandler:correctionHandler];


### Other utilities

	// Check if an email is valid
	[emailCorrector isValidEmail:@"john@domain.com"];

	// Check if a domain is valid
	[emailCorrector isValidDomain:@".com"];

	// Offer a suggestion for an invalid domain
	NSString *suggestion = [emailCorrector correctionForDomain:@".con"];
	NSLog(@"You typed '.con' did you mean '%@'?", suggestion);
	// Prints
	You typed '.con' did you mean '.com'?
	
