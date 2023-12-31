% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zchunk_L222.en_transformation_india.R
\name{module_gcamindia_L222.en_transformation}
\alias{module_gcamindia_L222.en_transformation}
\title{module_gcamindia_L222.en_transformation}
\usage{
module_gcamindia_L222.en_transformation(command, ...)
}
\arguments{
\item{command}{API command to execute}

\item{...}{other optional parameters, depending on command}
}
\value{
Depends on \code{command}: either a vector of required inputs,
a vector of output names, or (if \code{command} is "MAKE") all
the generated outputs: \code{L222.india_state_DeleteStubTech_en}, \code{L222.india_state_PassThroughSector_en}, \code{L222.india_state_Tech_en}, \code{L222.india_state_TechShrwt_en}, \code{L222.india_state_TechInterp_en}, \code{L222.india_state_TechShrwt_en}, \code{L222.india_state_TechCoef_en}, \code{L222.india_state_Production_refining}, \code{L222.SectorLogitTables_india[[ curr_table ]]$data}, \code{L222.india_state_Supplysector_en}, \code{L222.india_state_SubsectorShrwtFllt_en}, \code{L222.india_state_StubTechProd_refining}, \code{L222.india_state_StubTechMarket_en}, \code{L222.india_state_CarbonCoef_en}. The corresponding file in the
original data system was \code{L222.en_transformation_india.R} (gcam-india level2).
}
\description{
Prepare the assumptions and calibrated outputs for energy transformation supplysectors, subsectors, and technologies specific to india sectors and/or states.
}
\details{
This chunk sets up the india energy transformation technology databases as well as writing out assumptions to all states/sectors/markets for shareweights and logits.
Calibrated outputs and I:O coefficients are updated from global values produced by \code{\link{module_energy_L222.en_transformation}}.
}
\author{
VC Nov20
}
