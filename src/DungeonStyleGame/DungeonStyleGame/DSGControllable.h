//
//  DSGControllable.h
//  DungeonStyleGame
//
//  Created by Thomas Wilson on 08/10/2013.
//  Copyright (c) 2013 Thomas Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DSGControllable <NSObject>

@property(nonatomic)CGPoint targetLocation;
@property(nonatomic)CGPoint targetDirection;



@end
