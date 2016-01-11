#import "SCHudNode.h"
#import "SCUtil.h"

@implementation SCHudNode

#pragma mark -
#pragma mark Class Methods

+ (instancetype)hudAtPosition:(CGPoint)position inFrame:(CGRect)frame {
    SCHudNode *hud = [self node];
    hud.position = position;
    hud.zPosition = 10;
    hud.name = @"HUD";
    
    SKSpriteNode *catHead = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_cat_1"];
    catHead.position = CGPointMake(30, -10);
    [hud addChild:catHead];
    
    hud.lives = kSCMaxLives;
    
    SKSpriteNode *lastLifeBar;
    
    for (uint count = 0; count < hud.lives; count++) {
        SKSpriteNode *lifeBar = [SKSpriteNode spriteNodeWithImageNamed:@"HUD_life_1"];
        lifeBar.name = [NSString stringWithFormat:@"Life%d", count + 1];
        
        [hud addChild:lifeBar];
        
        if (!lastLifeBar) {
            lifeBar.position = CGPointMake(catHead.position.x + 30, catHead.position.y);
        } else {
            lifeBar.position = CGPointMake(lastLifeBar.position.x + 10, lastLifeBar.position.y);
        }
        
        lastLifeBar = lifeBar;
    }
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    scoreLabel.name = @"Score";
    scoreLabel.text = @"0";
    scoreLabel.fontSize = 24;
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    scoreLabel.position = CGPointMake(frame.size.width -10, -20);
    [hud addChild:scoreLabel];
    
    return hud;
}

#pragma mark -
#pragma mark Public Implementations

- (void)addPoints:(NSUInteger)points {
    self.score += points;
    
    SKLabelNode *scoreLabel = (SKLabelNode *)[self childNodeWithName:@"Score"];
    scoreLabel.text = [NSString stringWithFormat:@"%lu", self.score];
}

- (BOOL)loseLife {
    NSUInteger lives = self.lives;
    if (0 < lives) {
        NSString *lifeNodeName = [NSString stringWithFormat:@"Life%lu",lives];
        SKNode *lifeToRemove = [self childNodeWithName:lifeNodeName];
        [lifeToRemove removeFromParent];
        self.lives--;
    }
    
    return self.lives == 0;
}

@end
