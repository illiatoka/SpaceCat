#import "SCCatNode.h"

@interface SCCatNode ()
@property (nonatomic, strong, readwrite) SKAction *tapAction;

@end

@implementation SCCatNode

#pragma mark -
#pragma mark Class Methods

+ (instancetype)catAtPosition:(CGPoint)position {
    SCCatNode *spaceCat = [self spriteNodeWithImageNamed:@"spacecat_1"];
    spaceCat.position = position;
    spaceCat.anchorPoint = CGPointMake(0.5, 0);
    spaceCat.name = @"SpaceCat";
    
    return spaceCat;
}

#pragma mark -
#pragma mark Accessors

- (SKAction *)tapAction {
    if (_tapAction != nil) {
        return _tapAction;
    }
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"spacecat_2"],
                          [SKTexture textureWithImageNamed:@"spacecat_1"]];
    
    _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];

    return _tapAction;
}

#pragma mark -
#pragma mark Public Implementations

- (void)performTap {
    [self runAction:self.tapAction];
}

@end
