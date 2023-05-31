using Dates


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
