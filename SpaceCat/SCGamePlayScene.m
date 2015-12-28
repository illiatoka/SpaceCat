#import "SCGamePlayScene.h"
#import "SCMachineNode.h"
#import "SCCatNode.h"
#import "SCProjectileNode.h"

@interface SCGamePlayScene ()

- (void)shootProjectileTowardsPosition:(CGPoint)position;

@end

@implementation SCGamePlayScene

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"gamePlayBackground"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
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
    
    SCProjectileNode *projectile = [SCProjectileNode projectileAtPosition:position];
    [self addChild:projectile];
}

@end
