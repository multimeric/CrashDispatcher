targets::tar_option_set(
  controller = crew::crew_controller_local(),
  storage = "worker",
  retrieval = "worker"
)

list(
  targets::tar_target(
    x, 
    list(
      # 7.5 GB
      numeric(1E9)
    ),
    iteration = "list"
  ),
  targets::tar_target(
    y,
    list(1),
    iteration = "list"
  ),
  targets::tar_target(
    z,
    {
      dir_path <- tempfile()
      dir.create(dir_path)
      
      file_path <- file.path(dir_path, "foo.rds")
      saveRDS(x, file_path)
      
      dir_path
    },
    format = "file",
    pattern = cross(x, y)
  )
)