//
//  GlobalFunction.h
//  sactomofo
//
//  Created by Dipak Kasodariya on 18/03/14.
//  Copyright (c) 2014 Dipak Kasodariya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalFunction : NSObject

+ (BOOL)ISinternetConnection;
+ (NSString *)getApplicationName;

+(void)SaveValue :(NSString*) Value key :(NSString *) key;
+(NSString *)GetValueForkey :(NSString*) key;
+(NSMutableDictionary *)checkString:(NSString *)key dic:(NSMutableDictionary *)dic;
@end
