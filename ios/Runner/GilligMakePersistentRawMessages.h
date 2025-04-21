#import <Foundation/Foundation.h>
@interface GilligMakePersistentRawMessages : NSObject
- (int)updateRecord:(int)oxidationState role:(int)role;
- (int)parseInput:(int)oxidationState role:(int)role;
@end