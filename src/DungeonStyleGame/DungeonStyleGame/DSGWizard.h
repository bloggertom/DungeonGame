//
//  DSGWizard.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 17/09/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import "DSGHero.h"

@interface DSGWizard : DSGHero

@property (nonatomic)SKEmitterNode *magicEmitter;

-(id)initatPosition:(CGPoint)position;

+(void)loadAssets;
@end
