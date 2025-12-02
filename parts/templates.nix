{
  inputs,
  self,
  ...
}: {
  flake = {
    templates = {
      hugo = {
        path = ../.;
        description = "A basic flake template for Hugo";
      };
    };
  };
}
