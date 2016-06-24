%% Calculates the static margin
% static_margin = hn - h
% Static margin is calcualted using the mean aerodynamic chord (MAC)
%%

function static_margin = fnCalcStaticMargin(CGx, NP, MAC)

% transform to MAC coordinates
% static margin = hn - h
static_margin = (NP - CGx)/MAC;

end