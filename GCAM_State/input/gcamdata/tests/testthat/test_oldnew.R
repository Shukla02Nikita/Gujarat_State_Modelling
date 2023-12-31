# Test that chunk outputs match original data system

context("oldnew")

library(readr)

test_that("matches old data system output", {
  # If we are running the code coverage tests then let's skip this since
  # it will take a long to time run and the purpose of this test is to
  # make sure the chunk outputs match the old data system and not to test
  # the functionality of any chunks
  if(isTRUE(as.logical(Sys.getenv("gcamdata.is_coverage_test")))) {
    skip("Skip old new when only interested in code coverage")
  }

  # If we're on Travis, need to run the driver to ensure chunk outputs saved
  # Don't do this locally, to speed things up

  # Look for output data in OUTPUTS_DIR under top level
  # (as this code will be run in tests/testthat)
  outputs_dir <- normalizePath(file.path("../..", OUTPUTS_DIR))
  xml_dir <- normalizePath(file.path("../..", XML_DIR))

  if(identical(Sys.getenv("TRAVIS"), "true")) {
    # Run the driver and save chunk outputs
    # Note we are not going to bother writing the XML since travis will not have
    # any gcamdata.xml_cmpdir to do the OLD/NEW on the XML files anyways.
    gcam_data_map <- driver(write_outputs = TRUE, write_xml = FALSE, quiet = TRUE, outdir = outputs_dir, xmldir = xml_dir, return_data_map_only = TRUE)

    # The following two tests are only run on Travis because they will fail
    # during the R CMD CHECK process locally (as the R build process removes outputs/)
    expect_equivalent(file.access(outputs_dir, mode = 4), 0,  # outputs_dir exists and is readable
                      info = paste("Directory", outputs_dir, "unreadable or does not exist from", getwd()))
    expect_true(file.info(outputs_dir)$isdir)

    # Now we compare the data map returned above with the pre-packaged version
    # They should match! See https://github.com/JGCRI/gcamdata/pull/751#issuecomment-331578990
    # First put what the driver returns and the internal GCAM_DATA_MAP into the same order (can vary if run on PIC for example)
    gcam_data_map <- arrange(gcam_data_map, name, output)
    gdm_internal <- arrange(gcamdata:::GCAM_DATA_MAP, name, output)

    # The gcam_data_map that's generated on Travis won't have the proprietary IEA data, so its comments
    # and units may differ
    expect_true(tibble::is_tibble(gdm_internal))
    expect_true(tibble::is_tibble(gcam_data_map))
    expect_identical(dim(gdm_internal), dim(gcam_data_map), info =
                       "GCAM_DATA_MAP dimensions don't match. Rerun generate_package_data to update.")
    expect_identical(gdm_internal$name, gcam_data_map$name, info =
                       "GCAM_DATA_MAP name doesn't match. Rerun generate_package_data to update.")
    expect_identical(gdm_internal$output, gcam_data_map$output, info = "GCAM_DATA_MAP output doesn't match")
    expect_identical(gdm_internal$precursors, gcam_data_map$precursors, info =
                       "GCAM_DATA_MAP precursors doesn't match. Rerun generate_package_data to update.")
  }

  # Get a list of files in OUTPUTS_DIR for which we will make OLD/NEW comparisons
  new_files <- list.files(outputs_dir, full.names = TRUE)

  if(length(new_files) == 0) {
    # There was no "NEW" outputs in the OUTPUTS_DIR to make comparisons
    # so we will skip this test
    skip("no output data found for comparison")
  } else if(!require("gcamdata.compdata", quietly = TRUE)) {
    # We couldn't get the "OLD" outputs from the gcamdata.compdata repo
    # so we will skip this test
    skip("gcamdata.compdata package not available")
  } else {
    # load the comparison data which is coming from the gcamdata.compdata package
    # the format is a list[[data name ]] = data tibble
    data(COMPDATA)

    # For each file in OUTPUTS_DIR, look for corresponding file in our
    # comparison data. Load them, reshape new data if necessary, compare.
    for(newf in list.files(outputs_dir, full.names = TRUE)) {
      # In this rewrite, we're not putting X's in front of years,
      # nor are we going to spend time unnecessarily reshaping datasets
      # (i.e. wide to long and back). But we still need to be able to
      # verify old versus new datasets! Chunks tag the data if it's
      # reshaped, and save_chunkdata puts flag(s) at top of the file.
      new_firstline <- readLines(newf, n = 1)

      if(grepl(FLAG_NO_TEST, new_firstline)) {
        next
      }

      flag_sum_test <- grepl(FLAG_SUM_TEST, new_firstline)

      newdata <- read_csv(newf, comment = COMMENT_CHAR)
      oldf <- sub('.csv$', '', basename(newf))
      olddata <- COMPDATA[[oldf]]
      expect_is(olddata, "data.frame", info = paste("No comparison data found for", oldf))

      # Finally, test (NB rounding numeric columns to a sensible number of
      # digits; otherwise spurious mismatches occur)
      # Also first converts integer columns to numeric (otherwise test will
      # fail when comparing <int> and <dbl> columns)
      DIGITS <- 3
      round_df <- function(x, digits = DIGITS) {
        integer_columns <- sapply(x, class) == "integer"
        x[integer_columns] <- lapply(x[integer_columns], as.numeric)

        numeric_columns <- sapply(x, class) == "numeric"
        x[numeric_columns] <- round(x[numeric_columns], digits)
        x
      }

      expect_identical(dim(olddata), dim(newdata), info = paste("Dimensions are not the same for", basename(newf)))

      # Some datasets throw errors when tested via `expect_equivalent` because of
      # rounding issues, even when we verify that they're identical to three s.d.
      # I think this is because of differences between readr::write_csv and write.csv
      # To work around this, we allow chunks to tag datasets with FLAG_SUM_TEST,
      # which is less strict, just comparing the sum of all numeric data
      if(flag_sum_test) {
        numeric_columns_old <- sapply(olddata, is.numeric)
        numeric_columns_new <- sapply(newdata, is.numeric)
        expect_equivalent(sum(olddata[numeric_columns_old]), sum(newdata[numeric_columns_new]),
                          info = paste(basename(newf), "doesn't match (sum test)"))
      } else {
        expect_equivalent(round_df(olddata), round_df(newdata), info = paste(basename(newf), "doesn't match"))
      }
    }
    # Explicitly clean up COMPDATA as it uses a lot of memory and gets loaded into the
    # Global environment
    rm(COMPDATA, envir = .GlobalEnv)
    gc()
  }
})


test_that('New XML outputs match old XML outputs', {
  ## The XML comparison data is huge, so we don't want to try to include it in
  ## the package.  Instead, we look for an option that indicates where the data
  ## can be found.  If the option isn't set, then we skip this test.
  xml_cmp_dir <- getOption('gcamdata.xml_cmpdir')
  if(is.null(xml_cmp_dir)) {
    skip("XML comparison data not provided. Set option 'gcamdata.xml_cmpdir' to run this test.")
  }
  else {
    xml_cmp_dir <- normalizePath(xml_cmp_dir)
  }
  expect_true(file.exists(xml_cmp_dir))

  xml_dir <- normalizePath(file.path("../..", XML_DIR))
  expect_true(file.exists(xml_dir))

  for(newxml in list.files(xml_dir, full.names = TRUE)) {
    oldxml <- list.files(xml_cmp_dir, pattern = paste0('^',basename(newxml),'$'), recursive = TRUE,
                         full.names = TRUE)
    if(length(oldxml) > 0) {
      expect_equal(length(oldxml), 1,
                   info = paste('Testing file', newxml, ': Found', length(oldxml),
                                'comparison files.  There can be only one.'))
      ## If we come back with multiple matching files, we'll try to run the test anyhow, selecting
      ## the first one as the true comparison.
      expect_true(cmp_xml_files(oldxml[1], newxml),
                  info = paste('Sorry to be the one to tell you, but new XML file',
                               newxml, "is not equivalent to its old version."))
    }
    else {
      ## If no comparison file found, issue a message, but don't fail the test.
      message('No comparison file found for ', newxml, '. Skipping.')
    }
  }
})
