#import "SCGroundNode.h"
#import "SCUtil.h"

@interface SCGroundNode ()

- (void)setupPhysicsBody;

@end

@implementation SCGroundNode

#pragma mark -
#pragma mark Class Methods

+ (instancetype)groundWithSize:(CGSize)size {
    SCGroundNode *ground = [self spriteNodeWithTexture:NULL size:size];
    
    ground.position = CGPointMake(size.width/2, size.height/2);
    ground.name = @"Ground";
    
    [ground setupPhysicsBody];
    
    return ground;
}

#pragma mark -
#pragma mark Private Implementations

- (void)setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    self.physicsBody.categoryBitMask = SCCollisionCategoryGround;
    self.physicsBody.collisionBitMask = SCCollisionCategoryDebris;
    self.physicsBody.contactTestBitMask = SCCollisionCategoryEnemy;
}

@end
