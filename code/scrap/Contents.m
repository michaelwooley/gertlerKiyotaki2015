% CODE
%
% Files
%   alpha              - alpha - parameter
%   beta               - beta - parameter
%   final              - final - Econ 416
%   sig                - sig - parameter
%   theta              - theta - parameter
%   Wb                 - Wb - parameter
%   Wh                 - Wh - parameter
%   Crun               - Crun - C* in run state - Z + Wh - alpha/2
%   Vgt                - VGT
%   Vlt                - VLT
%   Z                  - - Parameter - 0.0126
%   ssTest             - SS Test Script
%   xGt1SS             - % Find state vector 's' s.t. x > 1 in SS.
%   xLt1SS             - % Find state vector 's' s.t. x < 1 in SS.
%   CbSs               - CbSs - Cb given a state vector s = [Q,Kh,D,R]
%   ChSs               - ChSs - Ch given a state vector s = [Q,Kh,D,R]
%   H2gt               - H2GT
%   H2lt               - H2LT
%   Hgt                - HGT
%   Hlt                - HLT
%   MLND               - - Maximal Leverage/No-default condition out of SS 
%   MLNdSs             - MLNdSs - Maximal Leverage/No-default condition in SS 
%   PhiSs              - PhiSs - Phi given a state vector s = [Q,Kh,D,R]
%   constraintWarnings - constraintWarnings - Warnings when model constraints violated.
%   ecGt2Lt1           - % Eqn Conditions. Case t > 2, xtp1 < 1
%   eqnCondFtn         - % Equilibrium Conditions => Function
%   extPath            - extPath - Find path of solution given init, SS vectors
%   fsolveEfMsg        - fsolveEfMsg - Returns Msg for fsolve exit flag f 
%   jacobBreakOff      - Test if can take W/Jacobian just once 
%   nSs                - nSs - N in SS given a state vector s = [Q,Kh,D,R]
%   pathLtNlCon        - ssLtNlCon - non-linear constraints for path w/ x < 1
%   slnIterProto       - Solution Iteration Prototype
%   ssLtFind           - ssLtFind - Function for finding SS vectors
%   ssLtFindTest       - ssLtFind Test Script
%   ssLtInitDraw       - ssLtInitDraw - Draw a permissable s0 to initiate fsolve.
%   ssLtInitDrawTest   - ssLtInitDraw Test Script
%   ssLtMap            - Steady State Map for x < 1
%   ssLtNlCon          - ssLtNlCon - non-linear constraints for SS w/ x < 1
%   xSs                - xSs - x given a state vector s = [Q,Kh,D,R]
%   Hbsn               - HBSN
%   HcompileLt         - HcompileLt - Compile H - case x < 1
%   HcompileLtProto    - % HcompileLtProto - Compile H - case x < 1 - Prototype
%   HcompileLtTest     - Test Script for HcompileLt
%   Hlt2               - HLT2
%   dH2lt              - DH2LT
%   dHcompileLtProto   - % dHcompileLtProto - Compile dH - case x < 1 - Prototype
%   dHlt               - DHLT
%   dHltLast           - DHLTLAST
%   ecEq2Lt1           - % Eqn Conditions. Case t = 2, xtp1 < 1
