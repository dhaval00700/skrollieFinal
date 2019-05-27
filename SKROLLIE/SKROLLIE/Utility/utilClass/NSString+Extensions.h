//
//  NSString+Extensions.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Extensions)

- (NSString *)documentsDirectoryPath;
- (NSString *)pathInDocumentDirectory;
- (NSString *)pathInDirectory:(NSString *)dir;
- (NSString *)removeWhiteSpace;
- (NSString*)stringByNormalizingCharacterInSet:(NSCharacterSet*)characterSet withString:(NSString*)replacement;
- (NSString *)bindSQLCharacters;
- (NSString *)trimSpaces;
- (NSString *)textTrimmed;

+ (BOOL)validateEmail: (NSString *) candidate;
+ (BOOL)validateForNumericAndCharacets:(NSString*)candidate WithLengthRange:(NSString*)strRange;
+ (BOOL)isNumericValue:(NSString *)string;
+ (BOOL)validateUrl: (NSString *) url;

- (NSString *)commaSeparatedAmount;

@end
