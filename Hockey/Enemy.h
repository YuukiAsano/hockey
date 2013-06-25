//
//  Enemy.h
//  Hockey
//
//  Created by 浅野 友希 on 2013/06/06.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define ENEMY_DEFAULT_RADIUS 23;
@interface Enemy : CCNode {
    CCSprite *sprite; //テクスチャを保持
    BOOL isStaged;
    //敵キャラクターのプロパティ
    float radius; //大きさ(半径)
    NSInteger life; //耐久力
    float speed; //移動スピード
    int num;
}
@property (nonatomic, retain)CCSprite *sprite;
@property (nonatomic, readonly)BOOL isStaged;
@property (nonatomic, readonly)float radius;
@property int num;

//指定したプロパティレイヤー上で動作開始
-(void)moveFrom:(CGPoint)position
       velocity:(float)velocity
          layer:(CCLayer *)layer
    player_num:(int)player_num;

//指定された座標に対して衝突しているかどうか判定
-(BOOL)hitIfCollided:(CGPoint)position;

@end
