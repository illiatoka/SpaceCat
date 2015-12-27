#import "SCATitleScene.h"
#import "SCAGamePlayScene.h"

@implementation SCATitleScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splashScreen"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SCAGamePlayScene *gamePlayScene = [SCAGamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition flipVerticalWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}

@end
