
#' Calculate proportion of genome covered at given depth
#'
#' @inheritParams mosdepth_tabulate_global_distributions
#' @param depth_threshold  depth threshold
#' @param chr limit analysis to specific chromosome. The default of 'total' will calculated  \strong{'proportion of all bases covered at depth' >= depth_threshold} across all chromosomes in the file
#'
#' @return 'proportion of all bases covered at depth' >= depth_threshold (numeric)
#' @export
#'
#' @examples
#' mosdepth_dir = system.file("mosdepth_test_files",package="mosdepth")
#'
#' mosdepth_collect_output_files(prefix = "E_coli", mosdepth_dir) |>
#'   mosdepth_calculate_proportion_of_genome_with_depth_over_threshold(depth_threshold = 100)
mosdepth_calculate_proportion_of_genome_with_depth_over_threshold <- function(mosdepth_outputs, depth_threshold = 10, chr = "total"){
  global_dist_df <- mosdepth_tabulate_global_distributions(mosdepth_outputs = mosdepth_outputs)
  global_dist_chrom_subset_df = dplyr::filter(global_dist_df, Chromosome == chr)
  assertthat::assert_that(nrow(global_dist_chrom_subset_df) > 0, msg = utilitybeltassertions::fmterror("No entries in global distributions file where chromosome name == ", chr, "\nPlease make sure you choose a valid chromosome name"))

  tabular_results = dplyr::filter(global_dist_chrom_subset_df, Coverage >= depth_threshold) |>
    dplyr::slice_min(order_by = Coverage, with_ties = FALSE)

  if(nrow(tabular_results) == 0 ){
    message("0% of chromosome [", chr,  "] is covered with depth >= ", depth_threshold)
    return(0)
  }

  proportion_of_genome_covered = tabular_results[['Proportion of Genome Covered']]
  coverage_threshold = tabular_results[['Coverage']]

  message(proportion_of_genome_covered*100, '% of the chr: [', chr, '] is covered at depth >= ', coverage_threshold, 'X')
  return(proportion_of_genome_covered)
}
