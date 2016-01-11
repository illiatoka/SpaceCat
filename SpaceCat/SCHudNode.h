#import <SpriteKit/SpriteKit.h>

@interface SCHudNode : SKNode
@property (nonatomic, assign) NSUInteger lives;
@property (nonatomic, assign) NSUInteger score;

+ (instancetype)hudAtPosition:(CGPoint)position inFrame:(CGRect)frame;

- (void)addPoints:(NSUInteger)points;

- (BOOL)loseLife;

@end
