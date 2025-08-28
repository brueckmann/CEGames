
shinylive::export(appdir = "./Shiny/ViewGames/", destdir = "og_docs")

shinylive::export(appdir = "./Shiny/ViewGamesShiny/", destdir = "docs")


httpuv::runStaticServer("docs/", port = 8008)
