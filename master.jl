## Get data, run the model and produce outputs

include("data.jl")
include("smb.jl")

# Get data
newdata_dir = "../new-data"
fl = download_file("file:///$(homedir())/itet-stor/vaw_public/werderm/rere-data/climate.dat",
              newdata_dir, "climate.dat")
download_file("file:///$(homedir())/itet-stor/vaw_public/werderm/rere-data/info",
              newdata_dir, "climate.inf")


t,T,P,z_station = read_campbell(fl)

using Plots
plot(plot(t,T, ylabel="T (C)"),
     plot(t,P, ylabel="P (m/day)"),
     layout=(2,1))
savefig("../products/precip.png")


# 8. Run the mass balance model for two points on Gornergletscher at
# 2500m and 3400m with the data from 2007.  For each point write the
# month total mass balance to a csv-file with header `year, month, smb
# [m water equivalent]` (yes place that csv-file in `products/`)

"""
    temp_gorner(t)

For t in days of year 2007
"""
function temp_gorner(tt)
    Δt = 1/24
    i = findfirst(tt .≈ 0:Δt:365)
    return T[i]
end
"""
    precip_gorner(t)

For t in days of year 2007
"""
function precip_gorner(tt)
    Δt = 1/24
    i = findfirst(tt .≈ 0:Δt:365)
    return P[i]
end

@show yearly_smb(temp_gorner, precip_gorner, 0.005, 2500-z_station, -0.6/100, 4)
@show yearly_smb(temp_gorner, precip_gorner, 0.005, 4000-z_station, -0.6/100, 4)


t0 = DateTime(2007,1,1,0,0,0)

months = [datetime2dayofyear.([t0+Month(i-1)-Day(1), t0+Month(i)-Day(1)]) for i=1:12]
months[1][1] = 0.0


at2500 = [integrate_smb(months[i]..., temp_gorner, precip_gorner, 0.005, 2500-z_station, -0.6/100, 4) for i=1:12]
at4000 = [integrate_smb(months[i]..., temp_gorner, precip_gorner, 0.005, 4000-z_station, -0.6/100, 4) for i=1:12]
y, m = [2007 for i=1:12], 1:12

writedlm("../products/mb@2500.csv",
         ["Cumulative mass balance for Gornergletscher in 2007" "" ""
          "year" "month" "mass balance [m]"
          [y m at2500]], ',')

writedlm("../products/mb@4000.csv",
         ["Cumulative mass balance for Gornergletscher in 2007" "" ""
          "year" "month" "mass balance [m]"
          [y m at4000]], ',')

# 9. Reproduce your research: log into vierzack03.ethz.ch (or some other computer at hand, make sure to have the same file paths or do some magic), make a folder, in that folder clone the code repo, run the master script.

# steps in bash-shell (also in the README.md):
# ssh werderm@vierzack03.ethz.ch # check the wiki on details of ssh
# mkdir ~/tmp/rere
# cd ~/tmp/rere
# git clone git@github.com:mauro3/ReRe.jl.git
## now specific to my implementation in Julia
# cd ReRe.jl
# julia --project
# julia> using Pkg; Pkg.instantiate() # now wait some for the plotting package to be installed
# julia> include("master.jl")
##
## ta-da!
