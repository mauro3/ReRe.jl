## A simple mass balance model

### Melt at a point *M*

$$
M(z,t) =
\begin{cases}
DDF \, * \,T(z,t): T(z,t) \ge0\\
0 \hspace{2.85cm}: T(z,t)<0
\end{cases}
$$

where $DDF$ (m/d/C) is the degree day factor (well here actually more a melt factor as we're aiming at integrating with hourly steps), $T$ ( C) temperature, $z$ elevation (m), and $t$ time (d).

### Accumulation at a point *C*
$$
C(z,t) =
\begin{cases}
P_{m} : T(z,t) \le T_{th}\\
0 \hspace{1.6cm}: T(z,t)>T_{th}
\end{cases}
$$

where $P_{m}$ is a given precipitation and $T_{th}$ is the temperature below which it snows.


### Lapsed temperature

$$ T(z,t) = l \Delta z + T(z_{s},t) $$

where $z_s$ is the elevation of the weather station (which provides temperature) and $l$ (C/m) is the lapse rate.

### Synthetic weather

Temperature [C] at weather station `-10*cos(2pi/364 * t) - 8*cos(2pi* t) + 5` with t in days

Precipitation [m/d] at weather station `8e-3` with threshold 4 [C]. (yes, it's alway raining/snowing on our wee glacier...)

Weather station altitude 0m.

## Get your hands dirty with:

1. make teams of two
2. program a melt function
   - its API is given below
   - test it with a few temperatures
   - DDF = 0.005 m/d/C

--> now we move on to learning git


The idea of the next steps is that you collaborate in your team on writing the following code: one person writes one function the other function another function.  For that to work you may have to agree on an API (a calling and naming convention), this we will try to do as a whole group.

3. One person of the group makes an empty GitHub repository to host the
code.  Agree which person's code should serve as base (i.e. the
`meltrate` function)
   - create repo on GitHum (the `+` top right)
   - add GitHub as a remote: `git remote add origin url-of-your-repo` (on the team member which will serves as the base)
   - other team members clone the repo: `git clone url-of-your-repo`
4. program the accumulation function
   - decide on API and state it in this document
   - program it
   - test it with temperatures above and below threshold
5. program the lapse function
   - decide on API and state it in this document
   - test it, make sure sign is right
6. program the synthetic weather functions for temp and precip
   - decide on API
   - plot them
7. make a yearly smb function for a point at arbitrary elevation
   - decide on API
8. what is the elevation difference of a glacier in steady state flowing down from 5000m? Assuming a linear topography and that it has negligible thickness.


## API (application programming interface)
**Update this as you go along.
If changed later keep the old API as ~~crossed out~~**



melt-rate function:
- signature: (T, DDF) -> meltrate (m/d)
- name `meltrate`
- default `DDF = 0.005`

accumulation-rate function:
- signature: (P_m, T_th, T) -> accrate (m/d)
- name: `acc`
- default `T_th = 4`

lapsed-temperature function
- signature: (T, delta_z, l) -> T
- name: `lapse`
- default  `l = -0.6/100 C/m`

synthetic temperature function:
- signature: (t) -> T
- name: `temp`

synthetic precipitation function:
- signature: (t) -> P
- name: `precip`

yearly mass balance function:
- signature: () ->
- name: `annual_balance`
- notes: integration to be at hourly steps

## More features?

# Running with real data

Datasources:

our own data:
- temperature and precip (data from Gornergletscher 2007)

existing data:
- ERA5 data
or
- swisstopo DEM from around 2007
- Glamos outline from inventory 2010
