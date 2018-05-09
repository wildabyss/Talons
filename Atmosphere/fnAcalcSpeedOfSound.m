function a = fnAcalcSpeedOfSound(theta, unit)
% Calculate the speed of sound given the temperature ratio
% Inputs: theta: temp ratio
%         unit: 0=imperial (kt), 1=SI (m/s)
% Outputs: speed of sound in kt or m/s

a0 = 661.48;    % [kt]
a = a0.*theta.^0.5;

if unit==1
    % Convert to m/s
    a = a*0.514444;
end

end
