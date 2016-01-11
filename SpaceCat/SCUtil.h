#import <Foundation/Foundation.h>

static const uint kSCProjectileSpeed    = 400;
static const int kSCSpaceDogMinSpeed    = -150;
static const int kSCSpaceDogMaxSpeed    = -50;
static const uint kSCMaxLives           = 4;
static const uint kSCPointPerHit        = 15;

typedef NS_OPTIONS(uint32_t, SCCollisionCategory) {
    SCCollisionCategoryEnemy        = 1 << 0,
    SCCollisionCategoryProjectile   = 1 << 1,
    SCCollisionCategoryDebris       = 1 << 2,
    SCCollisionCategoryGround       = 1 << 3
};

@interface SCUtil : NSObject

+ (NSInteger)randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
