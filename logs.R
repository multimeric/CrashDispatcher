LOG_FILENAME <- "worker_stats.csv"
my_pid <- ps::ps_pid()
col_names <- TRUE

# Kill this command when the targets pipeline dies
repeat {
  ps::ps(
    user = ps::ps_username()
  ) |> dplyr::mutate(
    cmd = name,
    username = NULL,
    cmdline = purrr::map_chr(ps_handle, function(handle) {
      handle |> ps::ps_cmdline() |> stringr::str_flatten(collapse = " ") |> tryCatch(
        error = function(e) "<ERROR>"
      )
    }),
    time = Sys.time(),
    ps_handle = NULL,
    type = dplyr::case_when(
      stringr::str_detect(cmdline, "mirai::dispatcher") ~ "dispatcher",
      stringr::str_detect(cmdline, "callr-scr") ~ "callr",
      stringr::str_detect(cmdline, "crew::crew_worker") ~ "crew_worker",
      pid == my_pid ~ "monitor",
      .default = name
    ),
    name = stringr::str_c(type, pid, sep="-")
  ) |>
    readr::write_csv(file = LOG_FILENAME, append=TRUE, col_names = col_names)
    col_names <- FALSE
}
