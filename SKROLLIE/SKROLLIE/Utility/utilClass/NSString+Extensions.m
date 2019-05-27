

#import "NSString+Extensions.h"


@implementation NSString (Extensions)


- (NSString *)documentsDirectoryPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];

	return documentsDirectory;
}


- (NSString *)pathInDocumentDirectory {
	NSString *documentsDirectory = [self documentsDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}


- (NSString *)pathInDirectory:(NSString *)dir {
	NSString *documentsDirectory = [self documentsDirectoryPath];
	NSString *dirPath = [documentsDirectory stringByAppendingString:dir];
	NSString *path = [dirPath stringByAppendingString:self];
	
	NSFileManager *manager = [NSFileManager defaultManager];
    [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
	
	return path;
}

- (NSString *)textTrimmed
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)removeWhiteSpace {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}



- (NSString*)stringByNormalizingCharacterInSet:(NSCharacterSet*)characterSet withString:(NSString*)replacement {
	NSMutableString* result = [NSMutableString string];
	NSScanner* scanner = [NSScanner scannerWithString:self];
	while (![scanner isAtEnd]) {
		if ([scanner scanCharactersFromSet:characterSet intoString:NULL]) {
			[result appendString:replacement];
		}
		NSString* stringPart = nil;
		if ([scanner scanUpToCharactersFromSet:characterSet intoString:&stringPart]) {
			[result appendString:stringPart];
		}
	}
			
	return [result copy];
}


- (NSString *)bindSQLCharacters {
	NSString *bindString = self;

	bindString = [bindString stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	
	return bindString;
}


- (NSString *)trimSpaces {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n "]];
}

+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}

// Range must be in {a,b}. Where a is mimimum length and b is max length
+(BOOL)validateForNumericAndCharacets:(NSString*)candidate WithLengthRange:(NSString*)strRange{
	BOOL valid = NO;
	NSCharacterSet *alphaNums = [NSCharacterSet alphanumericCharacterSet];
	NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:candidate];
	BOOL isAlphaNumeric = [alphaNums isSupersetOfSet:inStringSet];
	if(isAlphaNumeric){
		NSString *emailRegex = [NSString stringWithFormat:@"[%@]%@",candidate, strRange]; 
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
		valid =[emailTest evaluateWithObject:candidate];
	}
	return valid;
}

+ (BOOL)isNumericValue:(NSString *)string
{
    BOOL valid=NO;
    NSString *trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSCharacterSet *alphaNums = [NSCharacterSet characterSetWithCharactersInString:@".0123456789"];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:trimmed];
    if ([trimmed length] > 0 ) {
        valid = [alphaNums isSupersetOfSet:inStringSet];
    }
    return valid;
}

+ (BOOL) validateUrl: (NSString *) url 
{
    //@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
    NSString *theURL = @"((w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", theURL]; 
    return [urlTest evaluateWithObject:url];
}

-(NSString *)commaSeparatedAmount {
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle]; // to get commas (or locale equivalent)
    [fmt setMaximumFractionDigits:0]; // to avoid any decimal
    
    NSInteger value = ceil([self floatValue]);
    if(value < 0)
        value *= -1;
    
    NSString *result = [fmt stringFromNumber:@(value)];
    return result;
}

@end