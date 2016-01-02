#import <Foundation/Foundation.h>

static const uint kSCProjectileSpeed = 400;

typedef NS_OPTIONS(uint32_t, SCCollisionCategory) {
    SCCollisionCategoryEnemy        = 1 << 0,
    SCCollisionCategoryProjectile   = 1 << 1,
    SCCollisionCategoryDebris       = 1 << 2,
    SCCollisionCategoryGround       = 1 << 3
};

@interface SCUtil : NSObject

@end
