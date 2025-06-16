(* 
   SpectralToolkit Quick Start Examples
   
   This file contains simple examples to get you started with SpectralToolkit.
   For comprehensive examples, see SpectralToolkit_Tests.ipynb
*)

(* Load the package *)
Get["SpectralToolkit.wl"]

(* Example 1: Basic Spectral Integration *)
Print["Example 1: High-speed numerical integration"]
result1 = SpectralIntegrate[Exp[x] Sin[x], {x, 0, Pi}, 101];
exact1 = (Exp[Pi] + 1)/2;
Print["Spectral result: ", result1];
Print["Exact result: ", exact1];
Print["Error: ", Abs[result1 - exact1]];
Print[""];

(* Example 2: Spectral Differentiation *)
Print["Example 2: Spectral differentiation of exp(x)"]
n = 20;
{a, b} = {0, 1};
xPoints = ChebyshevAllocation[{a, b}, n];
fValues = Exp[xPoints];  (* f(x) = e^x *)
derivative = SpectralDifferentiate[fValues, {a, b}, 1];
exact = Exp[xPoints];  (* f'(x) = e^x for f(x) = e^x *)
maxError = Max[Abs[derivative - exact]];
Print["Maximum error in derivative: ", maxError];
Print["Relative error: ", maxError/Max[exact]];
Print[""];

(* Example 3: Spectral Interpolation *)
Print["Example 3: High-order interpolation"]
testFunc = Function[x, 1/(1 + 16x^2)];  (* Runge function *)
n = 17;
{a, b} = {-1, 1};
xCheby = ChebyshevAllocation[{a, b}, n];
fCheby = testFunc[xCheby];
spectralInterp = GetSpectral[fCheby, {a, b}, x];

(* Test interpolation at a point *)
testPoint = 0.5;
interpValue = spectralInterp /. x -> testPoint;
exactValue = testFunc[testPoint];
Print["Interpolated value at x=0.5: ", interpValue];
Print["Exact value: ", exactValue];
Print["Error: ", Abs[interpValue - exactValue]];
Print[""];

(* Example 4: Performance Comparison *)
Print["Example 4: Performance comparison"]
testFunc4 = Function[x, Sin[10x] Exp[-x^2]];

(* Time spectral integration *)
{spectralTime, spectralResult} = AbsoluteTiming[
  SpectralIntegrate[testFunc4[x], {x, -2, 2}, 101]
];

(* Time NIntegrate *)
{nintegrateTime, nintegrateResult} = AbsoluteTiming[
  NIntegrate[testFunc4[x], {x, -2, 2}]
];

Print["Spectral integration: ", spectralTime, " seconds"];
Print["NIntegrate: ", nintegrateTime, " seconds"];
Print["Speedup: ", nintegrateTime/spectralTime, "x"];
Print["Results agree: ", Abs[spectralResult - nintegrateResult] < 10^-10];

Print[""];
Print["SpectralToolkit examples completed successfully!"];
Print["For more advanced examples, run SpectralToolkit_Tests.ipynb"];