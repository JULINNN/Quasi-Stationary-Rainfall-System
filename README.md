# Quasi - Stationary Rainfall Systems and Climate Change - Future Projection
- Summary the progress of this research and future work

## Abstract
In order to understand how much global warming will affect the extreme rainfall associated with quasi statioanry rainfall system. First, we use NCEP FNL and CReSS numeric model to reconstruct the case (i.e CTL). Then, by subtracting CMIP5 Historical Runs from 21 century Future Projection Runs to estimate the climate change ∆RCP for RCP8.5 scenario. We add ∆RCP on NCEP FNL as the IC/BC for SE and simulate the same system in future climate. After that we analyze the precipitation distribution pattern and water budget change.

## Data Sources
- NCEP FNL
  - Spatial Resolution : 0.25˚ x 0.25˚, 26 levels
  - Time Resolution : 6 hours, 24 records
  - Variable :
    - Geopotential Height (gpm)
    - U, V Wind (m/s)
    - Pressure (pa)
    - Vertical Temperature (K)
    - Relative Humidity (%)
    - SST (K)

- CMIP5 Models
  - 38 models, Model Lists
  - Future Projection Runs : 2081 ~ 2100
  - Historical Runs : 1981 ~ 2000
  - Spatial Resolution : multi, 17 levels
  - Time Resolution : monthly
  - Variable :
    - Geopotential Height (gpm)
    - U, V Wind (m/s)
    - Pressure (pa)
    - Vertical Temperature (K), 17 levels
    - Specific Humidity (g/kg)
    - SST (K)

- ECMWF ERA5

## Data Processing
1. Download the data
    - NCEP FNL [Download Tutorial](./doc/ncep.md)
    - CMIP5 [Download Tutorial](./doc/doc/cmip5.md)
    - ECMWF [Download Tutorial](./doc/ecmwf.md)

2. Process the data
    - prepare ∆RCP8.5 <!-- grads file -->
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
- Linux Tutorial
- vi Tutorial
- Fortran Tutorial
- GrADS Tutoral
- Python Tutorial
- CReSS Tutorial