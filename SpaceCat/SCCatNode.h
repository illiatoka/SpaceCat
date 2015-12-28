#import <SpriteKit/SpriteKit.h>

@interface SCCatNode : SKSpriteNode

+ (instancetype)catAtPosition:(CGPoint)position;

- (void)performTap;

@end
