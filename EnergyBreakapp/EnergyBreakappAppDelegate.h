//
//  EnergyBreakappAppDelegate.h
//  EnergyBreakapp
//
//  Created by Class Account on 10/10/13.
//  Copyright (c) 2013 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnergyBreakappAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator ;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
