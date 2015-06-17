//
//  BatteryView.h
//  EnergyBreakapp
//
//  Created by Utkarsh Dalal on 12/12/13.
//  Copyright (c) 2013 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BatteryView : UIView
{
    double currentCoalPercentage, currentOilPercentage, currentGasPercentage, currentNuclearPercentage, currentHydroPercentage, currentRenewablePercentage, currentOtherPercentage, currentGeothermalPercentage, currentWindPercentage, currentSolarPercentage, currentBiomassPercentage, currentBiogasPercentage, currentTotalPercentage, startCharge, previousCoalPercentage, previousOilPercentage, previousGasPercentage, previousNuclearPercentage, previousHydroPercentage, previousRenewablePercentage, previousOtherPercentage, previousGeothermalPercentage, previousWindPercentage, previousSolarPercentage, previousBiomassPercentage, previousBiogasPercentage, previousTotalPercentage, unknownPercentage;
    BOOL hasDistribution;
}

-(void) setDistributionForCoal: (double) coalPercentage Oil: (double) oilPercentage Gas: (double) gasPercentage Nuclear: (double) nuclearPercentage Hydro: (double) hydroPercentage Renewable: (double) renewablePercentage Other: (double) otherPercentage Geothermal: (double) geothermalPercentage Wind: (double) windPercentage Solar: (double) solarPercentage Biomass: (double) biomassPercentage Biogas: (double) biogasPercentage Unknown: (double) unknownPercentage AndTotal: (double) totalPercentage AndStartCharge: (double) startChargeValue;

-(void) setPreviousDistributionForCoal: (double) coalPercentage Oil: (double) oilPercentage Gas: (double) gasPercentage Nuclear: (double) nuclearPercentage Hydro: (double) hydroPercentage Renewable: (double) renewablePercentage Other: (double) otherPercentage Geothermal: (double) geothermalPercentage Wind: (double) windPercentage Solar: (double) solarPercentage Biomass: (double) biomassPercentage Biogas: (double) biogasPercentage Unknown: (double) unknownPercentage AndTotal: (double) totalPercentage;

-(void) concatDistributions;

-(void) fillBattery;

-(void) drawBattery;

-(void) fillScreen;

@end
