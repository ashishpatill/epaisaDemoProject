//
//  detailPage.m
//  ePaisaDemo
//
//  Created by Ashish Pisey on 7/22/14.
//  Copyright (c) 2014 com.lionkingmedia. All rights reserved.
//

#import "detailPage.h"

@implementation detailPage

-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication]setStatusBarHidden:YES];

}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
// Mumbai international airport latitude and longitude
// 19.0886° N, 72.8681° E
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //Make this controller the delegate for the map view.
    self.mapView.delegate = self;
    
    // Ensure that you can view your own location in the map view.
//    [self.mapView setShowsUserLocation:YES];
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = 19.0886 ;
    region.center.longitude = 72.8681;
    region.span.longitudeDelta = 0.05f;
    region.span.latitudeDelta = 0.05f;
    [self.mapView setRegion:region animated:YES];
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some parameters for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //[self queryGooglePlaces:@"Bar"];
    
    firstLaunch=YES;
}


- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    currentLocation = aUserLocation;
    //    NSLog(@"lat %f long %f",aUserLocation.coordinate.latitude,location.longitude);
    if (location.latitude != 0.0 && location.latitude != 0.0) {
        if(firstLaunch)
        {
            [self.mapView setRegion:region animated:NO];
            firstLaunch = NO;
            [self queryGooglePlaces:@"Resataurant"];
        }
    }
    
}



#pragma mark - MKMapViewDelegate methods.
-(void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    //Zoom back to the user location after adding a new set of annotations.
    //Get the center point of the visible map.
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    MKCoordinateRegion region;
    //If this is the first launch of the app, then set the center point of the map to the user's location.
    //    if (firstLaunch) {
    //        NSLog(@"co ordinates %f,%f",locationManager.location.coordinate.latitude,locationManager.location.coordinate.longitude);
    //        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
    //        firstLaunch=NO;
    //    }else {
    //        //Set the center point to the visible region of the map and change the radius to match the search radius passed to the Google query string.
    //        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
    //    }
    //Set the visible region of the map.
    //[mv setRegion:region animated:YES];
}

-(void) queryGooglePlaces: (NSString *) googleType {
    // Build the url string to send to Google. NOTE: The kGOOGLE_API_KEY is a constant that should contain your own API key that you obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&keyword=%@&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
    
    //    NSLog(@"url :: %@",url);
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

-(void)fetchedData:(NSData *)responseData {
    //parse out the json data
    if (responseData) {
        
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData
                              
                              options:kNilOptions
                              error:&error];
        
        //The results from Google will be an array obtained from the NSDictionary object with the key "results".
        NSArray* places = [json objectForKey:@"results"];
        
        //Write out the data to the console.
        //    NSLog(@"Google Data: %@", places);
        
        [self plotPositions:places];
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //    NSLog(@"regionDidChangeAnimated");
    //Get the east and west points on the map so you can calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set your current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set your current center point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
    
    //    NSLog(@"search string %@",searchString);
    // refresh annotations with region
    if ([self.searchBar.text isEqualToString:@""]) {
        [self queryGooglePlaces:@"restaurant"];
        
    }else
    {
        [self queryGooglePlaces:searchString];
        
    }
    //    NSLog(@"currentCentre :: %f, %f",currentCentre.latitude, currentCentre.longitude);
}

-(void)plotPositions:(NSArray *)data {
    // 1 - Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[MapPoint class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    // 2 - Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++) {
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        // 3 - There is a specific NSDictionary object that gives us the location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        // Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        // 4 - Get your name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        // Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        // Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        // 5 - Create a new annotation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        [self.mapView addAnnotation:placeObject];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    // Define your reuse identifier.
    static NSString *identifier = @"MapPoint";
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        return annotationView;
    }
    return nil;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //    NSLog(@"search end");
    searchString = self.searchBar.text;
    if ([self.searchBar.text isEqualToString:@""]) {
        [self queryGooglePlaces:@"restaurant"];
        
    }else
    {
        [self queryGooglePlaces:searchString];
        
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //    NSLog(@"search button clicked");
    searchString = self.searchBar.text;
    [self.searchBar resignFirstResponder];
    
    if ([self.searchBar.text isEqualToString:@""]) {
        [self queryGooglePlaces:@"restaurant"];
        
    }else
    {
        [self queryGooglePlaces:searchString];
        
    }
    //[self.searchBar performSelectorOnMainThread:@selector(resignResponder) withObject:nil waitUntilDone:NO];
}

-(void)resignResponder
{
    [self resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    NSLog(@"touch.view :: %@",touch.view);
    
    if (touch.view == self.mapView)
    {
        searchString = self.searchBar.text;
    }
}


- (IBAction)backBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
