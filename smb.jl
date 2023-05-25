"""
    meltrate(T, DDF)

Calculates the melt rate using temperature

Input:
- T -- temperature [C]
- DDF  -- melt factor [m/d/C]

Output:
- meltrate [m/d]
"""
function meltrate(T, DDF)
    if T<=0
        # it's freezing, no melt
        0.0
    elseif T>0
        T*DDF
    end
end

"""
    precip(t)

Solid precipitation (m/day).

Synthetic for now.
"""
precip(t) = 8e-3
# function precip(t, T, solid_threshold)
#     if mod(floor(t), 10)==0 && T<=solid_threshold # rain every 10th day
#         return 80/1e3
#     else
#         return 0.0
#     end
# end
## random rain:
# function precip(t, T, solid_threshold)
#     if rand() > 0.9 && T<=solid_threshold # probability of rain 10% each hour
#         # if it rains assume normal dist of amount
#         return 30/1e3 # max((10*randn() + 30)/1e3, 0)
#     else
#         return 0.0
#     end
# end



"""
    lapse(T, Δelevation, lapsrate)

Lapse the temperature.
"""
lapse(T, Δelevation, lapsrate) = T + lapsrate * Δelevation

"""
    temp(t)

Temperature at time t (days) at 0 elevation.  Synthetic.
"""
temp(t) = -10*cos(2pi/364 * t) - 8*cos(2pi* t) + 5

function yearly_smb(temp_fn, precip_fn, DDF, point_elevation, lapsrate, solid_threshold)
    out = 0.0
    Δt = 1/24
    for t = 0:Δt:365
        T = lapse(temp_fn(t), point_elevation, lapsrate)
        out += Δt * (precip_fn(t, T, solid_threshold) -
                     meltrate(T, DDF))
    end
    return out
end


using Plots
t = 0:1/24:365
plot(t, precip.(t, lapse.(temp.(t), 2400, -0.6/100), 4 ))

@show yearly_smb(temp, precip, 0.005, 15000, -0.6/100, 4)
