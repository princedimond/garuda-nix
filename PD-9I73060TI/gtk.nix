{pkgs, ...}: {
  gtk = {
    iconTheme = {
      name = "Candy";
      package = pkgs.candy-icons;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
}
