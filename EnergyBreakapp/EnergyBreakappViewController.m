//
//  EnergyBreakappViewController.m
//  EnergyBreakapp
//
//  Created by Class Account on 10/10/13.
//  Copyright (c) 2013 UC Berkeley. All rights reserved.
//

#import "EnergyBreakappViewController.h"

@interface EnergyBreakappViewController ()

@end

@implementation EnergyBreakappViewController
@synthesize currentDistribution;
@synthesize batteryView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    /* Here the app first checks the stored data to see if the app has been used before.
     It stores the total value of each energy source over the lifetime of the app and can be used
     to display the user's total consumption of each kind of fuel. The total is updated in
     BatteryStateDidChange below, when the phone is unplugged. Since the app currently cannot detect
     if the phone is unplugged unless the app is in the background, this currently does nothing.
     However, if desired, the same code could be used for the same purpose elsewhere. */
    
    if (![standardUserDefaults objectForKey:@"totalPercentage"]) {
        totalCoalPercentage = 0.0;
        totalGasPercentage = 0.0;
        totalHydroPercentage = 0.0;
        totalNuclearPercentage = 0.0;
        totalOilPercentage = 0.0;
        totalRenewablePercentage = 0.0;
        totalPercentage = 0.0;
    }
    else
    {
        totalCoalPercentage = [standardUserDefaults doubleForKey:@"totalCoal"];
        totalGasPercentage = [standardUserDefaults doubleForKey:@"totalGas"];
        totalHydroPercentage = [standardUserDefaults doubleForKey:@"totalHydro"];
        totalNuclearPercentage = [standardUserDefaults doubleForKey:@"totalNuclear"];
        totalOilPercentage = [standardUserDefaults doubleForKey:@"totalOil"];
        totalRenewablePercentage = [standardUserDefaults doubleForKey:@"totalRenewable"];
        totalPercentage = [standardUserDefaults doubleForKey:@"totalPercentage"];
        startCharge = [standardUserDefaults doubleForKey:@"startCharge"];

    }
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryStateDidChange:)
                                                 name:UIDeviceBatteryStateDidChangeNotification
                                               object:nil];
    
    //sample values for testing
    startCharge = 0;
    currentCoalPercentage = 0.5;
    currentOilPercentage = 0.0;
    currentGasPercentage = 0.299;
    currentNuclearPercentage = 0;
    currentHydroPercentage = 0.1;
    currentGeothermalPercentage = 0;
    currentRenewablePercentage = 0.0;
    currentWindPercentage = 0.01;
    currentSolarPercentage = 0.1;
    currentBiomassPercentage = 0;
    currentOtherPercentage = 0.0 ;
    currentTotalPercentage = 1;
    
    //save current values for previous charge
    //should check to see if there are values for previous variables. Patched for now
    [batteryView setPreviousDistributionForCoal:currentCoalPercentage Oil:currentOilPercentage Gas:currentGasPercentage Nuclear:currentNuclearPercentage Hydro:currentHydroPercentage Renewable:currentRenewablePercentage Other:currentOtherPercentage Geothermal:currentGeothermalPercentage Wind:currentWindPercentage Solar:currentSolarPercentage Biomass:currentBiomassPercentage Biogas:currentBiogasPercentage AndTotal:currentTotalPercentage];
    
    isCharging = NO;
    
    /*Adding swipe gesture recognisers. If the user swipes right, it shows her previous energy mix.
     If she swipes left (after swiping right) it shows her next one
     THIS CURRENTLY DOES NOT WORK BECAUSE IT IS USING THE OLD MODEL IN WHICH ONLY THE ZIP CODE OF
     EACH DISTRIBUTION WAS RECORDED. TO MAKE THIS WORK, EnergyBreakapp.xcdatamodel WILL NEED TO BE
     MODIFIED SO THAT EACH ENERGY DISTRIBUTION CONTAINS AN EnergyDistribution.
     Uncomment the following code to have left and right swiping gestures recognised */
    
    
    /*
    //The following code taken from http://www.altinkonline.nl/tutorials/xcode/gestures/swipe-gesture-for-ios-apps/
    UISwipeGestureRecognizer *oneFingerSwipeLeft = [[UISwipeGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(oneFingerSwipeLeft:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(oneFingerSwipeRight:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:oneFingerSwipeRight];
     */
    
    //Uncomment the following lines and delete the one before this comment when you want the phone to check if it is charging before updating the location.
    /*if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging)
    {
        isCharging = YES;
    }*/
    
    locationManager.delegate = self;
    
    //CHANGE THE ACCURACY!
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //NSLog(@"View finished loading");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer {
    //NSLog(@"Swiped left");
    if (currentDistribution != nil && [currentDistribution valueForKey:@"nextDistribution"] != nil) {
        currentDistribution = [currentDistribution valueForKey:@"nextDistribution"];
        [self setDistributionDisplay:currentDistribution];
        /*int zip = [[currentDistribution valueForKey:@"zip"] integerValue];
        distribution = [[EnergyDistribution alloc] initWithZipCode:zip];
        [self setPercentages];
        NSString *currentCity = [currentDistribution valueForKey:@"city"];
        NSString *currentState = [currentDistribution valueForKey:@"state"];
        NSDate *currentDate = [currentDistribution valueForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString *formattedDateString = [dateFormatter stringFromDate:currentDate];
        _locationText.textAlignment = NSTextAlignmentCenter;
        NSString *cityAndState = [NSString stringWithFormat: @"%@, %@", currentCity, currentState];
        [_locationText setText:cityAndState];
        [_dateText setText:formattedDateString];*/
    }
}

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer {
    //NSLog(@"Swiped right");
    if (currentDistribution != nil) {
        if ([currentDistribution valueForKey:@"previousDistribution"] != nil) {
            currentDistribution = [currentDistribution valueForKey:@"previousDistribution"];
            [self setDistributionDisplay:currentDistribution];
            /*int zip = [[currentDistribution valueForKey:@"zip"] integerValue];
            NSLog(@"Zip coming out is %i", ([[currentDistribution valueForKey:@"zip"] integerValue]));
            distribution = [[EnergyDistribution alloc] initWithZipCode:zip];
            [self setPercentages];
            NSString *currentCity = [currentDistribution valueForKey:@"city"];
            NSString *currentState = [currentDistribution valueForKey:@"state"];
            NSDate *currentDate = [currentDistribution valueForKey:@"date"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            NSString *formattedDateString = [dateFormatter stringFromDate:currentDate];
            NSString *cityAndState = [NSString stringWithFormat: @"%@, %@", currentCity, currentState];
            _locationText.textAlignment = NSTextAlignmentCenter;
            _dateText.textAlignment = NSTextAlignmentCenter;
            [_locationText setText:cityAndState];
            [_dateText setText:formattedDateString];*/
        }
    }
    else {
        [self getUpdatedData];
        currentDistribution = [fetchedObjects lastObject];
        if ([currentDistribution valueForKey:@"city"]) {
            [self setDistributionDisplay:currentDistribution];
        }
    }
    
    
}


/*To have the gesture swiping recognised, after modifying the model and adding the EnergyDistribution (as mentioned in viewDidLoad), set distribution to the saved EnergyDistribution and then call [self setPercentages], then uncomment the following code*/

/*
- (void) setDistributionDisplay:(NSManagedObject*) savedDistribution {
    int zip = [[savedDistribution valueForKey:@"zip"] integerValue];
    NSLog(@"Zip coming out is %i", ([[savedDistribution valueForKey:@"zip"] integerValue]));
    distribution = [[EnergyDistribution alloc] initWithZipCode:zip];
    NSLog(@"Total percentage is %f", [distribution totalPercentages]);
    [self setPercentages];
    NSString *currentCity = [savedDistribution valueForKey:@"city"];
    NSString *currentState = [savedDistribution valueForKey:@"state"];
    NSDate *currentDate = [savedDistribution valueForKey:@"date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:currentDate];
    NSString *cityAndState = [NSString stringWithFormat: @"%@, %@", currentCity, currentState];
    _locationText.textAlignment = NSTextAlignmentCenter;
    _dateText.textAlignment = NSTextAlignmentCenter;
    [_locationText setText:cityAndState];
    [_dateText setText:formattedDateString];
}
*/

//works when app is in foreground
- (void)batteryStateDidChange:(NSNotification *)notification {
    if (([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging)) {
        isCharging = YES;
        
        NSLog(@"Now charging");
        
        UIAlertView *chargingAlert = [[UIAlertView alloc] initWithTitle:@"Charging" message:@"Your device is now charging" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [chargingAlert show];
        
        /*NSLog(@"startCharge: %f, currentCharge: %f, currentCoal: %f, currentOil: %f, currentGas: %f, currentNuclear, %f, currentHydro: %f, currentRenewable: %f, currentOther: %f, currentGeothermal: %f, currentWind: %f, currentSolar: %f, currentBiomass: %f, currentBiogas: %f, currentTotal: %f", startCharge, [[UIDevice currentDevice] batteryLevel], currentCoalPercentage, currentOilPercentage, currentGasPercentage, currentNuclearPercentage, currentHydroPercentage, currentRenewablePercentage, currentOtherPercentage, currentGeothermalPercentage, currentWindPercentage, currentSolarPercentage, currentBiomassPercentage, currentBiogasPercentage, currentTotalPercentage);*/
        
        //get new values for current charge
        [self clearLocation];
        
        _startDate = [NSDate date];
        _startChargePercentage = [[UIDevice currentDevice] batteryLevel];
        startCharge = [[UIDevice currentDevice] batteryLevel];
        
        //commented out for now
        //[locationManager startUpdatingLocation];
        
        //sample values
        currentCoalPercentage = 0.1;
        currentOilPercentage = 0.2;
        currentGasPercentage = 0.0;
        currentNuclearPercentage = 0.5;
        currentHydroPercentage = 0;
        currentGeothermalPercentage = 0;
        currentWindPercentage = 0.2;
        currentSolarPercentage = 0.0;
        currentBiomassPercentage = 0;
        currentOtherPercentage = 0;
        currentTotalPercentage = 1;
        
        /*
            NSLog(@"Device is charging");
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
            [locationManager startUpdatingLocation];
        */
        
        
        /*NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setDouble:currentCoalPercentage forKey:@"currentCoal"];
        [standardUserDefaults setDouble:currentGasPercentage forKey:@"currentGas"];
        [standardUserDefaults setDouble:currentHydroPercentage forKey:@"currentHyrdo"];
        [standardUserDefaults setDouble:currentNuclearPercentage forKey:@"currentNuclear"];
        [standardUserDefaults setDouble:currentOilPercentage forKey:@"currentOil"];
        [standardUserDefaults setDouble:currentRenewablePercentage forKey:@"currentRenewable"];
        [standardUserDefaults setDouble:currentTotalPercentage forKey:@"currentTotal"];
        [standardUserDefaults setDouble:_startChargePercentage forKey:@"startCharge"];
        [standardUserDefaults synchronize];*/
        
        [batteryView setDistributionForCoal:currentCoalPercentage Oil:currentOilPercentage Gas:currentGasPercentage Nuclear:currentNuclearPercentage Hydro:currentHydroPercentage Renewable:currentRenewablePercentage Other:currentOtherPercentage Geothermal:currentGeothermalPercentage Wind:currentWindPercentage Solar:currentSolarPercentage Biomass:currentBiomassPercentage Biogas:currentBiogasPercentage AndTotal:currentTotalPercentage AndStartCharge:startCharge];
    }
    else if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged) {
        
        //phone is unplugged
        isCharging = NO;
        _endDate = [NSDate date];
        _endChargePercentage = [[UIDevice currentDevice] batteryLevel];
        
        [batteryView concatDistributions];
        startCharge = [[UIDevice currentDevice] batteryLevel];
        
        _secondsSpentCharging = [_endDate timeIntervalSinceDate:_startDate];
        
        //updated so this is set in concatDistributions
        /*NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
        currentCoalPercentage = [standardUserDefaults doubleForKey:@"currentCoal"];
        currentGasPercentage = [standardUserDefaults doubleForKey:@"currentGas"];
        currentHydroPercentage = [standardUserDefaults doubleForKey:@"currentHydro"];
        currentNuclearPercentage = [standardUserDefaults doubleForKey:@"currentNuclear"];
        currentOilPercentage = [standardUserDefaults doubleForKey:@"currentOil"];
        currentRenewablePercentage = [standardUserDefaults doubleForKey:@"currentRenewable"];
        currentTotalPercentage = [standardUserDefaults doubleForKey:@"currentTotal"];
        _percentCharged = _endChargePercentage - [standardUserDefaults doubleForKey:@"startCharge"];
        
        [standardUserDefaults setDouble:totalCoalPercentage+currentCoalPercentage*_percentCharged forKey:@"totalCoal"];
        [standardUserDefaults setDouble:totalGasPercentage+currentGasPercentage*_percentCharged forKey:@"totalGas"];
        [standardUserDefaults setDouble:totalHydroPercentage+currentHydroPercentage*_percentCharged forKey:@"totalHydro"];
        [standardUserDefaults setDouble:totalNuclearPercentage+currentNuclearPercentage*_percentCharged forKey:@"totalNuclear"];
        [standardUserDefaults setDouble:totalOilPercentage+currentOilPercentage*_percentCharged forKey:@"totalOil"];
        [standardUserDefaults setDouble:totalRenewablePercentage+currentRenewablePercentage*_percentCharged forKey:@"totalRenewable"];
        [standardUserDefaults setDouble:totalPercentage+currentTotalPercentage*_percentCharged forKey:@"totalPercentage"];
        [standardUserDefaults synchronize];*/
        
        UIAlertView *unpluggedAlert = [[UIAlertView alloc] initWithTitle:@"Unplugged" message:@"Your device is no longer charging" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unpluggedAlert show];
    }
}

- (IBAction)updateLocation:(id)sender{
    //commented out until API is working again
    /*//NSLog(@"Update Location button pressed");
    [self clearLocation];
    //NSLog(@"Device is charging");
    
    
    //CHANGE THE UPDATE FREQUENCY!
    [locationManager startUpdatingLocation];*/
    
    [self hardCodedSetPercentages];
    //[self batteryStateDidChange:(NULL)];
    
}

-(void) clearLocation
{
    _locationText.text = @"";
    _dateText.text = @"";
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"Failed with error: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not get location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    //NSLog(@"Updated to location: %@", currentLocation);
    distribution = [[EnergyDistribution alloc] initWithLatLon: currentLocation.coordinate.latitude :currentLocation.coordinate.longitude];
    [self setPercentages];
    
    if (currentLocation != nil)
    {
        //_LocationText.text = [NSString stringWithFormat: @"Longitude: %.8f Latitude: %.8f", currentLocation.coordinate.longitude, currentLocation.coordinate.latitude];
    }
    
    [locationManager stopUpdatingLocation];
    
    /*NSLog(@"Reverse geocoding");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *geocodingError) {
        if (geocodingError == nil && [placemarks count] > 0){
            placemark = [placemarks lastObject];
                distribution = [[EnergyDistribution alloc] initWithZipCode:[[placemark postalCode] intValue]];
            [self setPercentages];
            
            [self getUpdatedData];
        }        
        else{
            NSLog(@"Error!");
        }
    }];*/
}

-(void) getUpdatedData
{
    appDelegate = (EnergyBreakappAppDelegate*) [[UIApplication sharedApplication] delegate];
    context = appDelegate.managedObjectContext;
    
    
    NSError *error;
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"EnergyDistribution" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
}


-(void) saveDistribution
{
    NSNumber* postalCode;
    postalCode = [NSNumber numberWithInt:[[placemark postalCode] integerValue]];
    NSError *error;
    
    NSManagedObject *last = [fetchedObjects lastObject];
    NSManagedObject *energyDistribution = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"EnergyDistribution"
                                           inManagedObjectContext:context];
    [energyDistribution setValue:postalCode forKey:@"zip"];
    //NSLog(@"Zip put in is %@", postalCode);
    [energyDistribution setValue:[NSDate date] forKey:@"date"];
    [energyDistribution setValue:[placemark locality] forKey:@"city"];
    [energyDistribution setValue:[placemark administrativeArea] forKey:@"state"];
    
    if (last != nil) {
        [energyDistribution setValue:last forKey:@"previousDistribution"];
        [last setValue:energyDistribution forKey:@"nextDistribution"];
    }
    
    currentDistribution = energyDistribution;
    
    if (![context save:&error]) {
        //NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
}

-(void) hardCodedSetPercentages {
    currentCoalPercentage = 0.5;
    currentOilPercentage = 0.0;
    currentGasPercentage = 0.299;
    currentNuclearPercentage = 0.0;
    currentHydroPercentage = 0.1;
    currentRenewablePercentage = 0.0;
    currentOtherPercentage = 0.0;
    //NSLog(@"Other percentage in view controller is %f", currentOtherPercentage);
    currentGeothermalPercentage = 0.0;
    currentSolarPercentage = 0.1;
    currentWindPercentage = 0.01;
    currentBiomassPercentage = 0.0;
    currentBiogasPercentage = 0.0;
    currentTotalPercentage = 1.0;
    [batteryView setDistributionForCoal:currentCoalPercentage Oil:currentOilPercentage Gas:currentGasPercentage Nuclear:currentNuclearPercentage Hydro:currentHydroPercentage Renewable:currentRenewablePercentage Other:currentOtherPercentage Geothermal:currentGeothermalPercentage Wind:currentWindPercentage Solar:currentSolarPercentage Biomass:currentBiomassPercentage Biogas:currentBiogasPercentage AndTotal:currentTotalPercentage AndStartCharge:startCharge];
}

-(void) setPercentages
{
    currentCoalPercentage = [distribution coalPercentage];
    currentOilPercentage = [distribution oilPercentage];
    currentGasPercentage = [distribution gasPercentage];
    currentNuclearPercentage = [distribution nuclearPercentage];
    currentHydroPercentage = [distribution hydroPercentage];
    currentRenewablePercentage = [distribution renewablePercentage];
    currentOtherPercentage = [distribution otherPercentage];
    //NSLog(@"Other percentage in view controller is %f", currentOtherPercentage);
    currentGeothermalPercentage = [distribution geothermalPercentage];
    currentSolarPercentage = [distribution solarPercentage];
    currentWindPercentage = [distribution windPercentage];
    currentBiomassPercentage = [distribution biomassPercentage];
    currentBiogasPercentage = [distribution biogasPercentage];
    currentTotalPercentage = [distribution totalPercentages];
    [batteryView setDistributionForCoal:currentCoalPercentage Oil:currentOilPercentage Gas:currentGasPercentage Nuclear:currentNuclearPercentage Hydro:currentHydroPercentage Renewable:currentRenewablePercentage Other:currentOtherPercentage Geothermal:currentGeothermalPercentage Wind:currentWindPercentage Solar:currentSolarPercentage Biomass:currentBiomassPercentage Biogas:currentBiogasPercentage AndTotal:currentTotalPercentage AndStartCharge:startCharge];
}

//data already gathered from API, simply update display from it
- (IBAction)updateDisplay:(id)sender {
    
    [batteryView setDistributionForCoal:currentCoalPercentage Oil:currentOilPercentage Gas:currentGasPercentage Nuclear:currentNuclearPercentage Hydro:currentHydroPercentage Renewable:currentRenewablePercentage Other:currentOtherPercentage Geothermal:currentGeothermalPercentage Wind:currentWindPercentage Solar:currentSolarPercentage Biomass:currentBiomassPercentage Biogas:currentBiogasPercentage AndTotal:currentTotalPercentage AndStartCharge:startCharge];
}

//if app is running in background
-(void) math
{
    
    //device is charging
    if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) {
        NSLog(@"Charging...");
        //if was charging before
        if(isCharging){
            
        }
        //if was not charging before
        else {
            [self clearLocation];
            [locationManager startUpdatingLocation];
            _startDate = [NSDate date];
            _startChargePercentage = [[UIDevice currentDevice] batteryLevel];
            
            NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setDouble:currentCoalPercentage forKey:@"currentCoal"];
            [standardUserDefaults setDouble:currentGasPercentage forKey:@"currentGas"];
            [standardUserDefaults setDouble:currentHydroPercentage forKey:@"currentHyrdo"];
            [standardUserDefaults setDouble:currentNuclearPercentage forKey:@"currentNuclear"];
            [standardUserDefaults setDouble:currentOilPercentage forKey:@"currentOil"];
            [standardUserDefaults setDouble:currentRenewablePercentage forKey:@"currentRenewable"];
            [standardUserDefaults setDouble:currentTotalPercentage forKey:@"currentTotal"];
            [standardUserDefaults setDouble:_startChargePercentage forKey:@"startCharge"];
            [standardUserDefaults synchronize];
        }
        isCharging = YES;
    }
    else if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateFull) {
        NSLog(@"Completely charged");
        //if was charging before
        if(isCharging){
            
        }
        //if was not charging before
        else {
            
        }
        isCharging = NO;
    }
    else if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged) {
        NSLog(@"Not plugged in");
        //if was charging before
        if (isCharging){
            
        }
        //if was not charging before
        else {
            
        }
        isCharging = NO;
    }
}
@end
