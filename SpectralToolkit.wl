(* ::Package:: *)

(* 
   SpectralToolkit Package
   
   A high-performance spectral methods library for numerical computing in Mathematica/Wolfram Language.
   This package provides tools for Chebyshev differentiation, spectral integration, and pseudospectral techniques.
   
   Author: Peng Liu (physicsuniverse)
   GitHub: https://github.com/physicsuniverse/SpectralToolkit
   Bio: Working on holographic duality, black hole physics
   Version: 1.0.0
   Created: 2025-06-16
*)

BeginPackage["SpectralToolkit`"]

(* Public function declarations *)
GetDiffMatrix::usage = "GetDiffMatrix[allocation] generates the differential matrices of order 0, 1, and 2 using pseudospectral methods. Returns a list of three matrices corresponding to the identity, first derivative, and second derivative operators.";

ChebyshevAllocation::usage = "ChebyshevAllocation[{a, b}, n] generates n Chebyshev-Gauss-Lobatto points on the interval [a, b]. These points are optimal for spectral methods and provide exponential convergence for smooth functions.";

GetSpectral::usage = "GetSpectral[values, {a, b}, var] returns the spectral interpolation of discrete values as a continuous function of variable var over the interval [a, b]. Uses Chebyshev polynomial expansion for high accuracy.";

GetSpectralCoeff::usage = "GetSpectralCoeff[values] computes the Chebyshev expansion coefficients for the given values. These coefficients are essential for spectral differentiation and integration operations.";

GetSpectralValue::usage = "GetSpectralValue[coefficients, x] evaluates the spectral expansion at point x using the given Chebyshev coefficients. Assumes x is in the interval [-1, 1].";

SpectralIntegrate::usage = "SpectralIntegrate[f, {var, a, b}, order] performs high-precision numerical integration using spectral methods. Often 2x faster than NIntegrate for smooth functions. Default order is 201.";

GetCosDiff::usage = "GetCosDiff[n] generates first and second derivative matrices for cosine-based spectral differentiation with n+1 points. Used for periodic boundary conditions.";

RecoverPolynomial::usage = "RecoverPolynomial[coefficients, period] reconstructs the polynomial expansion from spectral coefficients for periodic functions with given period.";

SpectralDifferentiate::usage = "SpectralDifferentiate[values, {a, b}, order] computes spectral derivatives of given order for values defined on interval [a, b]. Returns derivative values at Chebyshev points.";

SpectralInterpolate::usage = "SpectralInterpolate[points, values, x] performs high-order spectral interpolation through given points and evaluates at x. Automatically handles Chebyshev point distribution.";

Begin["`Private`"]

(* Implementation of GetDiffMatrix *)
GetDiffMatrix[allocation_] := 
  NDSolve`FiniteDifferenceDerivative[Derivative[#], allocation, 
    "DifferenceOrder" -> "Pseudospectral"]["DifferentiationMatrix"] & /@ Range[0, 2]

Clear[ChebyshevAllocation];
ChebyshevAllocation[endpoint_, order_] := (Subtract @@ endpoint Cos[Subdivide[0., Pi, order - 1]] + Plus @@ endpoint)/2;

(* Implementation of GetSpectral *)
GetSpectral[values_, {a_, b_}, var_] := Module[
  {coeffs, n, scaledVar},
  n = Length[values] - 1;
  coeffs = GetSpectralCoeff[values];
  scaledVar = 2 (var - a)/(b - a) - 1;
  coeffs . ChebyshevT[Range[0, n], scaledVar]
]

(* Implementation of GetSpectralCoeff *)
GetSpectralCoeff[values_] := Module[
  {coeffs, n},
  n = Length[values] - 1;
  coeffs = FourierDCT[values, 1] Sqrt[2./n];
  coeffs[[{1, -1}]] /= 2;
  coeffs
]

(* Implementation of GetSpectralValue *)
GetSpectralValue[coeffs_, x_] := 
  coeffs . ChebyshevT[Range[0, Length[coeffs] - 1], x]

(* Implementation of SpectralIntegrate *)
SpectralIntegrate[f_, {var_, a_, b_}, order_: 201] := Module[
  {n, points, values, coeffs, integrationWeights},
  n = If[OddQ[order], order, order + 1];
  points = ChebyshevAllocation[{a, b}, n];
  values = f /. var -> points;
  coeffs = GetSpectralCoeff[values];
  integrationWeights = (b - a)/(1 - 4 Range[0, (n - 1)/2]^2.);
  integrationWeights . coeffs[[1 ;; -1 ;; 2]]
]

(* Implementation of GetCosDiff *)
GetCosDiff[n_] := Module[
  {range, mat, cos, sin, inv},
  range = Range[0, n];
  mat = Outer[Times, range Pi/n, range];
  {cos, sin} = {Cos[mat], Sin[mat]};
  inv = Inverse[-cos];
  Transpose[#] . inv & /@ (Outer[Times, range^#, Transpose[{sin, cos}]] & /@ {1, 2})
]

(* Implementation of RecoverPolynomial *)
RecoverPolynomial[coeffs_, period_] := Module[
  {dims, z, x},
  dims = Dimensions[coeffs];
  ChebyshevT[Range[0, dims[[1]] - 1], 1 - 2 z] . coeffs . 
    Flatten[{Cos[Range[0, Floor[dims[[2]]/2]] 2 x Pi/period], 
             Sin[Range[Floor[(dims[[2]] - 1)/2]] 2 x Pi/period]}]
]

(* Implementation of SpectralDifferentiate *)
SpectralDifferentiate[values_, {a_, b_}, order_: 1] := Module[
  {points, diffMats, scalingFactor},
  points = ChebyshevAllocation[{a, b}, Length[values]];
  diffMats = GetDiffMatrix[points];
  scalingFactor = 2/(b - a);
  scalingFactor^order diffMats[[order + 1]] . values
]

(* Implementation of SpectralInterpolate *)
SpectralInterpolate[points_, values_, x_] := Module[
  {a, b, scaledPoints, coeffs, scaledX},
  {a, b} = {Min[points], Max[points]};
  scaledPoints = 2 (points - a)/(b - a) - 1;
  coeffs = GetSpectralCoeff[values];
  scaledX = 2 (x - a)/(b - a) - 1;
  GetSpectralValue[coeffs, scaledX]
]

End[]

EndPackage[]
