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
    acc(P_m, T_th, T)

Accumulation give temperature and precipitation rate.

Input:
- P_m -- precipitation
- T_th -- threshold temperature
- T -- temperature
"""
function acc(P_m, T_th, T)
    if T>T_th
        return 0.0
    else
        return P_m
    end
end

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

"""
    precip(t)

Solid precipitation (m/day).

Synthetic for now.
"""
precip(t) = 8e-3

function solid_precip(precip, T, T_th)
    if T<=T_th
        return precip
    else
        return 0.0
    end
end


function integrate_smb(t_start, t_end, temp_fn, precip_fn, DDF,
                       point_elevation, lapsrate, T_th)
    out = 0.0
    Δt = 1/24
    for t = t_start:Δt:t_end-1/48 # exclusive of last point in interval
        T = lapse(temp_fn(t), point_elevation, lapsrate)
        out = out + Δt * (solid_precip(precip_fn(t), T, T_th) -
                          meltrate(T, DDF))
    end
    return out
end


"""
    yearly_smb(temp_fn, precip_fn, DDF, point_elevation, lapsrate, T_th)

NOTE: this integrates the point smb with hourly intervals... probably more appropriate
would be on a daily basis as we use a DDF.  However, I cannot get myself to use
such coarse integration...
"""
yearly_smb(temp_fn, precip_fn, DDF, point_elevation, lapsrate, T_th) =
    integrate_smb(0, 365-1/48,
                  temp_fn, precip_fn, DDF, point_elevation, lapsrate, T_th)

using Plots
t = 0:1/24:365
plot(t, temp.(t))

@show yearly_smb(temp, precip, 0.005, 2000, -0.6/100, 4)

## task 8: length of glacier
cumulated_smb = 0.0

for z = 5000:-10:-10000
    global cumulated_smb = cumulated_smb + yearly_smb(temp, precip, 0.005, z, -0.6/100, 4)
    if cumulated_smb < 0
        # end integration when cumulative mass balance goes negative: we've reached the terminus
        global z_terminus = z
        break
    end
end
@show z_terminus
println("When using daily steps in the yearly_smb function, I get z_terminus = -2050")
