% All vectors below must have the same number of columns
%
% GJ, EI = vectors of stiffnesses at each section
% SWEEP = a vector of EA sweep angles (rad) at each section
% DY = a vector of spanwise discretization
%
% Note: stiffness matrix and flexibility matrix are inverse of each other

function [Czz, Czt, Ctt] = fnCalcSpanFlexibilityMatrix(GJ, EI, SWEEP, DY)

% Calculate for the flexibility matrix

% discretization
N = length(GJ);
% x contains the nodes where flexibility values will be calculated
x = zeros(N,1);
for i=1:N
    if i==1
        x(i) = DY(i)/2;
    else
        x(i) = x(i-1) + DY(i-1)/2 + DY(i)/2;
    end
end

%
% Now find the matrix of flexibility coefficients Cij
%
Czz = zeros(N,N);
Ctt = zeros(N,N);
Czt = zeros(N,N);
for i=1:N  % deflection point
    for j=1:N % load point
        %
        % find upper limit for integration
        %
        xupper = min(x(i),x(j));
        %
        % now integrate beam segments until we reach end
        %
        xbeg = 0; k=0;
        while (xbeg < xupper)
            delta = DY(k+1);
            xend = xbeg + delta;
            % account for partial segment
            if xend > xupper
                xend = xupper;
            end

            k = k+1;
            sweep = SWEEP(k);
            ei = EI(k); gj = GJ(k);
            
            % beam integrals
            %
            I1 = (xend-xbeg)/ei;
            I2 = (xend^2 - xbeg^2)/2/ei;
            I3 = (xend^3 - xbeg^3)/3/ei;
            %
            % torsion
            %
            T1 = 1/gj*(xend-xbeg);
            T2 = 1/ei*(xend-xbeg);
            %
            % coupled integrals
            %
            P1 = T2;
            P2 = I2;
            Czz(i,j) = Czz(i,j) + 1/cos(sweep)^3*(x(i)*x(j)*I1 -(x(i)+x(j))*I2 + I3);
            Ctt(i,j) = Ctt(i,j) + cos(sweep)*T1 + sin(sweep)^2/cos(sweep)*T2;
            Czt(i,j) = Czt(i,j) + -tan(sweep)/cos(sweep)*(x(i)*P1 - P2);

            xbeg = xbeg + delta;
        end
    end
end

end