#import "SCProjectileNode.h"

@interface SCProjectileNode ()

- (void)setupAnimation;

@end

@implementation SCProjectileNode

#pragma mark -
#pragma mark Class Methods

+ (instancetype)projectileAtPosition:(CGPoint)position {
    SCProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
    projectile.position = position;
    projectile.name = @"Projectile";
    
    [projectile setupAnimation];
    
    return projectile;
}

#pragma mark -
#pragma mark Private Implementations

- (void)setupAnimation {
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"projectile_1"],
                          [SKTexture textureWithImageNamed:@"projectile_2"],
                          [SKTexture textureWithImageNamed:@"projectile_3"]];
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    SKAction *repeatAnimation = [SKAction repeatActionForever:animation];
    
    [self runAction:repeatAnimation];
}

@end
