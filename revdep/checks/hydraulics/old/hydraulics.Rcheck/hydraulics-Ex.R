pkgname <- "hydraulics"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('hydraulics')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("atmos_table")
### * atmos_table

flush(stderr()); flush(stdout())

### Name: atmos_table
### Title: Tabulates into a tibble some properties of the standard
###   atmosphere: temperature, density, and pressure.
### Aliases: atmos_table

### ** Examples


atmos_table(units = 'SI')




cleanEx()
nameEx("atmosprops")
### * atmosprops

flush(stderr()); flush(stdout())

### Name: atmosprops
### Title: Functions to calculate ICAO standard atmospheric properties:
###   temperature, density, and pressure.
### Aliases: atmosprops atmtemp atmpres atmdens

### ** Examples


#Find standard atmospheric temperature at altitude 8000 m
atmtemp(alt = 8000, units = 'SI')

#Find standard atmospheric pressure assuming default altitude of zero (sea-level)
atmpres(units = 'Eng', ret_units = TRUE)

#Find standard atmospheric density at altitude 15000 ft 
atmdens(alt = 15000, units = 'Eng')




cleanEx()
nameEx("colebrook")
### * colebrook

flush(stderr()); flush(stdout())

### Name: colebrook
### Title: Calculates the Darcy-Weisbach Friction Factor f
### Aliases: colebrook velocity reynolds_number

### ** Examples


# A Type 1 problem (solve for hf): US units
D <- 20/12   #diameter of 20 inches
Q <- 4       #flow in ft^3/s
T <- 60      #water temperature in F
ks <- 0.0005 #pipe roughness in ft

f <- colebrook(ks=ks,V=velocity(D,Q), D=D, nu=kvisc(T=T, units="Eng"))




cleanEx()
nameEx("darcyweisbach")
### * darcyweisbach

flush(stderr()); flush(stdout())

### Name: darcyweisbach
### Title: Solves the Darcy-Weisbach Equation for the either head loss
###   (hf), flow rate (Q), diameter (D), or roughness height (ks).
### Aliases: darcyweisbach

### ** Examples


#Type 2 (solving for flow rate, Q): SI Units
D <- .5
L <- 10
hf <- 0.006*L
T <- 20
ks <- 0.000046
darcyweisbach(D = D, hf = hf, L = L, ks = ks, nu = kvisc(T=T, units='SI'), units = c('SI'))

#Type 3 (solving for diameter, D): Eng (US) units
Q <- 37.5     #flow in ft^3/s
L <- 8000     #pipe length in ft
hf <- 215     #head loss due to friction, in ft
T <- 68       #water temperature, F
ks <- 0.0008  #pipe roughness, ft
darcyweisbach(Q = Q, hf = hf, L = L, ks = ks, nu = kvisc(T=T, units='Eng'), units = c('Eng'))




cleanEx()
nameEx("direct_step")
### * direct_step

flush(stderr()); flush(stdout())

### Name: direct_step
### Title: Uses the direct step method to find the distance between two
###   known depths in a trapezoidal channel
### Aliases: direct_step

### ** Examples


#Solving for profile between depths 3.1 ft and 3.4 ft in a rectangular channel
#Flow of 140 ft^3/s, bottom width = 6 ft:
direct_step(So=0.0015, n=0.013, Q=140, y1=3.1, y2=3.4, b=6, m=0, nsteps=2, units="Eng")




cleanEx()
nameEx("hardycross")
### * hardycross

flush(stderr()); flush(stdout())

### Name: hardycross
### Title: Applies the Hardy-Cross method to solve for pipe flows in a
###   network.
### Aliases: hardycross

### ** Examples


#              A----------B --> 0.5m^3/s
#              |\   (4)   |
#              | \        |
#              |  \       |
#              |   \(2)   |
#              |    \     |(5)
#              |(1)  \    |
#              |      \   |
#              |       \  |
#              |        \ |
#              |   (3)   \|
# 0.5m^3/s --> C----------D

#Input pipe characteristics data frame. With K given other columns not needed
dfpipes <- data.frame(
ID = c(1,2,3,4,5),                     #pipe ID
K = c(200,2500,500,800,300)            #resistance used in hf=KQ^2
)
loops <- list(c(1,2,3),c(2,4,5))
Qs <- list(c(0.3,0.1,-0.2),c(-0.1,0.2,-0.3))
hardycross(dfpipes = dfpipes, loops = loops, Qs = Qs, n_iter = 1, units = "SI")




cleanEx()
nameEx("manningc")
### * manningc

flush(stderr()); flush(stdout())

### Name: manningc
### Title: Solves the Manning Equation for gravity flow in a circular pipe
### Aliases: manningc

### ** Examples


#Solving for flow rate, Q: SI Units
manningc(d = 0.6, n = 0.013, Sf = 1./400., y = 0.24, units = "SI")
#returns 0.1 m3/s

#Solving for Sf, if d=600 mm and pipe is to flow half full
manningc(d = 0.6, Q = 0.17, n = 0.013, y = 0.3, units = "SI")
#returns required slope of 0.003

#Solving for diameter, d when given y_d): Eng (US) units
manningc(Q = 83.5, n = 0.015, Sf = 0.0002, y_d = 0.9, units = "Eng")
#returns 7.0 ft required diameter

#Solving for depth, d when given Q: SI units
manningc(Q=0.01, n=0.0013, Sf=0.001, d = 0.2, units="SI")
#returns depth  y = 0.042 m, critical depth, yc = 0.085 m




cleanEx()
nameEx("manningt")
### * manningt

flush(stderr()); flush(stdout())

### Name: manningt
### Title: Solves the Manning Equation for water flow in an open channel
### Aliases: manningt

### ** Examples


#Solving for flow rate, Q, trapezoidal channel: SI Units
manningt(n = 0.013, m = 2, Sf = 0.0005, y = 1.83, b = 3, units = "SI")
#returns Q=22.2 m3/s

#Solving for roughness, n, rectangular channel: Eng units
manningt(Q = 14.56, m = 0, Sf = 0.0004, y = 2.0, b = 4, units = "Eng")
#returns Manning n of 0.016

#Solving for depth, y, triangular channel: SI units
manningt(Q = 1.0, n = 0.011, m = 1, Sf = 0.0065, b = 0, units = "SI")
#returns 0.6 m normal flow depth




cleanEx()
nameEx("moody")
### * moody

flush(stderr()); flush(stdout())

### Name: moody
### Title: Creates a Moody diagram with optional manually added points
### Aliases: moody

### ** Examples


# Draw canonical Moody diagram
moody()

# Draw Moody diagram plotting two additional points
Re = c(10000, 100000)
f = c(0.04, 0.03)
moody( Re = Re, f = f )





cleanEx()
nameEx("pumpcurve")
### * pumpcurve

flush(stderr()); flush(stdout())

### Name: pumpcurve
### Title: Fits a polynomial curve to three or more points from a pump
###   characteristic curve to be used in solving for an operating point of
###   the pump in a piping system.
### Aliases: pumpcurve

### ** Examples


#Input in Eng units - use \code{units} package for easy unit conversion
qgpm <- units::set_units(c(0, 5000, 7850), gallons/minute)
qcfs <- units::set_units(qgpm, ft^3/s)
hft <- c(81, 60, 20) #units are already in ft so setting units is optional
pumpcurve(Q = qcfs, h = hft, eq = "poly2", units = "Eng")




cleanEx()
nameEx("sequent_depth")
### * sequent_depth

flush(stderr()); flush(stdout())

### Name: sequent_depth
### Title: Solves the Momentum Equation for sequent (or conjugate) depth in
###   a trapezoidal channel
### Aliases: sequent_depth

### ** Examples


#Solving for sequent depth: SI Units
#Flow of 0.2 m^3/s, bottom width = 0.5 m, Depth = 0.1 m, side slope = 1:1
sequent_depth(Q=0.2,b=0.5,y=0.1,m=1,units = "SI", ret_units = TRUE)




cleanEx()
nameEx("spec_energy_trap")
### * spec_energy_trap

flush(stderr()); flush(stdout())

### Name: spec_energy_trap
### Title: Creates a specific energy diagram for a trapezoidal channel
### Aliases: spec_energy_trap

### ** Examples


# Draw a specific cross-section with flow 1, width 2, side slope 3:1 (H:V)
spec_energy_trap(Q = 1.0, b = 2.0, m = 3.0, scale = 4, units = "SI")




cleanEx()
nameEx("systemcurve")
### * systemcurve

flush(stderr()); flush(stdout())

### Name: systemcurve
### Title: Creates a system curve for a piping system using the static head
###   and a coefficient.
### Aliases: systemcurve

### ** Examples


#Input in Eng units. Coefficient can be calculated manually or using 
#other package functions for friction loss in a pipe system using \eqn{Q=1}
ans <- darcyweisbach(Q = 1,D = 20/12, L = 3884, ks = 0.0005, nu = 1.23e-5, units = "Eng")
systemcurve(hs = 30, K = ans$hf, units = "Eng")




cleanEx()
nameEx("water_table")
### * water_table

flush(stderr()); flush(stdout())

### Name: water_table
### Title: Tabulates into a tibble the basic water properties: density,
###   dynamic and kinematic viscosity, saturation vapor pressure, surface
###   tension, and bulk modulus.
### Aliases: water_table

### ** Examples


water_table(units = 'SI')




cleanEx()
nameEx("waterprops")
### * waterprops

flush(stderr()); flush(stdout())

### Name: waterprops
### Title: Functions to calculate water properties: density, specific
###   weight, dynamic and kinematic viscosity, saturation vapor pressure,
###   surface tension, and bulk modulus.
### Aliases: waterprops dvisc dens specwt kvisc svp surf_tension Ev

### ** Examples


#Find kinematic viscocity for water temperature of 55 F
nu = kvisc(T = 55, units = 'Eng')

#Find kinematic viscocity assuming default water temperature of 68 F
nu = kvisc(units = 'Eng')

#Find water density for water temperature of 25 C
rho = dens(T = 25, units = 'SI')

#Find saturation vapor pressure for water temperature of 10 C
vps = svp(T = 10, units = 'SI')

#Find surface tension for water temperature of 10 C
s_tens = surf_tension(T = 10, units = 'SI')




cleanEx()
nameEx("xc_circle")
### * xc_circle

flush(stderr()); flush(stdout())

### Name: xc_circle
### Title: Creates a cross-section plot for a partially filled pipe
### Aliases: xc_circle

### ** Examples


# Draw a cross-section with diameter 1.0 and depth 0.7
xc_circle(y = 0.7, d = 1.0, units = "SI")




cleanEx()
nameEx("xc_trap")
### * xc_trap

flush(stderr()); flush(stdout())

### Name: xc_trap
### Title: Creates a cross-section plot for an open channel
### Aliases: xc_trap

### ** Examples


# Draw a cross-section with depth 1, width 2, side slope 3:1 (H:V)
xc_trap(y = 1.0, b = 2.0, m = 3.0, units = "SI")




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
