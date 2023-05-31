## Get data, run the model and produce outputs

include("data.jl")
include("smb.jl")

# Get data
newdata_dir = "../new-data"
download_file("file:///$(homedir())/itet-stor/vaw_public/werderm/rere-data/climate.dat",
              newdata_dir, "climate.dat")
