#import <AVFoundation/AVFoundation.h>

#import "SCGamePlayScene.h"
#import "SCMachineNode.h"
#import "SCCatNode.h"
#import "SCProjectileNode.h"
#import "SCDogNode.h"
#import "SCGroundNode.h"
#import "SCHudNode.h"
#import "SCGameOverNode.h"
#import "SCUtil.h"

@interface SCGamePlayScene ()
@property (nonatomic, readwrite)    NSTimeInterval  lastUpdateTimeInterval;
@property (nonatomic, readwrite)    NSTimeInterval  timeSinceEnemyAdded;
@property (nonatomic, readwrite)    NSTimeInterval  totalGameTime;
@property (nonatomic, readwrite)    NSInteger       minSpeed;
@property (nonatomic, readwrite)    NSTimeInterval  addEnemyTimeInterval;

@property (nonatomic, strong, readwrite)    SKAction    *damageSFX;
@property (nonatomic, strong, readwrite)    SKAction    *explodeSFX;
@property (nonatomic, strong, readwrite)    SKAction    *laserSFX;

@property (nonatomic, strong, readwrite)    AVAudioPlayer   *backgroundMusic;

@property (nonatomic, readwrite)    BOOL    gameOver;
@property (nonatomic, readwrite)    BOOL    restart;

- (void)setupSounds;
- (void)shootProjectileTowardsPosition:(CGPoint)position;
- (void)addSpaceDog;
- (void)debrisAtPosition:(CGPoint)position;
- (void)addPoints:(NSUInteger)points;
- (void)loseLife;
- (void)performGameOver;

@end

@implementation SCGamePlayScene

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        self.addEnemyTimeInterval = 1.5;
        self.totalGameTime = 0;
        self.minSpeed = kSCSpaceDogMinSpeed;
        self.gameOver = NO;
        self.restart = NO;
        
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);
        self.physicsWorld.contactDelegate = self;
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"gamePlayBackground"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        SCGroundNode *ground = [SCGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        
        SCMachineNode *machine = [SCMachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        [self addChild:machine];
        
        SCCatNode *spaceCat = [SCCatNode catAtPosition:CGPointMake(machine.position.x, machine.position.y -2)];
        [self addChild:spaceCat];
        
        SCHudNode *hud = [SCHudNode hudAtPosition:CGPointMake(0, self.frame.size.height - 20) inFrame:self.frame];
        [self addChild:hud];
        
        [self setupSounds];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Implementations

- (void)didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.gameOver) {
        for (UITouch *touch in touches) {
            CGPoint position = [touch locationInNode:self];
            [self shootProjectileTowardsPosition:position];
            [self runAction:self.laserSFX];
        }
    } else if (self.restart) {
        SCGamePlayScene *scene = [SCGamePlayScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}

- (void)setupSounds {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
    
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic prepareToPlay];
    
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
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

- (void)addPoints:(NSUInteger)points {
    SCHudNode *hud = (SCHudNode *)[self childNodeWithName:@"HUD"];
    [hud addPoints:points];
}

- (void)loseLife {
    SCHudNode *hud = (SCHudNode *)[self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
}

- (void)performGameOver {
    SCGameOverNode *gameOver = [SCGameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame),
                                                                              CGRectGetMidY(self.frame))];
    [self addChild:gameOver];
}

#pragma mark -
#pragma mark RunLoop hooks

- (void)update:(NSTimeInterval)currentTime {
    if (self.lastUpdateTimeInterval) {
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    }
    
    if (self.addEnemyTimeInterval < self.timeSinceEnemyAdded) {
        [self addSpaceDog];
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
    
    if (480 < self.totalGameTime) {
        // 480 / 60 = 8 minutes
        self.addEnemyTimeInterval = 0.50;
        self.minSpeed = -160;
    } else if (240 < self.totalGameTime) {
        // 240 // 60 = 4 minutes
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
    } else if (120 < self.totalGameTime) {
        // 120 // 60 = 2 minutes
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = -125;
    } else if (30 < self.totalGameTime) {
        self.addEnemyTimeInterval = 1.00;
        self.minSpeed = -100;
    }
    
    if (self.gameOver) {
        [self performGameOver];
    }
}

#pragma mark -
#pragma mark SKPhysicsContactDelegate

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
        
        [self runAction:self.explodeSFX];
        [spaceDog removeFromParent];
        [projectile removeFromParent];
        
        [self addPoints:kSCPointPerHit];
    } else if (SCCollisionCategoryEnemy == firstBody.categoryBitMask &&
               SCCollisionCategoryGround == secondBody.categoryBitMask) {
        SCDogNode *spaceDog = (SCDogNode *)firstBody.node;
        
        [self runAction:self.damageSFX];
        [spaceDog removeFromParent];
        
        [self loseLife];
    }
    
    [self debrisAtPosition:contact.contactPoint];
}

@end
