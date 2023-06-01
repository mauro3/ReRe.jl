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
plot(t,P)
savefig("../products/precip.png")
