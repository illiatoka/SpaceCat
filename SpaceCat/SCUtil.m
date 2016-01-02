#import "SCUtil.h"

@implementation SCUtil

#pragma mark -
#pragma mark Class Methods

+ (NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random()%(max - min) + min;
}

@end
