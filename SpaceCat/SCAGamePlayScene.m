#import "SCAGamePlayScene.h"

@implementation SCAGamePlayScene

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"gamePlayBackground"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        SKSpriteNode *machine = [SKSpriteNode spriteNodeWithImageNamed:@"machine_1"];
        machine.position = CGPointMake(CGRectGetMidX(self.frame), 12);
        machine.anchorPoint = CGPointMake(0.5, 0);
        [self addChild:machine];
    }
    
    return self;
}

@end
