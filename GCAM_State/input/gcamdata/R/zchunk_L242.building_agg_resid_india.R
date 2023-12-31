#' module_gcamindia_L242.building_agg_resid
#'
#' Calculate supply sector, subsector, and technology information for the resid sector
#'
#' @param command API command to execute
#' @param ... other optional parameters, depending on command
#' @return Depends on \code{command}: either a vector of required inputs,
#' a vector of output names, or (if \code{command} is "MAKE") all
#' the generated outputs: \code{L242.india_state_DeleteSupplysector_bld}, \code{L242.india_state_DeleteFinalDemand_bld}, \code{L242.india_state_Supplysector_resid}, \code{L242.india_state_FinalEnergyKeyword_resid}, \code{L242.india_state_SubsectorLogit_resid},
#' \code{L242.india_state_SubsectorShrwtFllt_resid}, \code{L242.india_state_SubsectorInterp_resid}, \code{L242.india_state_StubTech_resid},
#' \code{L242.india_state_GlobalTechInterp_resid}, \code{L242.india_state_GlobalTechShrwt_resid}, \code{L242.india_state_GlobalTechEff_resid},
  #' \code{L242.india_state_GlobalTechCost_resid}, \code{L242.india_state_StubTechCalInput_resid}, \code{L242.india_state_StubTechMarket_resid}, \code{L242.india_state_FuelPrefElast_resid},
#' \code{L242.india_state_PerCapitaBased_resid}, \code{L242.india_state_PriceElasticity_resid}, \code{L242.india_state_IncomeElasticity_resid}, \code{L242.india_state_BaseService_resid}. The corresponding file in the
#' original data system was \code{L242.building_agg.R} (energy level2).
#' @details Calculate shareweights, cost, price elasticity, calibrated, and other data for the building sector
#' @importFrom assertthat assert_that
#' @importFrom dplyr filter mutate select
#' @importFrom tidyr gather spread
#' @author AJS August 2017
module_gcamindia_L242.building_agg_resid <- function(command, ...) {
  if(command == driver.DECLARE_INPUTS) {
    return(c(FILE = "gcam-india/india_states_subregions",
             FILE = "gcam-india/A42.india_state_calibrated_tech_resid",
             FILE = "gcam-india/A42.india_state_sector_resid",
             FILE = "gcam-india/A42.india_state_subsector_interp_resid",
             FILE = "gcam-india/A42.india_state_subsector_logit_resid",
             FILE = "gcam-india/A42.india_state_subsector_shrwt_resid",
             FILE = "gcam-india/A42.india_state_globaltech_cost_resid",
             FILE = "gcam-india/A42.india_state_globaltech_eff_resid",
             FILE = "gcam-india/A42.india_state_globaltech_shrwt_resid",
             FILE = "gcam-india/A42.india_state_globaltech_interp_resid",
             FILE = "gcam-india/A42.india_state_fuelprefElasticity_resid",
             FILE = "gcam-india/A42.india_state_demand_resid",
             FILE = "gcam-india/A42.india_state_price_elasticity_resid",
             FILE = "gcam-india/A42.india_state_income_elasticity_resid",
             "L242.Supplysector_bld",
             "L242.PerCapitaBased_bld",
             "L142.india_state_in_EJ_resid_F"))
  } else if(command == driver.DECLARE_OUTPUTS) {
    return(c("L242.india_state_DeleteSupplysector_bld",
             "L242.india_state_DeleteFinalDemand_bld",
             "L242.india_state_Supplysector_resid",
             "L242.india_state_FinalEnergyKeyword_resid",
             "L242.india_state_SubsectorLogit_resid",
             "L242.india_state_SubsectorShrwtFllt_resid",
             "L242.india_state_SubsectorInterp_resid",
             "L242.india_state_StubTech_resid",
             "L242.india_state_GlobalTechInterp_resid",
             "L242.india_state_GlobalTechShrwt_resid",
             "L242.india_state_GlobalTechEff_resid",
             "L242.india_state_GlobalTechCost_resid",
             "L242.india_state_StubTechCalInput_resid",
             "L242.india_state_StubTechMarket_resid",
             "L242.india_state_FuelPrefElast_resid",
             "L242.india_state_PerCapitaBased_resid",
             "L242.india_state_PriceElasticity_resid",
             "L242.india_state_IncomeElasticity_resid",
             "L242.india_state_BaseService_resid"))
  } else if(command == driver.MAKE) {

    all_data <- list(...)[[1]]

    # Silence package notes
    . <- GCAM_region_ID <- MgdFor_adj <- base.service <- technology <- to.value <-
      calibrated.value <- coefficient <- curr_table <- efficiency <- fuel <-
      has_district_heat <- input.cost <- logit.exponent <- minicam.energy.input <-
      minicam.non.energy.input <- output <- region <- region_subsector <- sector <-
      share.weight <- share.weight.year <- stub.technology <- subsector <- supplysector <-
      tradbio_region <- year <- year.fillout <- value <- apply.to <- from.year <- to.year <-
      interpolation.function <- sector.name <- subsector.name <- subs.share.weight <-
      tech.share.weight <- fuelprefElasticity <- perCapitaBased <- energy.final.demand <-
      price.elasticity <- logit.type <- output.unit <- input.unit <- price.unit <-
      logit.year.fillout <- final.energy <- NULL


    # Load required inputs
    india_states_subregions <- get_data(all_data, "gcam-india/india_states_subregions")
    L242.Supplysector_bld <- get_data(all_data, "L242.Supplysector_bld")
    L242.PerCapitaBased_bld <- get_data(all_data, "L242.PerCapitaBased_bld")
    A42.india_state_calibrated_tech_resid <- get_data(all_data, "gcam-india/A42.india_state_calibrated_tech_resid")
    A42.india_state_sector_resid <- get_data(all_data, "gcam-india/A42.india_state_sector_resid")
    A42.india_state_subsector_interp_resid <- get_data(all_data, "gcam-india/A42.india_state_subsector_interp_resid")
    A42.india_state_subsector_logit_resid <- get_data(all_data, "gcam-india/A42.india_state_subsector_logit_resid")
    A42.india_state_subsector_shrwt_resid <- get_data(all_data, "gcam-india/A42.india_state_subsector_shrwt_resid")
    A42.india_state_globaltech_cost_resid <- get_data(all_data, "gcam-india/A42.india_state_globaltech_cost_resid")
    A42.india_state_globaltech_eff_resid <- get_data(all_data, "gcam-india/A42.india_state_globaltech_eff_resid")
    A42.india_state_globaltech_shrwt_resid <- get_data(all_data, "gcam-india/A42.india_state_globaltech_shrwt_resid")
    A42.india_state_globaltech_interp_resid <- get_data(all_data, "gcam-india/A42.india_state_globaltech_interp_resid")
    A42.india_state_fuelprefElasticity_resid <- get_data(all_data, "gcam-india/A42.india_state_fuelprefElasticity_resid")
    A42.india_state_demand_resid <- get_data(all_data, "gcam-india/A42.india_state_demand_resid")
    A42.india_state_price_elasticity_resid <- get_data(all_data, "gcam-india/A42.india_state_price_elasticity_resid")
    A42.india_state_income_elasticity_resid <- get_data(all_data, "gcam-india/A42.india_state_income_elasticity_resid")
        L142.india_state_in_EJ_resid_F <- get_data(all_data, "L142.india_state_in_EJ_resid_F")

    # ===================================================

    A42.india_state_calibrated_tech_resid <- A42.india_state_calibrated_tech_resid %>% mutate(region = "India")
    A42.india_state_sector_resid <- A42.india_state_sector_resid %>% mutate(region = "India")
    A42.india_state_subsector_interp_resid <- A42.india_state_subsector_interp_resid %>% mutate(region = "India")
    A42.india_state_subsector_logit_resid <- A42.india_state_subsector_logit_resid %>% mutate(region = "India")
    A42.india_state_subsector_shrwt_resid <- A42.india_state_subsector_shrwt_resid %>% mutate(region = "India")
    A42.india_state_globaltech_cost_resid <- A42.india_state_globaltech_cost_resid %>% mutate(region = "India")
    A42.india_state_globaltech_eff_resid <- A42.india_state_globaltech_eff_resid %>% mutate(region = "India")
    A42.india_state_globaltech_shrwt_resid <- A42.india_state_globaltech_shrwt_resid %>% mutate(region = "India")
    A42.india_state_globaltech_interp_resid <- A42.india_state_globaltech_interp_resid %>% mutate(region = "India")
    A42.india_state_fuelprefElasticity_resid <- A42.india_state_fuelprefElasticity_resid %>% mutate(region = "India")
    A42.india_state_demand_resid <- A42.india_state_demand_resid %>% mutate(region = "India")
    A42.india_state_price_elasticity_resid <- A42.india_state_price_elasticity_resid %>% mutate(region = "India")
    A42.india_state_income_elasticity_resid <- A42.india_state_income_elasticity_resid %>% mutate(region = "India")


    # delete building sectors in the india region (energy-final-demands and supplysectors)
    L242.Supplysector_bld %>%
      mutate(region = region) %>% # strip attributes from object
      filter(region == gcam.india_REGION) %>%
      select(LEVEL2_DATA_NAMES[["DeleteSupplysector"]]) ->
      L242.india_state_DeleteSupplysector_bld  ## OUTPUT

    # deleting energy final building sector in the full india region")
    L242.PerCapitaBased_bld %>%
      mutate(region = region) %>% # strip attributes from object
      filter(region == gcam.india_REGION) %>%
      select(LEVEL2_DATA_NAMES[["DeleteFinalDemand"]]) ->
      L242.india_state_DeleteFinalDemand_bld  ## OUTPUT


    # convert to long form
    A42.india_state_globaltech_eff_resid <- A42.india_state_globaltech_eff_resid %>%
      gather_years

    A42.india_state_globaltech_cost_resid <- A42.india_state_globaltech_cost_resid %>%
      gather_years

    A42.india_state_globaltech_shrwt_resid <- A42.india_state_globaltech_shrwt_resid %>%
      gather_years

    A42.india_state_price_elasticity_resid <- A42.india_state_price_elasticity_resid %>%
      gather_years()

    A42.india_state_income_elasticity_resid <- A42.india_state_income_elasticity_resid %>%
      gather_years()



    # The resid_india_processing function is used in place of a for loop in the old data sytem.
    # This function checks to see if the input data needs to be expanded to all states or used as
    # is.

    # resid_india_processing: is a function that
    resid_india_processing <- function(data) {

      # Subset the input data frame for the india region. The subsetted data will be used
      # to check to see if the data frame needs to be processed, it's assumed that if the india
      # is not found in the region column that regions have already been processed.

      check_india <- filter(data, region == gcam.india_REGION)

      if(nrow(check_india) == 0) {

        # This does not change the entries of the data frame but will strip the attributes
        # from the input data frame.
        new_data <- mutate(data, region = region)

      } else {

        # If the input data frame contains india region information
        # then expand the input data to all states.

        data %>%
          filter(region == gcam.india_REGION) %>%
          write_to_all_india_states(names = names(data)) ->
          new_data

      }

      return(new_data)
    } # end of function

    A42.india_state_sector_resid <- resid_india_processing(A42.india_state_sector_resid)
    A42.india_state_subsector_interp_resid <- resid_india_processing(A42.india_state_subsector_interp_resid)
    A42.india_state_subsector_logit_resid <- resid_india_processing(A42.india_state_subsector_logit_resid)
    A42.india_state_subsector_shrwt_resid <- resid_india_processing(A42.india_state_subsector_shrwt_resid)
    A42.india_state_globaltech_eff_resid <- resid_india_processing(A42.india_state_globaltech_eff_resid)
    A42.india_state_globaltech_cost_resid <- resid_india_processing(A42.india_state_globaltech_cost_resid)
    A42.india_state_globaltech_shrwt_resid <- resid_india_processing(A42.india_state_globaltech_shrwt_resid)
    A42.india_state_globaltech_interp_resid <- resid_india_processing(A42.india_state_globaltech_interp_resid)
    A42.india_state_fuelprefElasticity_resid <- resid_india_processing(A42.india_state_fuelprefElasticity_resid)
    A42.india_state_demand_resid <- resid_india_processing(A42.india_state_demand_resid)
    A42.india_state_calibrated_tech_resid <- resid_india_processing(A42.india_state_calibrated_tech_resid)
    A42.india_state_price_elasticity_resid <- resid_india_processing(A42.india_state_price_elasticity_resid)
    A42.india_state_income_elasticity_resid <- resid_india_processing(A42.india_state_income_elasticity_resid)



    # Shareweights of india resid sector technologies # OUTPUT
    L242.india_state_GlobalTechShrwt_resid <- A42.india_state_globaltech_shrwt_resid %>%
     # Expand table to include all model base and future years
      complete(year = c(year, MODEL_YEARS), nesting(supplysector, subsector, technology,region)) %>%
      # Extrapolate to fill out values for all years
      # Rule 2 is used so years that may be outside of min-max range are assigned values from closest data, as opposed to NAs
      group_by(supplysector, subsector, technology, region) %>%
      mutate(share.weight = approx_fun(year, value, rule = 2)) %>%
      ungroup() %>%
      filter(year %in% MODEL_YEARS) %>% # This will drop 1971
      select(region, sector.name = supplysector, subsector.name = subsector, technology, year, share.weight)


    # Technology shareweight interpolation of resid sector # OUTPUT
    L242.india_state_GlobalTechInterp_resid <- A42.india_state_globaltech_interp_resid %>%
      select(region, sector.name = supplysector, subsector.name = subsector, technology, apply.to, from.year, to.year, interpolation.function)

        # Energy inputs and coefficients of resid energy use technologies # OUTPUT
    DIGITS_EFFICIENCY = 3

    L242.india_state_GlobalTechEff_resid <- A42.india_state_globaltech_eff_resid %>%
      # Expand table to include all model base and future years
      complete(year = c(year, MODEL_YEARS), nesting(supplysector, subsector, technology, minicam.energy.input, region)) %>%
      # Extrapolate to fill out values for all years
      # Rule 2 is used so years that may be outside of min-max range are assigned values from closest data, as opposed to NAs
      group_by(supplysector, subsector, technology, minicam.energy.input, region) %>%
      mutate(efficiency = approx_fun(year, value, rule = 2)) %>%
      ungroup() %>%
      filter(year %in% MODEL_YEARS) %>% # This will drop 1971
      mutate(efficiency = round(efficiency, digits = DIGITS_EFFICIENCY)) %>%
      # Assign the columns "sector.name" and "subsector.name", consistent with the location info of a global technology
      select(region, sector.name = supplysector, subsector.name = subsector, technology, minicam.energy.input, year, efficiency)


    # Costs of resid technologies
    # Capital costs of resid technologies # OUTPUT
    DIGITS_COST <- 4

    #output
        L242.india_state_GlobalTechCost_resid <- A42.india_state_globaltech_cost_resid %>%
          # Expand table to include all model base and future years
          complete(year = c(year, MODEL_YEARS), nesting(supplysector, subsector, technology, minicam.non.energy.input, region)) %>%
          # Extrapolate to fill out values for all years
          # Rule 2 is used so years that may be outside of min-max range are assigned values from closest data, as opposed to NAs
          mutate(input.cost = approx_fun(year, value, rule = 2),
                 input.cost = round(input.cost, digits = DIGITS_COST)) %>%
          ungroup() %>%
          filter(year %in% MODEL_YEARS) %>% # This will drop 1971
          # Assign the columns "sector.name" and "subsector.name", consistent with the location info of a global technology
          select(region, sector.name = supplysector, subsector.name = subsector, technology, minicam.non.energy.input, year, input.cost)




    # OUTPUT
    L242.india_state_FuelPrefElast_resid <- A42.india_state_fuelprefElasticity_resid %>%
      mutate(year.fillout = min(MODEL_FUTURE_YEARS)) %>%
      select(region, supplysector, subsector, year.fillout, fuelprefElasticity)


    L242.india_state_Supplysector_resid <- A42.india_state_sector_resid %>%
      mutate(logit.year.fillout = min(MODEL_BASE_YEARS)) %>%
      select(region, supplysector, output.unit, input.unit, price.unit, logit.year.fillout, logit.exponent, logit.type)


    L242.india_state_FinalEnergyKeyword_resid <- L242.india_state_Supplysector_resid %>%
      mutate (final.energy = supplysector) %>%
    select(region, supplysector, final.energy)


    L242.india_state_SubsectorLogit_resid <- A42.india_state_subsector_logit_resid %>%
      mutate(year = min(MODEL_BASE_YEARS)) %>%
      select(region, supplysector, subsector, logit.year.fillout = year, logit.exponent, logit.type)


    L242.india_state_SubsectorShrwtFllt_resid <- A42.india_state_subsector_shrwt_resid %>%
      select(region, supplysector, subsector, year.fillout, share.weight)


    L242.india_state_SubsectorInterp_resid <- A42.india_state_subsector_interp_resid %>%
      select(region, supplysector, subsector, apply.to, from.year, to.year, interpolation.function)


    L242.india_state_StubTech_resid <- A42.india_state_globaltech_shrwt_resid %>%
      select(region, supplysector, subsector, stub.technology = technology) %>%
      unique()




    # Calibration and region-specific data
    # Calibrated input of resid technologies

    # get calibrated input of resid technologies

    L242.in_EJ_R_bld_F_Yh <- L142.india_state_in_EJ_resid_F %>%
      rename(region = state) %>%
      # Subset table for model base years
      filter(year %in% MODEL_BASE_YEARS) %>%
      left_join_error_no_match(A42.india_state_calibrated_tech_resid, by = c("region", "sector","fuel"))  %>%
    # Aggregate as indicated in the supplysector/subsector/technology mapping (dropping fuel)
      group_by(region, supplysector, subsector, stub.technology = technology, year) %>%
      summarise(value = sum(value)) %>%
      ungroup()


    DIGITS_CALOUTPUT <- 7
    # OUTPUT
    L242.india_state_StubTechCalInput_resid <- L242.in_EJ_R_bld_F_Yh %>%
      select(LEVEL2_DATA_NAMES[["StubTechYr"]], "value") %>%
      left_join_error_no_match(L242.india_state_GlobalTechEff_resid, by = c("region", "supplysector" = "sector.name", "subsector" = "subsector.name", "stub.technology" = "technology","year")) %>%
      mutate(value = round(value, digits = DIGITS_CALOUTPUT),
             share.weight.year = year) %>%
      group_by(region, supplysector, subsector, stub.technology, minicam.energy.input, share.weight.year, year) %>%
      summarise(calibrated.value = sum(value)) %>%
      ungroup() %>%
      mutate(subs.share.weight = if_else(calibrated.value > 0, 1, 0),
             tech.share.weight = if_else(calibrated.value > 0, 1, 0)) %>%
      select(LEVEL2_DATA_NAMES[["StubTechCalInput"]])


    # Base-year service output of resid final  demand
    # Base service is equal to the output of the resid supplysector
    # OUTPUT
    L242.india_state_BaseService_resid <- L242.india_state_StubTechCalInput_resid %>%
      left_join_error_no_match(L242.india_state_GlobalTechEff_resid, by = c("region", "supplysector" = "sector.name", "subsector" = "subsector.name",
                                                              "stub.technology" = "technology", "minicam.energy.input",
                                                              "share.weight.year" = "year")) %>%
      mutate(output = calibrated.value * efficiency) %>%
      group_by(region, supplysector, year) %>%
      summarise(output = sum(output)) %>%
      ungroup() %>%
      mutate(base.service = round(output, digits = DIGITS_CALOUTPUT)) %>%
      select(region, energy.final.demand = supplysector, year, base.service)


    # Expand price elasticity of resid final demand across all regions and future years.
    # Price elasticities are only applied to future periods. Application in base years will cause solution failure.
    # OUTPUT

    L242.india_state_PerCapitaBased_resid <- A42.india_state_demand_resid %>%
      select (region, energy.final.demand, perCapitaBased)

    L242.india_state_PriceElasticity_resid <- A42.india_state_price_elasticity_resid %>%
      select (region, energy.final.demand, year, price.elasticity = value)

    L242.india_state_IncomeElasticity_resid <- A42.india_state_income_elasticity_resid %>%
      select (region, energy.final.demand, year, income.elasticity = value)



    # Get markets for fuels consumed by the state resid sectors
    L242.india_state_StubTechMarket_resid  <- L242.india_state_StubTech_resid %>%
    repeat_add_columns(tibble(year = MODEL_YEARS)) %>%
      left_join_keep_first_only( L242.india_state_GlobalTechEff_resid %>%
                                   select(sector.name, subsector.name, technology, minicam.energy.input),
                                by = c( "supplysector" = "sector.name", "subsector" = "subsector.name", "stub.technology" = "technology")) %>%
      filter(is.na(minicam.energy.input) == FALSE) %>%
      # ^^ includes generic resid technology that is not required here...
      mutate(market.name = gcam.india_REGION) %>%
      select(LEVEL2_DATA_NAMES[["StubTechMarket"]]) %>%
      left_join_error_no_match(india_states_subregions %>% select(state, grid_region), by = c("region" = "state")) %>%
      mutate(market.name = if_else(minicam.energy.input %in% gcamindia.REGIONAL_FUEL_MARKETS,
                                   grid_region, market.name)) %>%
      select(-grid_region) %>%
      mutate(market.name = if_else(grepl("elect_td", minicam.energy.input), region, market.name)) %>%
      mutate(market.name = if_else(grepl("traditional biomass", minicam.energy.input), region, market.name))


    # ===================================================

    L242.india_state_DeleteSupplysector_bld %>%
      add_title(" delete india buildings supply sectors") %>%
      add_units("NA") %>%
      add_comments("Generated by deselecting buildings sectors from input") %>%
      add_legacy_name("L242.india_state_DeleteSupplysector_bld") %>%
      add_precursors("L242.Supplysector_bld") ->
      L242.india_state_DeleteSupplysector_bld

    L242.india_state_DeleteFinalDemand_bld %>%
      add_title("delete india final energy demand table for resid") %>%
      add_units("NA") %>%
      add_comments("Generated by deselecting final demand sectors") %>%
      add_legacy_name("L242.india_state_DeleteFinalDemand_bld") %>%
      add_precursors("L242.PerCapitaBased_bld") ->
      L242.india_state_DeleteFinalDemand_bld

    L242.india_state_Supplysector_resid %>%
      add_title("Supply sector information for building sector") %>%
      add_units("Unitless") %>%
      add_comments("Supply sector information for building sector was written for all regions") %>%
      add_legacy_name("L242.india_state_Supplysector_resid") %>%
      add_precursors("gcam-india/A42.india_state_sector_resid") ->
      L242.india_state_Supplysector_resid

    L242.india_state_FinalEnergyKeyword_resid %>%
      add_title("Supply sector keywords for building sector") %>%
      add_units("NA") %>%
      add_comments("Supply sector keywords for building sector was written for all regions") %>%
      add_legacy_name("L242.india_state_FinalEnergyKeyword_resid") %>%
      add_precursors("gcam-india/A42.india_state_sector_resid") ->
      L242.india_state_FinalEnergyKeyword_resid

    L242.india_state_SubsectorLogit_resid %>%
      add_title("Subsector logit exponents of building sector") %>%
      add_units("Unitless") %>%
      add_comments("Subsector logit exponents of building sector were written for all regions") %>%
      add_comments("Region/fuel combinations where heat and traditional biomass are not modeled as separate fuels were removed") %>%
      add_legacy_name("L242.india_state_SubsectorLogit_resid") %>%
      add_precursors("gcam-india/A42.india_state_subsector_logit_resid") ->
      L242.india_state_SubsectorLogit_resid

    L242.india_state_SubsectorShrwtFllt_resid %>%
        add_title("Subsector shareweights of building sector") %>%
        add_units("Unitless") %>%
        add_comments("Subsector shareweights of building sector were written for all regions") %>%
        add_comments("Region/fuel combinations where heat and traditional biomass are not modeled as separate fuels were removed") %>%
        add_legacy_name("L242.india_state_SubsectorShrwtFllt_resid") %>%
        add_precursors("gcam-india/A42.india_state_subsector_shrwt_resid") ->
      L242.india_state_SubsectorShrwtFllt_resid


    L242.india_state_SubsectorInterp_resid %>%
        add_title("Subsector shareweight interpolation data of building sector") %>%
        add_units("NA") %>%
        add_comments("Subsector shareweight interpolation data of building sector were written for all regions") %>%
        add_comments("Region/fuel combinations where heat and traditional biomass are not modeled as separate fuels were removed") %>%
        add_legacy_name("L242.india_state_SubsectorInterp_resid") %>%
        add_precursors("gcam-india/A42.india_state_subsector_interp_resid") ->
      L242.india_state_SubsectorInterp_resid


    L242.india_state_StubTech_resid %>%
      add_title("Identification of stub technologies of building sector") %>%
      add_units("NA") %>%
      add_comments("Identification of stub technologies of building sector were written for all regions") %>%
      add_comments("Region/fuel combinations where heat and traditional biomass are not modeled as separate fuels were removed") %>%
      add_legacy_name("L242.india_state_StubTech_resid") %>%
      add_precursors("gcam-india/A42.india_state_globaltech_shrwt_resid") ->
      L242.india_state_StubTech_resid

    L242.india_state_GlobalTechInterp_resid %>%
      add_title("Global technology shareweight interpolation of building sector") %>%
      add_units("NA") %>%
      add_comments("From/to years set to min/max of model years") %>%
      add_legacy_name("L242.india_state_GlobalTechInterp_resid") %>%
      add_precursors("gcam-india/A42.india_state_globaltech_interp_resid") ->
      L242.india_state_GlobalTechInterp_resid

    L242.india_state_GlobalTechShrwt_resid %>%
      add_title("Shareweights of global building sector technologies") %>%
      add_units("Unitless") %>%
      add_comments("Interpolated shareweight data across model years") %>%
      add_legacy_name("L242.india_state_GlobalTechShrwt_resid") %>%
      add_precursors("gcam-india/A42.india_state_globaltech_shrwt_resid") ->
      L242.india_state_GlobalTechShrwt_resid

    L242.india_state_GlobalTechEff_resid %>%
      add_title("Energy inputs and coefficients of global building energy use and feedstocks technologies") %>%
      add_units("Unitless") %>%
      add_comments("Interpolated data across model years") %>%
      add_legacy_name("L242.india_state_GlobalTechEff_resid") %>%
      add_precursors("gcam-india/A42.india_state_globaltech_eff_resid") ->
      L242.india_state_GlobalTechEff_resid

    L242.india_state_GlobalTechCost_resid %>%
      add_title("Capital costs of global building technologies") %>%
      add_units("Unitless") %>%
      add_comments("Interpolated data across model years") %>%
      add_legacy_name("L242.india_state_GlobalTechCost_resid") %>%
      add_precursors("gcam-india/A42.india_state_globaltech_cost_resid") ->
      L242.india_state_GlobalTechCost_resid

    L242.india_state_StubTechCalInput_resid %>%
      add_title("Calibrated input of building energy use technologies") %>%
      add_units("EJ") %>%
      add_comments("Data were aggregated (dropping fuel) and shareweights were determined from the calibrated value") %>%
      add_legacy_name("L242.india_state_StubTechCalInput_resid") %>%
      add_precursors("gcam-india/A42.india_state_calibrated_tech_resid",
                     "gcam-india/A42.india_state_globaltech_eff_resid", "L142.india_state_in_EJ_resid_F") ->
      L242.india_state_StubTechCalInput_resid


    L242.india_state_StubTechMarket_resid %>%
      add_title("Fuel preference elasticities of building energy use") %>%
      add_units("Unitless") %>%
      add_comments("Data were written for all regions") %>%
      add_comments("Region/fuel combinations where heat and traditional biomass are not modeled as separate fuels were removed") %>%
      add_legacy_name("L242.india_state_StubTechMarket_resid") %>%
      add_precursors("gcam-india/india_states_subregions", "gcam-india/A42.india_state_globaltech_shrwt_resid", "gcam-india/A42.india_state_globaltech_eff_resid") ->
      L242.india_state_StubTechMarket_resid

    L242.india_state_FuelPrefElast_resid %>%
      add_title("Fuel preference elasticities of building energy use") %>%
      add_units("Unitless") %>%
      add_comments("Data were written for all regions") %>%
      add_comments("Region/fuel combinations where heat and traditional biomass are not modeled as separate fuels were removed") %>%
      add_legacy_name("L242.india_state_FuelPrefElast_resid") %>%
      add_precursors("gcam-india/india_states_subregions", "gcam-india/A42.india_state_calibrated_tech_resid",
                     "gcam-india/A42.india_state_fuelprefElasticity_resid") ->
      L242.india_state_FuelPrefElast_resid

    L242.india_state_PerCapitaBased_resid %>%
      add_title("Per-capita based flag for building final demand") %>%
      add_units("Unitless") %>%
      add_comments("Data were written for all regions") %>%
      add_legacy_name("L242.india_state_PerCapitaBased_resid") %>%
      add_precursors("gcam-india/A42.india_state_demand_resid") ->
      L242.india_state_PerCapitaBased_resid

    L242.india_state_PriceElasticity_resid %>%
      add_title("Price elasticity of building final demand") %>%
      add_units("Unitless") %>%
      add_comments("Price elasticity data were written for all regions and only applied to future model years") %>%
      add_legacy_name("L242.india_state_PriceElasticity_resid") %>%
      add_precursors("gcam-india/A42.india_state_price_elasticity_resid") ->
      L242.india_state_PriceElasticity_resid

    L242.india_state_IncomeElasticity_resid %>%
      add_title("Income elasticity of building final demand") %>%
      add_units("Unitless") %>%
      add_comments("Income elasticity data were written for all regions and only applied to future model years") %>%
      add_legacy_name("L242.india_state_IncomeElasticity_resid") %>%
      add_precursors("gcam-india/A42.india_state_income_elasticity_resid") ->
      L242.india_state_IncomeElasticity_resid

    L242.india_state_BaseService_resid %>%
      add_title("Base-year service output of building final demand") %>%
      add_units("EJ") %>%
      add_comments("Base service is equal to the output of the building supplysector") %>%
      add_legacy_name("L242.india_state_BaseService_resid") %>%
      add_precursors("gcam-india/A42.india_state_calibrated_tech_resid",
                     "L142.india_state_in_EJ_resid_F", "gcam-india/A42.india_state_globaltech_eff_resid") ->
      L242.india_state_BaseService_resid

    return_data(L242.india_state_DeleteSupplysector_bld,
                L242.india_state_DeleteFinalDemand_bld,
                L242.india_state_Supplysector_resid,
                L242.india_state_FinalEnergyKeyword_resid,
                L242.india_state_SubsectorLogit_resid,
                L242.india_state_SubsectorShrwtFllt_resid,
                L242.india_state_SubsectorInterp_resid,
                L242.india_state_StubTech_resid,
                L242.india_state_GlobalTechInterp_resid,
                L242.india_state_GlobalTechShrwt_resid,
                L242.india_state_GlobalTechEff_resid,
                L242.india_state_GlobalTechCost_resid,
                L242.india_state_StubTechCalInput_resid,
                L242.india_state_StubTechMarket_resid,
                L242.india_state_FuelPrefElast_resid,
                L242.india_state_PerCapitaBased_resid,
                L242.india_state_PriceElasticity_resid,
                L242.india_state_IncomeElasticity_resid,
                L242.india_state_BaseService_resid)
  } else {
    stop("Unknown command")
  }
}
