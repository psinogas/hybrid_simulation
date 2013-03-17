function N2O_Tank = MMF_ideal_tank_with_liquid(N2O_Tank, Pe, dt)
    %update last-times values, O = 'old'
    tank_volume                     = N2O_Tank(1);
    tank_fluid_temperature_K        = N2O_Tank(2);
    tank_liquid_mass                = N2O_Tank(3);
    tank_vapour_mass                = N2O_Tank(4);
    mdot_tank_mass_returned_previous = N2O_Tank(5);
    tank_vapourized_mass_old        = N2O_Tank(6);
    tank_pressure_bar               = N2O_Tank(7);
    tank_propellant_contents_mass   = N2O_Tank(8);
    mdot_tank_outflow               = N2O_Tank(11);
    n_lo                            = N2O_Tank(12);
    n_go                            = N2O_Tank(13);
    
    all_nox_prop = nox_prop;
    Tc = all_nox_prop(3);           % critical temperature of N2O [K]
    MW2 = all_nox_prop(6);          % molecular weight of N2O    
    R = all_nox_prop(7);            % ideal gas constant    
    Cd = 0.425;                     % discharge coefficient: Test 1
    % Cd = 0.365;                   % Test 2 and 3
    % Cd = 0.09;                    % Test 4
    Ainj = 0.0001219352;            % injector area [m^2]
    V = tank_volume;
    m_T = 6.4882;                   % tank mass [kg]
    To = tank_fluid_temperature_K;
    
    % Given functions of temperature:
    Vhat_l = 1/(nox_Lrho(To, 'mol_m3'));  %molar specific volume of liquid N2O [m^3/kmol]
    CVhat_g = nox_CpG(To, 'J_kmolK');     %specific heat of N2O gas at constant volume [J/(kmol*K)]
    CVhat_l = nox_CpL(To, 'J_kmolK');     %specific heat of N2O liquid at constant volume, approx. same as at
                                        %constant pressure [J/(kmol*K)] 
        Tr = To/Tc;                     % reduced temperature
    delta_Hv = nox_enthV(Tr, 'J_kmol');     % heat of vapourization of N2O [J/kmol]
    P_sat = nox_vp(To, 'Pa');             % vapour pressure of N2O [Pa]
    dP_sat = nox_vp(To, 'dPa_dT');        % derivative of vapour pressure wrt Temperature 
    Cp_T = (4.8 + 0.00322*To)*155.239;  % specific heat of tank, Aluminum [J/(kg*K)]
    % Simplified expression definitions for solution
    P = (n_go)*R*To/(V-n_lo*Vhat_l);
    a = m_T*Cp_T + n_go*CVhat_g + n_lo*CVhat_l;
    b = P*Vhat_l;
    e = -delta_Hv + R*To;
    f = -Cd*Ainj*sqrt(2/MW2)*sqrt((P-Pe)/Vhat_l);
    j = -Vhat_l*P_sat;
    k = (V - n_lo*Vhat_l)*dP_sat;
    m = R*To;
    q = R*n_go;
    Z = (-f*(-j*a+(q-k)*b))/(a*(m+j) + (q-k)*(e-b));
    W = (-Z*(m*a + (q-k)*e))/(-j*a + (q-k)*b);
    % Derivative Functions
    dT = (b*W+e*Z)/a;
    dn_g = Z;
    dn_l = W;  
    %Foreard Difference Method
    To = To + dT*dt;
    n_go = n_go + dn_g*dt;
    n_lo = n_lo + dn_l*dt;
 
    %update tank contents for next iteration
    N2O_Tank(2) = To;   %tank_fluid_temperature_K;
%    N2O_Tank(3) = tank_liquid_mass;
%    N2O_Tank(4) = tank_vapour_mass;
%    N2O_Tank(5) = mdot_tank_outflow_returned;
%    N2O_Tank(6) = tank_vapourized_mass_old2;
    N2O_Tank(7) = P/100000;
    N2O_Tank(8) = tank_propellant_contents_mass;
%    N2O_Tank(9) = tank_liquid_density;
%    N2O_Tank(10) = tank_vapour_density;
%    N2O_Tank(11) = mdot_tank_outflow2;
    N2O_Tank(12) = n_lo;
    N2O_Tank(13) = n_go;
end