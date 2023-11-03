## Accessibility Crowdsource Heatmap

This Project aims to create an extended function for users to provide accessibility information of a building that will also be available to all other users. 
The types of information include the location of the Accessible Entrance, Restroom accessibility and floor it is located, and Total Accessibility degree of the building(Regarding vision and mobility disabilities). 

## Notable Related Development Environment and Libraries
* [Flutter](https://flutter.dev/)
* [Google Map API](https://developers.google.com/maps)
* [Android Studio](https://developer.android.com/studio?gclid=Cj0KCQjwtJKqBhCaARIsAN_yS_m2MM1kc1OGQXcfVboG3wMV_NsaW0QA5Tyflr24T7G9LS4GqhCXy0oaApzgEALw_wcB&gclsrc=aw.ds)

## Essential Features

Interface:
Create a simple form interface where users can:
* Pinpoint the building.
* Mark accessible entrances.
* Add details about restrooms and their locations.
* Provide an overall accessibility score, possibly with an option to write a review.

Validation:
* Consider implementing a verification system. Multiple users can review new submissions before they are confirmed. This can help in ensuring the authenticity and correctness of the data.

Custom Markers:
* Customize markers on the map to represent buildings. Different colours or icons can represent varying levels of accessibility.
* Clicking on these markers can display detailed information about the building.

Search & Filters:
* Let users search for buildings or areas and filter results based on accessibility scores, restroom availability, etc
