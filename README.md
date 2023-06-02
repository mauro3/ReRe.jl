# Reproducible research example repo

This is the example repository for a reproducible research workshop at VAW.


To run in a bash-shell (`$`) and Julia (`julia>`):
```
$ ssh werderm@vierzack03.ethz.ch # check the wiki on details of ssh
$ mkdir ~/tmp/rere
$cd ~/tmp/rere
$ git clone git@github.com:mauro3/ReRe.jl.git
## now specific to my implementation in Julia
$ cd ReRe.jl
$ julia --project
julia> using Pkg; Pkg.instantiate() # now wait some for the plotting package to be installed
julia> include("master.jl")
## ta-da!
```

# Session 1 -- coding a model and using version control

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

# Session 2 -- Running with real data

Datasources:

Our own data:
- temperature and precip (data from Gornergletscher 2007)

Existing data:
- ERA5 data
Or
- swisstopo DEM from around 2007
- Glamos outline from inventory 2010

## Running our simple mass balance model with "real" data

### The mass balance model

You probably programmed that model in our last session.  An example solution in (easy to read) Julia can be found here:

https://github.com/mauro3/ReRe.jl

You can also use that as your continuation point.

*Note: 1h time steps.* I will be running the model (aka integrating) at 1h time steps. Some of you used daily time steps, that is fine too, but may need some different input data and parameters for comparable results.

### The data


### Getting the data

The idea is to fully automate the fetching (downloading) of the data.  That way it can be a part of the scripting workflow.  Typical steps:
- specify paths / urls for all needed files
- pass those to a download function which stores the file(s) locally
- post-process the files, e.g. un-zip them

### Local storage

The folder structure I recommend is:
```
my-awesome-project/  # top folder, this will eventually be zipped and put on a data-repository
  code/     # scripts, etc.  This folder you may typically be hosted on GitHub
  data/     # this is where all the data goes which you download.
  new-data/ # this is where the data you gathered is put after download (e.g. from glazio)
  products/ # outputs: figures, tables, data-products, etc.
```

### Data publication

For upload to a data/code-repository, such as https://www.research-collection.ethz.ch/, you would typically:
- re-clone your code repository from GitHub
- run your master script
- delete the contents of the `data/` folder (or maybe not, depends)
- zip it and upload the zip-file to a code/data-repo (for us this is https://www.research-collection.ethz.ch/)

Note that if you have a "big model" which people may want to use on its own and not just to reproduce your research, then you want to publish this stand-alone.  The `code/` folder could then be
```
code/
  scripts/         # here are the scripts, including the master script
  MyAwesomeModel/  # this is the model, has its separate GitHub repo
```


### License(s)

You should license your data, figures, code and text, that is not in the strictest sense needed to make your science reproducible but to make it *open*.

 I use the following licenses:
 - [MIT](https://en.wikipedia.org/wiki/MIT_License) for code
 - [CC-By](https://creativecommons.org/licenses/by/4.0/) for text, data and anything else

These are both [permissive licenses](https://en.wikipedia.org/wiki/Permissive_software_license) which means that someone can do anything with the licensed content as long as you are correctly attributed.  You may prefer other licenses, also, it is often good to follow what a community is using (in particular for code).

## Get your hands dirty with:

1. re-make teams of two (the idea is that you continue working on the same code base via git and GitHub)
2. Figure out how you can download files from the internet in your programming language.  ChatGPT had this to say: https://gist.github.com/mauro3/36d2b843971e1f580f3589684c6051cd
    - note that usually you can download (aka copy) files from a local folder with those functions too.
3. create a function to download a file and store it in a appropriate place.  API `download_file(url, dir, file, force_download=false) -> full_file_path`
    - download should not happen when the file is present already, unless `force_download=true`

4. create a function which can transform a Campbell-Scientific logger time stamp into an appropriate time-object (maybe a dedicated Date-time object, maybe just a floating point number, say days since some year)
    - inpute is of form `year` (`2007`), day of year (`257`), HHMM (`2257`)
    - API:
     `parse_campbell_date_time(year, day, HHMM) -> appropriate-date-time-thingy`

5. First dataset: treat this as a "new dataset", i.e. one we produced and will publish as part of the release [This is a dataset from a weatherstation of us from 2007].  You find it on `vaw_public/werderm/rere-data` (if you struggle with the vaw-servers, then it's also on https://people.ee.ethz.ch/~werderm/rere-data/)

6. Create a reader which can read the `climate.dat` file using the `parse_campbell_date_time` function.
    - check the `info` file and make sure units are in-line with what you used last week (I suggested `day` and `meter` as base units)

7. create a master script to:
    - download data
    - read `climate.dat`
    - plot temperature and hourly preciptation rate
    - --> store plot in `products/` folder

8. Run the mass balance model for two points on Gornergletscher at 2500m and 4000m with the data from 2007.  For each point write the month total mass balance to a csv-file with header `year, month, smb [m water equivalent]` (yes place that csv-file in `products/`)

9. Reproduce your research: log into vierzack03.ethz.ch (or some other computer at hand, make sure to have the same file paths or do some magic), make a folder, in that folder clone the code repo, run the master script.


Stretch goals run your model either:
- for longer.  For this download ERA5 re-anayisis data or some other suitable dataset (e.g. weather data from the Zermatt weather station)
- distributed.  Download a DEM from swisstopo and a glacier outline from glamos for Gornergletscher.

-> this data then goes into `data/` folder as it is freely available.
