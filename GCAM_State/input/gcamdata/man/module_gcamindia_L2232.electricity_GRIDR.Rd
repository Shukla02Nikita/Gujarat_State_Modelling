% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zchunk_L2232.electricity_GRIDR_india.R
\name{module_gcamindia_L2232.electricity_GRIDR}
\alias{module_gcamindia_L2232.electricity_GRIDR}
\title{module_gcamindia_L2232.electricity_GRIDR}
\usage{
module_gcamindia_L2232.electricity_GRIDR(command, ...)
}
\arguments{
\item{command}{API command to execute}

\item{...}{other optional parameters, depending on command}
}
\value{
Depends on \code{command}: either a vector of required inputs,
a vector of output names, or (if \code{command} is "MAKE") all
the generated outputs: \code{L2232.DeleteSupplysector_INDIAelec}, \code{L2232.india_state_Supplysector_elec},
\code{L2232.india_grid_SubsectorShrwtFllt_elec}, \code{L2232.india_grid_SubsectorInterp_elec}, \code{L2232.india_grid_SubsectorLogit_elec},
\code{L2232.india_grid_TechShrwt_elec}, \code{L2232.india_grid_TechCoef_elec}, \code{L2232.india_grid_Production_exports_elec},
\code{L2232.india_grid_Supplysector_elec_CEA}, \code{L2232.india_grid_ElecReserve_CEA}, \code{L2232.india_grid_SubsectorShrwtFllt_elec_CEA},
\code{L2232.india_grid_SubsectorInterp_elec_CEA}, \code{L2232.india_grid_SubsectorLogit_elec_CEA}, \code{L2232.india_grid_TechShrwt_elec_CEA},
\code{L2232.india_grid_TechCoef_elec_CEA}, \code{L2232.india_grid_TechCoef_elecownuse_CEA}, \code{L2232.india_grid_Production_imports_CEA},
\code{L2232.india_grid_Production_elec_gen_CEA}, \code{L2232.india_grid_StubTechElecMarket_backup}. The corresponding file in the
original data system was \code{L2232.electricity_CEA_USA.R} (gcam-india level2).
}
\description{
Generate GCAM-India model inputs for electrcity trade sectors at the level of grid regions.
}
\details{
This chunk generates input files to create electricity trade and passthrough sectors for the grid regions,
and balances electricity supply and demand for each grid region.
}
\author{
VC Nov20
}
