
# shinylive::export(appdir = "./Shiny/ViewGames/", destdir = "og_docs")

shinylive::export(appdir = "./Shiny/ViewGamesShiny/",
                  destdir = "docs",
                  template_dir = "docs/CEGamesShinylifetemplate")


# httpuv::runStaticServer("docs/", port = 8008)
