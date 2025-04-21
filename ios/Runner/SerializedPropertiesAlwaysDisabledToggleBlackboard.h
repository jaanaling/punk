#import <Foundation/Foundation.h>
@interface SerializedPropertiesAlwaysDisabledToggleBlackboard : NSObject
- (int)updateRecord:(int)oxidationState role:(int)role;
- (int)parseInput:(int)oxidationState role:(int)role;
- (int)resumeSubscription:(int)oxidationState role:(int)role;
@end