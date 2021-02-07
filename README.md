# Quasi - Stationary Rainfall Systems and Climate Change

## Abstract
In order to understand how much global warming will affect the extreme rainfall associated with quasi statioanry rainfall system. First, we use NCEP FNL and CReSS numeric model to reconstruct the case (i.e CE). Then, by subtracting CMIP5 Historical Runs from 21 century Future Projection Runs to estimate the climate change ∆RCP for RCP8.5 scenario. We add ∆RCP on NCEP FNL as the IC/BC for SE and simulate the same system in future climate. After that we analyze the precipitation distribution pattern and water budget change.

## 2017.05.30 Case

### Introduction
The Me-Yu front affected Taiwan since 1st June 2017 and it touched Northern Taiwan in 2nd June early morning and move toward Central Taiwan in the night of 2nd June. The front bring extreme heavy rainfall whatever it stayed. There are many stations recoreded maximum hourly rainfall exceeded 80 mm/hr in Northern Taiwan and over 400 mm rainfall in 24 hours. The front extremely heavy rainfall in short period caused many flooding and landslide events in Northern and Central Taiwan.

### Data Sources
- NCEP FNL
  - Spatial Resolution : 0.25˚ x 0.25˚, 26 levels
  - Time Resolution : 6 hours, 24 records
    | Variables            | Units |
    | -------------------- | ----- |
    | Geopotential Height  | gpm   |
    | U, V Wind            | m/s   |
    | Pressure             | pa    |
    | Vertical Temperature | K     |
    | Relative Humidity    | %     |
    | SST                  | K     |

- ECMWF ERA5
  
## 2012.06.08 Case
### Introduction

### Data Sources
- NCEP FNL
  - Spatial Resolution : 1˚ x 1˚, 26 levels
  - Time Resolution : 6 hours, 24 records
    | Variables            | Units |
    | -------------------- | ----- |
    | Geopotential Height  | gpm   |
    | U, V Wind            | m/s   |
    | Pressure             | pa    |
    | Vertical Temperature | K     |
    | Relative Humidity    | %     |
    | SST                  | K     |

- ECMWF ERA5

## Data Process
1. Download the data
    - NCEP FNL [Download Tutorial](./doc/ncep.md)
    - CMIP5 [Download Tutorial](./doc/cmip5.md)
    - ECMWF [Download Tutorial](./doc/ecmwf.md)

2. Process the data
    - Prepare ∆RCP8.5 <!-- grads file -->
    - CMIP5 Data Interpolating <!-- interpolate.f95 -->
    - Add ∆RCP8.5 <!-- gpvaddrcp85.f95 -->

3. Numerical Simulation (CReSS)
    - Spatial Resolution : 3 km x 3 km
    - Time Resolution : Hourly, 120 records
    - Other Simulation Setting [CReSS Setting](./doc/cress.md)
    - NTNU HPC [HPC Tutorial](./doc/hpc.md)
  
## Data Analyze
   - Position <!-- wind_gscode -->
   - Duration
   - q3max <!-- q3max.f95 grads -->
   - Precipitation <!-- hourRain.py -->
   - Water Budget <!-- grads, fortran, python -->

## Resources
- [Linux Tutorial](./doc/linux.md)
- [vi Tutorial](./doc/vi.md)
- [Fortran Tutorial](./doc/fortran.md)
- [GrADS Tutoral](./doc/grads.md)
- [Python Tutorial](./doc/python.md)
- [CReSS Tutorial](./doc/cress.md)