# Plot the results
df <- readr::read_csv(
  "worker_stats.csv"
) |>
  dplyr::filter(
    !stringr::str_detect(cmd, "bash|sshd|ssh-agent|timeout")
  ) |>
  ggplot2::ggplot(ggplot2::aes(x = time, y = rss, color = name)) +
  ggplot2::geom_line()