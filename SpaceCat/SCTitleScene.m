#import <AVFoundation/AVFoundation.h>

#import "SCTitleScene.h"
#import "SCGamePlayScene.h"

@interface SCTitleScene ()
@property (nonatomic, strong, readwrite)    AVAudioPlayer   *backgroundMusic;
@property (nonatomic, strong, readwrite)    SKAction        *pressStartSFX;

@end

@implementation SCTitleScene

#pragma mark -
#pragma mark Initializations and Deallocations

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    
    if (self) {
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splashScreen"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@"mp3"];
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        self.backgroundMusic.numberOfLoops = -1;
        [self.backgroundMusic prepareToPlay];
    }
    
    return self;
}

#pragma mark -
#pragma mark Private Implementations

- (void)didMoveToView:(SKView *)view {
    [self.backgroundMusic play];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self runAction:self.pressStartSFX];
    [self.backgroundMusic stop];
    
    SCGamePlayScene *gamePlayScene = [SCGamePlayScene sceneWithSize:self.frame.size];
    SKTransition *transition = [SKTransition flipVerticalWithDuration:1.0];
    [self.view presentScene:gamePlayScene transition:transition];
}

@end
