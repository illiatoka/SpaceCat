#import <SpriteKit/SpriteKit.h>

@interface SCProjectileNode : SKSpriteNode

+ (instancetype)projectileAtPosition:(CGPoint)position;

- (void)moveTowardsPosition:(CGPoint)position;

@end
