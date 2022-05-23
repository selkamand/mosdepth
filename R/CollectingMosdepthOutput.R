MosdepthOutputFiles <- methods::setClass(
  Class = "MosdepthOutputFiles",
  slots = c(
    summary = "character",
    global_distributions = "character",
    per_base_bed = "character",
    per_base_d4 = "character",
    regions_bed = "character",
    region_distributions = "character",
    quantized_bed = "character",
    thresholds_bed = "character"
  )
)

#' Collect mosdepth files
#'
#' Creates an object that keeps track of the location of the mosdepth files
#'
#' @param prefix prefix supplied in original mosdepth call (string)
#' @param directory_path directory containing the mosdepth files (string)
#'
#' @return an s4 object of class 'MosdepthOutputFiles'. This can be fed into many other functions to analyse/visualise the results
#' @export
#'
#' @examples
#' mosdepth_dir = system.file("mosdepth_test_files", package="mosdepth")
#'
#' mosdepth_collect_output_files(
#'   prefix="E_coli",
#'   directory_path = mosdepth_dir
#' )
#'
#'
mosdepth_collect_output_files <- function(prefix, directory_path = "."){
  directory_path = normalizePath(directory_path)

  assertthat::assert_that(dir.exists(directory_path), msg = utilitybeltassertions::fmterror("Could not find directory: [", directory_path, "]"))

  MosdepthOutputFiles(
    summary = paste0(directory_path, "/", prefix, ".mosdepth.summary.txt"),
    global_distributions = paste0(directory_path, "/", prefix, ".mosdepth.global.dist.txt"),
    per_base_bed = paste0(directory_path, "/", prefix, ".per-base.bed.gz"),
    per_base_d4 = paste0(directory_path, "/", prefix, ".per-base.d4"),
    regions_bed = paste0(directory_path, "/", prefix, ".regions.bed.gz"),
    region_distributions = paste0(directory_path, "/", prefix, ".mosdepth.region.dist.txt"),
    quantized_bed = paste0(directory_path, "/", prefix, ".quantized.bed.gz"),
    thresholds_bed = paste0(directory_path, "/", prefix, ".thresholds.bed.gz")
  )
}

setMethod(
  f = "show",
  signature = "MosdepthOutputFiles",
  definition = function(object){
    slot_names = slotNames(object)
    slot_values = vapply(
      X =slot_names,
      FUN = function(slotname) {
        slot(object,slotname)
      },
      FUN.VALUE = "character"
    )

    files_exist = file.exists(slot_values)

    paste0(slot_names, " ", ifelse(files_exist, yes = utilitybeltassertions::fmtsuccess("\u2714"), no = utilitybeltassertions::fmterror("\u2716")), "\n") |> message()
  }
)

#' Retrive Mosdepth File
#'
#' @param mosdepth_outputs result of running [mosdepth_collect_output_files()]
#' @param filetype type of file to retrieve (string)
#'
#' @return path to chosen filetype (string)
mosdepth_retrieve_file <- function(mosdepth_outputs,
                                   filetype = c(
                                     "summary",
                                     "global_distributions",
                                     "per_base_bed",
                                     "per_base_d4",
                                     "regions_bed",
                                     "region_distributions",
                                     "quantized_bed",
                                     "thresholds_bed"
                                   )
){
  assertthat::assert_that(class(mosdepth_outputs) == "MosdepthOutputFiles")
  filetype=rlang::arg_match(filetype)
  filepath=slot(mosdepth_outputs, filetype)

  utilitybeltassertions::assert_files_exist(filepath)
  return(filepath)
}

#' Mosdepth Result Summary
#'
#' @param mosdepth_outputs result of running [mosdepth_collect_output_files()]
#'
#' @return table summarising mosdepth outputs
#' @export
#'
mosdepth_tabulate_summary <- function(mosdepth_outputs){
  assertthat::assert_that(class(mosdepth_outputs) == "MosdepthOutputFiles")

  mosdepth_retrieve_file(mosdepth_outputs, "summary") |>
    utils::read.csv(header = TRUE, sep = "\t")

}

#' Mosdepth Results
#'
#' @param mosdepth_outputs result of running [mosdepth_collect_output_files()]
#'
#' @return table describing per-base depth
#' @export
#'
mosdepth_tabulate_per_base_depth <- function(mosdepth_outputs){
  assertthat::assert_that(class(mosdepth_outputs) == "MosdepthOutputFiles")

  mosdepth_retrieve_file(mosdepth_outputs, "per_base_bed") |>
    utils::read.csv(header = FALSE, sep = "\t")
}




#' Mosdepth Results
#'
#' @param mosdepth_outputs result of running [mosdepth_collect_output_files()]
#'
#' @return table describing global distributions (what % of genome is covered by at least coverage > X)
#' @export
#'
mosdepth_tabulate_global_distributions <- function(mosdepth_outputs){
  assertthat::assert_that(class(mosdepth_outputs) == "MosdepthOutputFiles")

  retrieved_df = mosdepth_retrieve_file(mosdepth_outputs, "global_distributions") |>
    utils::read.csv(header = FALSE, sep = "\t", col.names = c("Chromosome", "Coverage", "Proportion of Genome Covered"), check.names = FALSE) |>
    dplyr::tibble()

  assertthat::assert_that(nrow(retrieved_df) > 0, msg = utilitybeltassertions::fmterror("Global distributions file has no lines. Terminating"))
  return(retrieved_df)
}
