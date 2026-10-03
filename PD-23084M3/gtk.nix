{pkgs, ...}: {
  gtk = {
    iconTheme = {
      name = "Catppuccin-Papirus";
      package = pkgs.catppuccin-papirus-folders;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
