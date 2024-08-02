LOG_FILENAME <- "worker_stats_2.csv"
my_pid <- ps::ps_pid()
col_names <- TRUE
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
      stringr::str_detect(cmdline, "dispatcher") ~ "dispatcher",
      stringr::str_detect(cmdline, "callr-scr") ~ "callr",
      pid == my_pid ~ "monitor",
      .default = name
    ),
    name = stringr::str_c(type, pid, sep="-")
  ) |>
    readr::write_csv(file = LOG_FILENAME, append=TRUE, col_names = col_names)
    col_names <- FALSE
}

df <- readr::read_csv(
  LOG_FILENAME
)

df |>
  dplyr::filter(
    !stringr::str_detect(cmd, "bash|sshd|ssh-agent|timeout")
  ) |>
  ggplot2::ggplot(ggplot2::aes(x = time, y = rss, color = name)) +
  ggplot2::geom_line()
