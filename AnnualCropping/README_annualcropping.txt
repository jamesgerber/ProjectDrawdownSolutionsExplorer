README to for codes for improvedannualcropping solution

One simple code here, it plots some context data (Sanderman soil carbon
loss) 
Prestele (a spatialized assessment of conservation agriculture uptake)
And Kassam 2022 data, which has country-specific estimates of land in CA 
for a variety of years (2008,2013,2015,2018)

to be consistent with the written solution, I do a linear extrapolation
of the reported area from Kassam.   IF there's only data for 2018 then I 
use 2018 data.  

The calculation for going from adoption to impact relies on multiplication by 1.80 (from the solution)  While
it is in theory possible to refine this with regard to humidity / temperature
impacts on effectiveness, the data on this is sufficiently uncertain that
we felt it was unrealistic to include it.

In the solution, when aggregating globally, we assume cropland that has
been in conservation agriculture for 30 years is saturated.  In mapping
we have excluded this consideration here because we don't have adequate
geospatial data on where these practices were in place 30 years ago.

We used the Kassam data without regard to the caveats in the data

