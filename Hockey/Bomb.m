//
//  Bomb.m
//  Hockey
//
//  Created by 浅野 友希 on 2013/06/06.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Bomb.h"
#import "GameScene.h"

@implementation Bomb
@synthesize sprite, isStaged;

-(id)init{
    self = [super init];
    if(self){
        self.sprite = [CCSprite spriteWithFile:@"bomb.png"];
		self.sprite.rotation = 0;
        [self addChild:self.sprite];
        isStaged = NO;
    }
    return self;
}


-(void)dealloc{
    self.sprite = nil;
    [super dealloc];
}

-(void)goFrom:(CGPoint)position layer:(CCLayer *)layer player_num:(int)player_num {
    self.position = position;
    [layer addChild:self];
    isStaged = YES;
    num = player_num;
    [self scheduleUpdate];
}

-(void)update:(ccTime)dt {
    //画面外に出ていたらレイヤーから取り除く
    CGSize size = [[CCDirector sharedDirector] winSize];
    if((self.position.y > 73) || (self.position.y < 73 )){
        [self removeFromParentAndCleanup:YES]; //スケジュールも解除
        isStaged = NO;
        return;
    }
    
    BOOL isHit = NO;
    
    if(num == 1){
      isHit = [[GameScene sharedInstance].player2 hitIfCollided:self.position player_num:1 item_num:2];
    }else if(num == 2){
      isHit = [[GameScene sharedInstance].player1 hitIfCollided:self.position player_num:2 item_num:2];
    }
    //当たり判定のチェック
    if(isHit){
        [self removeFromParentAndCleanup:YES]; //イベントも同時に停止
        isStaged = NO;
        return;
    }
    
    //新しい座標を計算
    float dy;
    if(num == 1){
        dy = 320 * dt;
    }else if (num == 2) {
        dy = -320 * dt;
    }
    float newy = self.position.y + dy;
    self.position = ccp(self.position.x, newy);
}
@end
