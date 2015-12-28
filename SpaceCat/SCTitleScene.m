#import "SCTitleScene.h"
#import "SCGamePlayScene.h"

@implementation SCTitleScene

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splashScreen"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Implementations

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SCGamePlayScene *gamePlayScene = [SCGamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition flipVerticalWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}

@end
