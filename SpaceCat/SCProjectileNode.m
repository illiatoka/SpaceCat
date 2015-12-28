#import "SCProjectileNode.h"
#import "SCUtil.h"

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
#pragma mark Public Implementations

- (void)moveTowardsPosition:(CGPoint)position {
    // slope = (Y3 - Y1) / (X3 - X1)
    float slope = (position.y - self.position.y) / (position.x - self.position.x);
    
    // slope = (Y2 - Y1) / (X2 - X1)
    // Y2 - Y1 = slope * (X2 - X1)
    // Y2 = slope * X2 - slope * X1 + Y1
    // X1 or offscreenX
    float offscreenX;
    if (position.x <= self.position.x) {
        offscreenX = -10;
    } else {
        offscreenX = self.parent.frame.size.width + 10;
    }
    // Y2 or offscreenY
    float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
    // Y3 or pointOffscreen
    CGPoint pointOffscreen = CGPointMake(offscreenX, offscreenY);
    
    // A^2 + B^2 = C^2
    // C = sqrt(A^2 + B^2)
    // C or distance
    float distanceA = pointOffscreen.y - self.position.y;
    float distanceB = pointOffscreen.x - self.position.x;
    float distanceC = sqrtf(powf(distanceA, 2) + powf(distanceB, 2));
    
    // distance = speed * time;
    // time = distance / speed;
    float time = distanceC / kSCProjectileSpeed;
    
    SKAction *moveProjectile = [SKAction moveTo:pointOffscreen duration:time];
    [self runAction:moveProjectile];
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
