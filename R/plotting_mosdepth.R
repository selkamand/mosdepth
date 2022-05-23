

#' Plot Cumulative Coverage Distribution
#'
#' @inheritParams mosdepth_tabulate_global_distributions
#' @param chromosomes_of_interest a subset of chromosomes to display. May include contain  'total' (character)
#'
#' @return ggplot object
#' @export
#'
#' @examples
#' mosdepth_dir = system.file("mosdepth_test_files",package="mosdepth")
#'
#' # Plot Cumulative Coverage
#' mosdepth_collect_output_files(prefix = "E_coli", mosdepth_dir) |>
#'   mosdepth_plot_cumulative_coverage_distribution()
mosdepth_plot_cumulative_coverage_distribution <- function(mosdepth_outputs, chromosomes_of_interest = NULL){
  mosdepth_global_coverage_distribution <- mosdepth_tabulate_global_distributions(mosdepth_outputs = mosdepth_outputs)

  gg = mosdepth_global_coverage_distribution |>
    ggplot2::ggplot(ggplot2::aes(x=Coverage, y = `Proportion of Genome Covered`, color=Chromosome)) +
    ggplot2::geom_point() +
    ggplot2::geom_line()  +
    ggplot2::ylab("Proportion of Chromosome Covered") +
    utilitybeltgg::theme_minimal_bordered() + utilitybeltgg::theme_legend_bottom()

  return(gg)
}

