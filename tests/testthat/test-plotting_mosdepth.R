test_that("plotting_cumulative_distributions works", {
  mosdepth_dir = system.file("mosdepth_test_files",package="mosdepth")

  plot = mosdepth_collect_output_files(prefix = "E_coli", mosdepth_dir) |>
    mosdepth_plot_cumulative_coverage_distribution()

  expect_s3_class(plot, class = "ggplot")

})
