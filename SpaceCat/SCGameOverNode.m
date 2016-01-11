#import "SCGameOverNode.h"

@implementation SCGameOverNode

#pragma mark -
#pragma mark Class Methods

+ (instancetype)gameOverAtPosition:(CGPoint)position {
    SCGameOverNode *gameOver = [self node];
    
    SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
    gameOverLabel.name = @"GameOver";
    gameOverLabel.text = @"Game Over";
    gameOverLabel.fontSize = 48;
    gameOverLabel.position = position;
    [gameOver addChild:gameOverLabel];
    
    return gameOver;
}

@end
