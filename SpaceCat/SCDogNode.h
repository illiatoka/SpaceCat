#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, SCSpaceDogType) {
    SCSpaceDogTypeA,
    SCSpaceDogTypeB
};

@interface SCDogNode : SKSpriteNode

+ (instancetype)spaceDogOfType:(SCSpaceDogType)type;

@end
