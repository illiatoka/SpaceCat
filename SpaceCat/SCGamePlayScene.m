#import "SCGamePlayScene.h"
#import "SCMachineNode.h"
#import "SCCatNode.h"
#import "SCProjectileNode.h"
#import "SCDogNode.h"
#import "SCGroundNode.h"
#import "SCUtil.h"

@interface SCGamePlayScene ()
@property (nonatomic, readwrite) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic, readwrite) NSTimeInterval timeSinceEnemyAdded;

- (void)shootProjectileTowardsPosition:(CGPoint)position;
- (void)addSpaceDog;
- (void)debrisAtPosition:(CGPoint)position;

@end

@implementation SCGamePlayScene

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self;
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"gamePlayBackground"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        SCGroundNode *ground = [SCGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        ground.zPosition = 0.1;
        [self addChild:ground];
        
        SCMachineNode *machine = [SCMachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        [self addChild:machine];
        
        SCCatNode *spaceCat = [SCCatNode catAtPosition:CGPointMake(machine.position.x, machine.position.y -2)];
        [self addChild:spaceCat];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Implementations

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint position = [touch locationInNode:self];
        [self shootProjectileTowardsPosition:position];
    }
}

- (void)shootProjectileTowardsPosition:(CGPoint)position {
    SCCatNode *spaceCat = (SCCatNode *)[self childNodeWithName:@"SpaceCat"];
    [spaceCat performTap];
    
    SCMachineNode *machine = (SCMachineNode *)[self childNodeWithName:@"Machine"];
    CGPoint machinePosition = CGPointMake(machine.position.x, machine.position.y + machine.frame.size.height - 15);
    
    SCProjectileNode *projectile = [SCProjectileNode projectileAtPosition:machinePosition];
    [self addChild:projectile];
    [projectile moveTowardsPosition:position];
}

- (void)addSpaceDog {
    NSUInteger randomSpaceDog = [SCUtil randomWithMin:0 max:2];
    float dy = [SCUtil randomWithMin:kSCSpaceDogMinSpeed max:kSCSpaceDogMaxSpeed];
    
    SCDogNode *spaceDog = [SCDogNode spaceDogOfType:randomSpaceDog];
    spaceDog.physicsBody.velocity = CGVectorMake(0, dy);
    
    float y = self.frame.size.height + spaceDog.size.height;
    float x = [SCUtil randomWithMin:spaceDog.size.width + 10
                                max:self.frame.size.width - spaceDog.size.width - 10];
    
    spaceDog.position = CGPointMake(x, y);
    [self addChild:spaceDog];
    
}

- (void)debrisAtPosition:(CGPoint)position {
    NSUInteger numberOfPieces = [SCUtil randomWithMin:5 max:20];
    
    for (NSUInteger count = 0; count < numberOfPieces; count++) {
        NSUInteger randomPiece = [SCUtil randomWithMin:1 max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%lu", (unsigned long)randomPiece];
        
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        debris.name = @"Debri";
        [self addChild:debris];
        
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = SCCollisionCategoryDebris;
        debris.physicsBody.collisionBitMask = SCCollisionCategoryGround | SCCollisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.velocity = CGVectorMake([SCUtil randomWithMin:-150 max:150],
                                                  [SCUtil randomWithMin:150 max:350]);
        
        [debris runAction:[SKAction waitForDuration:2.0] completion:^{
            [debris removeFromParent];
        }];
    }
}

#pragma mark -
#pragma mark RunLoop hooks

- (void)update:(NSTimeInterval)currentTime {
    if (self.lastUpdateTimeInterval) {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
    }
    
    if (1.5 < self.timeSinceEnemyAdded) {
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
}

#pragma mark -
#pragma SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (SCCollisionCategoryEnemy == firstBody.categoryBitMask
        && SCCollisionCategoryProjectile == secondBody.categoryBitMask) {
        SCDogNode *spaceDog = (SCDogNode *)firstBody.node;
        SCProjectileNode *projectile = (SCProjectileNode *)secondBody.node;
        
        [spaceDog removeFromParent];
        [projectile removeFromParent];
    } else if (SCCollisionCategoryEnemy == firstBody.categoryBitMask &&
               SCCollisionCategoryGround == secondBody.categoryBitMask) {
        SCDogNode *spaceDog = (SCDogNode *)firstBody.node;

        [spaceDog removeFromParent];
    }
    
    [self debrisAtPosition:contact.contactPoint];
}

@end
