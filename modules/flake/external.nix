{
  ff = {
    neovim = {
      url = "path:/home/wyspr/Configuration/Neovim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rabid = {
      url = "path:/home/wyspr/Configuration/Rabid";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gimp.url = "path:/home/wyspr/Configuration/GIMP";
  };
}
