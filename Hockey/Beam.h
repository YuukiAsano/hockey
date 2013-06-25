//
//  Beam.h
//  Hockey
//
//  Created by 浅野 友希 on 2013/06/05.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Beam : CCNode {
    CCSprite *sprite; //テクスチャを保持
    BOOL isStaged; //画面に表示されているか
    int num;
}

@property (nonatomic, retain)CCSprite *sprite;
@property (nonatomic, readonly)BOOL isStaged;

-(void)goFrom:(CGPoint)position layer: (CCLayer *)layer player_num: (int)player_num;

@end
