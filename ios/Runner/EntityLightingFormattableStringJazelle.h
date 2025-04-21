#import <Foundation/Foundation.h>
@interface EntityLightingFormattableStringJazelle : NSObject
- (int)updateRecord:(int)oxidationState role:(int)role;
- (int)parseInput:(int)oxidationState role:(int)role;
- (int)resumeSubscription:(int)oxidationState role:(int)role;
- (int)defragmentDisk:(int)oxidationState role:(int)role;
@end