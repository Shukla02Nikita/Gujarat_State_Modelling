#' module_gcamindia_LA119.solar
#'
#' Compute scalars by state to vary capacity factors by state for India.
#'
#' @param command API command to execute
#' @param ... other optional parameters, depending on command
#' @return Depends on \code{command}: either a vector of required inputs,
#' a vector of output names, or (if \code{command} is "MAKE") all
#' the generated outputs: \code{L119.india_state_CapFacScaler_PV}, \code{L119.india_state_CapFacScaler_CSP}.
#' @details This chunk computes scalars by state to vary capacity factors for central station PV and CSP technologies by state.
#' @importFrom assertthat assert_that
#' @importFrom dplyr filter mutate select
#' @importFrom tidyr gather spread
#' @author AM Nov20
module_gcamindia_LA119.solar <- function(command, ...) {
  if(command == driver.DECLARE_INPUTS) {
    return(c(FILE = "gcam-india/india_states_subregions",
             FILE = "gcam-india/A23.india_state_re_capacity_factors"))
  } else if(command == driver.DECLARE_OUTPUTS) {
    return(c("L119.india_state_CapFacScaler_PV",
             "L119.india_state_CapFacScaler_CSP"))
  } else if(command == driver.MAKE) {

    fuel <- value <- State <- . <- value.x <- value.y <- sector <- scaler <-
        state <- state_name <- NULL     # silence package check.

    all_data <- list(...)[[1]]

    # ===================================================
    # Load required inputs
    india_states_subregions <- get_data(all_data, "gcam-india/india_states_subregions")
    A23.india_state_re_capacity_factors <- get_data(all_data, "gcam-india/A23.india_state_re_capacity_factors")

    # ===================================================
    # Calculations and Estimations
    # Create scalers to scale capacity factors read in the assumptions file in the energy folder.
    # These scalers will then be used to create capacity factors by state.
    # The idea is to vary capacity factors for solar technologies by state depending on the varying solar irradiance by state.

    # Converting A23.india_state_re_capacity_factors to long-form
    A23.india_state_re_capacity_factors %>%
      gather(fuel, value, -state) ->
      A23.india_state_re_capacity_factors_longform

    # Calculate average capacity factor by fuel (not including the 0 capacity factors)
    A23.india_state_re_capacity_factors_longform %>%
      group_by(fuel) %>%
      summarise_at(vars(value), funs(mean(.[. != 0]))) -> # Average does not include 0 capacity factors
      Capacityfactor_average

    # Creating scalers by state by dividing capacity factor by the average
    A23.india_state_re_capacity_factors_longform %>%
      left_join_error_no_match(Capacityfactor_average, by = "fuel") %>%
      mutate(scaler = value.x / value.y, sector = "electricity generation") %>%
      select(state, sector, fuel, scaler) ->
      Capacityfactors_scaled_India

    # Creating solar PV table by using Urban_Utility_scale_PV fuel values
    Capacityfactors_scaled_India %>%
      filter(fuel == "utility_scale_PV") %>%
      mutate(fuel = "solar PV") ->
      L119.india_state_CapFacScaler_PV

    # Creating solar CSP table by using CSP fuel values
    Capacityfactors_scaled_India %>%
      filter(fuel == "CSP") %>%
      mutate(fuel = "solar CSP") %>%
      # Null CSP capacity factor implies that CSP is not suitable in the state or the information is unavailable for the state
      # Set capacity factor to a small number ( say 0.001) to prevent divide by 0 error in GCAM.
      mutate(scaler = if_else(scaler > 0, scaler, 0.001)) ->
      L119.india_state_CapFacScaler_CSP

    # ===================================================
    # Produce Outputs
    L119.india_state_CapFacScaler_PV %>%
      add_title("Scalar to vary PV capacity factors by states for India") %>%
      add_units("Unitless") %>%
      add_comments("The scalars are generated by dividing data on capacity factors by state by national average capacity factors") %>%
      add_legacy_name("L119.india_state_CapFacScaler_PV") %>%
      add_precursors("gcam-india/india_states_subregions", "gcam-india/A23.india_state_re_capacity_factors") ->
      L119.india_state_CapFacScaler_PV

    L119.india_state_CapFacScaler_CSP %>%
      add_title("Scalar to vary CSP capacity factors by state for India") %>%
      add_units("Unitless") %>%
      add_comments("The scalars are generated by dividing data on capacity factors by state by national average capacity factor") %>%
      add_legacy_name("L119.india_state_CapFacScaler_CSP") %>%
      add_precursors("gcam-india/india_states_subregions", "gcam-india/A23.india_state_re_capacity_factors") ->
      L119.india_state_CapFacScaler_CSP

    return_data(L119.india_state_CapFacScaler_PV, L119.india_state_CapFacScaler_CSP)
  } else {
    stop("Unknown command")
  }
}
