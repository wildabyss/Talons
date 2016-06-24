function CD = fnCalcDrag(CL, CD0, e, AR)

CD = CD0 + CL.^2/pi/e/AR;

end