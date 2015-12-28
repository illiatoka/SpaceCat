#import "SCMachineNode.h"

@implementation SCMachineNode

#pragma mark -
#pragma mark Class Methods

+ (instancetype)machineAtPosition:(CGPoint)position {
    SCMachineNode *machine = [self spriteNodeWithImageNamed:@"machine_1"];
    machine.position = position;
    machine.anchorPoint = CGPointMake(0.5, 0);
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"machine_1"],
                          [SKTexture textureWithImageNamed:@"machine_2"]];
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *repeatAnimation = [SKAction repeatActionForever:animation];
    
    [machine runAction:repeatAnimation];
    
    return machine;
}

@end
