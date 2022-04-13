## -----------------------------------------------------------------------------
##
## Purpose of script: Helper functions
##
## Author: Ashirwad Barnwal
##
## Date Created: 2022-04-12
##
## Copyright (c) Ashirwad Barnwal, 2022
## Email: ashirwad@iastate.edu; ashirwad1992@gmail.com
##
## -----------------------------------------------------------------------------
##
## Notes: This script contains helper functions to help simplify data
## manipulation & visualization operations.
##
## -----------------------------------------------------------------------------


# Create variable importance plots ---------------------------------------------
plot_vip <- function(..., top_n = 10) {
  # prepare data for plotting
  obj <- list(...)
  vip_rbind <- dplyr::bind_rows(obj)

  loss_min <- vip_rbind %>%
    dplyr::filter(variable == "_full_model_", permutation == 0) %>%
    dplyr::select(y_min = dropout_loss, label)

  vip_plot_df <- vip_rbind %>%
    dplyr::filter(
      !variable %in% c("_full_model_", "_baseline_"), permutation == 0
    ) %>%
    dplyr::with_groups(label, ~ slice_max(.x, dropout_loss, n = top_n)) %>%
    dplyr::left_join(loss_min, by = "label")

  vip_plot_df %>%
    ggplot2::ggplot(
      aes(
        x = tidytext::reorder_within(variable, dropout_loss, label),
        y = dropout_loss,
        color = label
      )
    ) +
    ggplot2::geom_linerange(
      aes(ymin = y_min, ymax = dropout_loss), size = 8, alpha = 0.8
    ) +
    ggplot2::geom_boxplot(
      data = semi_join(vip_rbind, vip_plot_df, by = c("variable", "label")),
      width = 0.2,
      color = "black"
    ) +
    ggplot2::facet_wrap(vars(label), scales = "free") +
    ggplot2::coord_flip() +
    ggplot2::labs(y = "One minus AUC loss after permutations", x = NULL) +
    tidytext::scale_x_reordered() +
    ggplot2::scale_color_manual(values = DALEX::colors_discrete_drwhy(3)) +
    ggpubr::theme_pubclean() +
    ggplot2::theme(legend.position = "none")
}

# Create partial dependence profiles --------------------------------------
plot_pdp <- function(...) {
  obj <- list(...)
  df <- purrr::map_dfr(obj, ~ pluck(.x, "agr_profiles")) %>% as_tibble()

  df %>%
    ggplot2::ggplot(aes(x = `_x_`, y = `_yhat_`, color = `_label_`)) +
    ggplot2::geom_line(size = 1.2, alpha = 0.8) +
    ggplot2::facet_wrap(vars(`_vname_`), scales = "free") +
    ggplot2::scale_color_manual(values = DALEX::colors_discrete_drwhy(3)) +
    ggplot2::labs(x = NULL, y = "Average prediction", color = "Model") +
    ggpubr::theme_pubclean()
}
