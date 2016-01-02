#import "SCGamePlayScene.h"
#import "SCMachineNode.h"
#import "SCCatNode.h"
#import "SCProjectileNode.h"
#import "SCDogNode.h"
#import "SCGroundNode.h"

@interface SCGamePlayScene ()

- (void)shootProjectileTowardsPosition:(CGPoint)position;

- (void)addSpaceDog;

@end

@implementation SCGamePlayScene

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        SCGroundNode *ground = [SCGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"gamePlayBackground"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        
        SCMachineNode *machine = [SCMachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        [self addChild:machine];
        
        SCCatNode *spaceCat = [SCCatNode catAtPosition:CGPointMake(machine.position.x, machine.position.y -2)];
        [self addChild:spaceCat];
        
        [self addSpaceDog];
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
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
    SCDogNode *spaceDogA = [SCDogNode spaceDogOfType:SCSpaceDogTypeA];
    spaceDogA.position = CGPointMake(100, 300);
    [self addChild:spaceDogA];
    
    SCDogNode *spaceDogB = [SCDogNode spaceDogOfType:SCSpaceDogTypeB];
    spaceDogB.position = CGPointMake(200, 300);
    [self addChild:spaceDogB];
}

@end
