puppet-applenetboot
===================
A module for configuring netboot on any Mac OS X 10.6/10.7 machine. (10.8 untested at this moment)


###Note###
Make sure that the NetBoot set you place in NetBootSP0 has the key 'IsEnabled' set to True.  This can be found inside the NBImageInfo.plist.  You may also set the image to be default using the 'IsDefault' key if desired.

#####Many thanks to:#####


* Allister Banks (https://github.com/arubdesu) for the initial netboot config
* Gary Larizza (https://github.com/glarizza) for the guidance on making modules.
