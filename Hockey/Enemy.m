//
//  Enemy.m
//  Hockey
//
//  Created by 浅野 友希 on 2013/06/06.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "GameScene.h"

@implementation Enemy
@synthesize sprite, isStaged, radius, num;

-(id)init{
    self = [super init];
    if(self){
        self.sprite = [CCSprite spriteWithFile: @"enemy.png"];
        [self addChild:self.sprite];
        radius = ENEMY_DEFAULT_RADIUS;;
        
        isStaged = NO;
    }
    return self;
}

-(void)dealloc{
    self.sprite = nil;
    [super dealloc];
}

-(void)moveFrom:(CGPoint)position velocity:(float)velocity layer:(CCLayer *)layer player_num:(int)player_num{
    
    self.position = position;
    life = 2.0f; //耐久力は大きさで決定します
    
    self.num = player_num;
    
    //ゲームがにぎやかになるようスプライトに色を重ねます
    self.sprite.color = ccc3(CCRANDOM_0_1()*255, CCRANDOM_0_1()*255, CCRANDOM_0_1()*255);
    
    //回転するアニメーションを作成
    float rotateDuration = CCRANDOM_0_1() * 10 + 1; //回転スピード
    id rotateForever = [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:rotateDuration angle:360]];
    
    //画面横へ移動するアニメーションを作成
    float winWidth = [[CCDirector sharedDirector] winSize].height;
    float duration = winWidth / velocity; //移動スピード
    id move;
    
    if(self.num == 1){
      move = [CCMoveTo actionWithDuration:duration position:ccp(self.position.x, [[CCDirector sharedDirector] winSize].height)];
    }if(self.num == 2){
      move = [CCMoveTo actionWithDuration:duration position:ccp(self.position.x, -radius)];
    }
    
    //アニメーションを自分自身に設定し、レイヤー上で動作開始
    [self runAction:rotateForever];
    [self runAction:move];
    
    [self scheduleUpdate];
    [layer addChild:self];
    isStaged = YES;
    
}

-(void)removeFromParentAndCleanup:(BOOL)cleanup {
    //画面から除外するときに、プロパティもリセットしておきます
    self.position = CGPointZero;
    radius = ENEMY_DEFAULT_RADIUS;
    isStaged = NO;
    
    //リセット後、オーバーライドした元の処理を呼びます
    [super removeFromParentAndCleanup:cleanup];
}

-(BOOL)hitIfCollided:(CGPoint)position {
    //座標との距離が自分のサイズよりも小さい場合は当たったとみなします
    BOOL isHit = ccpDistance(self.position, position) < radius;
    if(isHit){
        [self gotHit:position];
    }
    return isHit;
}

-(void)gotHit:(CGPoint)position {
    life--;
    if(life <= 0){
        [self removeFromParentAndCleanup:YES]; //スケジュールも解除
        isStaged = NO;
        return;
    }
}

-(void)update:(ccTime)dt {
    CGSize size = [[CCDirector sharedDirector] winSize];
    //消える処理
    if((self.position.y > size.height - 73) || (self.position.y < 73 )){
        if(num == 1){
          [[GameScene sharedInstance] gameover];
        }else if(num == 2){
          [[GameScene sharedInstance] gameover];
        }
        [self removeFromParentAndCleanup:YES]; //スケジュールも解除
        isStaged = NO;
        return;
    }
    //地面に衝突したかどうかを自機クラスに判定してもらいます。
    //self.positionだと隕石の中心になるため、半径を引いて下端で判定します。
    CGPoint position = ccp(self.position.x, self.position.y);
    /*
    BOOL isHit = [[GameScene sharedInstance].player hitIfCollided:position];
    if(isHit){
        [self removeFromParentAndCleanup:YES];
    }
     */
}


@end
