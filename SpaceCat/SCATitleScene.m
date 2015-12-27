#import "SCATitleScene.h"

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

@end
