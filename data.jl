#####
# Downloading
#####
using Downloads, Dates, DelimitedFiles

"""
    download_file(url, destination;
                    force_download=false)

Download a file, if it has not been downloaded already.

For password protected access use the `~/.netrc` file to store passwords, see
https://everything.curl.dev/usingcurl/netrc .

For downloading files on the local file system prefix their path with `file://`
as you would to see them in a browser.

# Input
- url -- url for download
- destination -- path (directory + file) where to store it

## Optional keyword args
- force_download -- force the download, even if file is present

# Output:
- file with full path

"""
function download_file(url, dir, file; force_download=false)

    dirfile = joinpath(dir, file)
    mkpath(dir)

    if isfile(dirfile) && !force_download
        # do nothing
        print(" ... already downloaded ... ")
    elseif isfile(dirfile)
        # delete and re-download
        rm(dirfile)
        print(" ... downloading ... ")
        Downloads.download(url, dirfile)
    else
        # download
        Downloads.download(url, dirfile)
    end
    return dirfile
end

######
# File readers
######
"""
    read_campbell(file)

Reads a Campbell logger format file with temperature and precip.
Moves sampling from 30min to 1h

Return
- t -- as DateTime
- T -- [C]
- P -- [m/d]
- elevation -- [m asl]
"""
function read_campbell(file)
    dat = readdlm(file, ',')
    y, d, hm = dat[:,2], dat[:,3], dat[:,4]
    t = parse_date_time.(y,d,hm)
    # go from 30min dt to 60 min
    t = t[1:2:end]
    temp = dat[1:2:end,6]
    precip = dat[1:2:end,7] .+ dat[2:2:end,7] # this needs summing!
    elevation = 2650
    return t, temp, precip/1000*24, elevation
end

######
## Misc helpers
######


"""
    parse_date_time(year, day, hourmin)

Parse the Campbell logger time format:
`year, day of year, HHMM`

Return DateTime object.
"""
function parse_date_time(year, day, hourmin)
    hour = floor(hourmin/100)
    min = hourmin - 100*hour
    return DateTime(year, 1, 1, hour, min) + Day(day-1)
end
# Test it
@assert parse_date_time(2001, 1, 1239) == DateTime(2001, 1, 1, 12, 39)
@assert parse_date_time(2001, 365, 1239) == DateTime(2001, 12, 31, 12, 39)
