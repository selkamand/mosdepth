#' Mosdepth
#'
#' simple R wrapper for mosdepth
#'
#' @param threads number of BAM decompression threads. (use 4 or fewer). default: 0.  (string)
#' @param flag exclude reads with any of the bits in FLAG set. default: 1796 (string)
#' @param fastmode dont look at internal cigar operations or correct mate overlaps (recommended for most use-cases). (string)
#' @param mapping_quality_threshold mapping quality threshold. reads with a mapping quality less than this are ignored. default: 0 (string)
#' @param d4 output per-base depth in d4 format. This is much faster. (boolean)
#' @param prefix prefix for output files (string)
#' @param bam the alignment file for which to calculate depth (string)
mosdepth_run <- function(prefix, bam, threads=NULL, flag=NULL, fastmode=NULL, mapping_quality_threshold=NULL, d4=FALSE)
{
  utilitybeltassertions::assert_program_exists_in_path(program_names = "mosdepth")
  utilitybeltassertions::assert_files_exist(bam)
  assertthat::assert_that(assertthat::is.flag(d4))

  raw_command <- 'mosdepth <--threads;threads> <--flag;flag> <--fast-mode;fastmode> <--mapq;mapping_quality_threshold> <d4;--d4> <prefix> <bam>'

  if(!is.null(threads)) raw_command <- sub(raw_command, pattern = "<--threads;threads>", replacement = paste("--threads",threads))
  if(!is.null(flag)) raw_command <- sub(raw_command, pattern = "<--flag;flag>", replacement = paste("--flag",flag))
  if(!is.null(fastmode)) raw_command <- sub(raw_command, pattern = "<--fast-mode;fastmode>", replacement = paste("--fast-mode",fastmode))
  if(!is.null(mapping_quality_threshold)) raw_command <- sub(raw_command, pattern = "<--mapq;mapping_quality_threshold>", replacement = paste("--mapq",mapping_quality_threshold))
  if(d4) raw_command <- sub(raw_command, pattern = "<d4;(.*?)>", replacement = "\\1")
  if(!is.null(prefix)) raw_command <- sub(raw_command, pattern = "<prefix>", replacement = prefix)
  if(!is.null(bam)) raw_command <- sub(raw_command, pattern = "<bam>", replacement = bam)
  raw_command = gsub(pattern = "<.*?> ?", replacement = "", x = raw_command, perl=TRUE)

  message("Running command: ", raw_command)

  exit_code = system(raw_command)

  assertthat::assert_that(exit_code == 0, msg = paste0("Failed to run tool. Exit code [",exit_code,"]"))

  mosdepth_collect_output_files(prefix)
}


