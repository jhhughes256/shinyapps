# Define the model parameters and equations
	# Using mrgsolve - analytical solutions
	# This compiled model is used for simulating n individuals and their concentration-time profiles
	# Cannot have whitespace before $ blocks
# ------------------------------------------------------------------------------
# Set PATH for mrgsolve and run app -------------------------------------------
  if(interactive()) {
  # Get version of R
    Rversion <- paste("R-", getRversion(), sep="")
  # Set path for Rtools
    Sys.setenv(PATH = paste0(glue::glue(
      "c:/program files/R/{Rversion}/bin/x64/;", "c:/RTools/bin/;",
      "c:/RTools/mingw_64/bin/;", Sys.getenv("PATH")
    )))  # Sys.setenv
  }

	code <- '
$INIT // Initial conditions for compartments
	DEPOT = 0,  // Depot - dose enters the system here
	TRAN1 = 0,  // Transit compartment 1
	TRAN2 = 0,  // Transit compartment 2
	CENT = 0,  // Central
	AUC = 0,  // Area under the curve compartment
	
$PARAM  // Population parameters
	POPCL = 12,  // Clearance, L/h
	POPV1 = 68.8,  // Volume of central compartment, L
	POPKTR = 6.5,  // Absorption rate constant, h^-1
	// Covariate effects
	COV1 = 0.224,	// Effect of creatine clearance on clearance
  // Default covariate values for simulation
	STUDY = 0,  // Patient study
	FFM = 55,  // Fat free mass (kg)
  CRCL = 90,  // Creatinine clearance (umol/L)
  
$OMEGA  // Omega covariance block
  @annotated @block
	BSV_CL: 0.2959 : BSV for CL
	BSV_V1: 0.2469 0.2841 : BSV for V1
	
$OMEGA  // Omega variance
	@annotated
	BSV_KTR: 0.3672 : BSV for KTR
	
$SIGMA  // Sigma
  @annotated
	ERR_PRO: 0.1849 : Proportional error combined
	
$MAIN  // Determine covariate values
	// Individual parameter values
	double CL = POPCL*pow(FFM/55,0.75)*pow(CRCL/90,COV1)*exp(BSV_CL);
	double V1 = POPV1*(FFM/55)*exp(BSV_V1);
	double KTR = POPKTR*exp(BSV_KTR);
	
$ODE  // Differential equations
	dxdt_DEPOT = -KTR*DEPOT;
	dxdt_TRAN1 = KTR*DEPOT -KTR*TRAN1;
	dxdt_TRAN2 = KTR*TRAN1 -KTR*TRAN2;
	dxdt_CENT = KTR*TRAN2 -CL/V1*CENT;
	dxdt_AUC = CENT/V1;
	
$TABLE  // Determine individual predictions
  double IPRE = CENT/V1;
	double DV = IPRE*(1+ERR_PRO);
	
$CAPTURE  // Capture output
  IPRE DV CL V1 KTR
'
	# Compile the model code
	mod <- mcode("lenamod",code)
	