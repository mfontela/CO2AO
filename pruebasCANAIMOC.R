                carb(flag=A$flag, 
                     var1=XXXXXX(mol/kg, except for pH),
                     var2=XXXXXX(mol/kg, except for pH),                                 
                     S=A$G2salinity, 
                     T=A$G2theta, 
                     P=A$G2pressure/10, #pressure in bar!
                     Patm=1.0, 
                     Pt=A$G2phosphate/10^6, #Nutrients in mols/Kg
                     Sit=A$G2silicate/10^6,
                     pHscale="T", kf="pf", k1k2="l", ks="d", b="u74"))
