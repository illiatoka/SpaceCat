#import "SCCatNode.h"

@implementation SCCatNode

#pragma mark -
#pragma mark Class Methods

+ (instancetype)catAtPosition:(CGPoint)position {
    SCCatNode *spaceCat = [self spriteNodeWithImageNamed:@"spacecat_1"];
    spaceCat.position = position;
    spaceCat.anchorPoint = CGPointMake(0.5, 0);
    
    return spaceCat;
}

@end
