#import "SCDogNode.h"
#import "SCUtil.h"

@interface SCDogNode ()
@property (nonatomic, readwrite) SCSpaceDogType type;

- (void)setupPhysicsBody;

@end

@implementation SCDogNode

#pragma mark -
#pragma mark Class Methods

+ (instancetype)spaceDogOfType:(SCSpaceDogType)type {
    SCDogNode *spaceDog = nil;
    NSArray *textures;
    
    if (SCSpaceDogTypeA == type) {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_A_2"]];
        spaceDog.type = SCSpaceDogTypeA;
    } else if (SCSpaceDogTypeB == type) {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_3"]];
        spaceDog.type = SCSpaceDogTypeB;
    }
    
    float scale = [SCUtil randomWithMin:85 max:100] / 100.0f;
    spaceDog.xScale = scale;
    spaceDog.yScale = scale;
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [spaceDog runAction:[SKAction repeatActionForever:animation]];
    
    [spaceDog setupPhysicsBody];
    
    return spaceDog;
}

#pragma mark -
#pragma mark Private Implementations

- (void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = SCCollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = SCCollisionCategoryProjectile | SCCollisionCategoryGround;
}

@end
