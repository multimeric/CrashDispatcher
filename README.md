To reproduce:
* Clone this repo
* Run `targets::tar_make()`
* Run `logs.R` in the background, either with `Rscript` or using an RStudio background job
* When targets crashes due to OOM, or because you kill it, also stop the background job
* Run `plot.R` to get the plot