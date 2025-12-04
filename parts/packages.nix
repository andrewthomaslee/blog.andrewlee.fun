{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    packages = let
      hugo-package = pkgs.stdenv.mkDerivation {
        name = "hugo-package";
        src = ../.;
        nativeBuildInputs = with pkgs; [hugo];
        installPhase = ''
          mkdir -p tmp
          cp -r $src/hugo/* tmp/
          mkdir -p $out/var/www
          hugo -s tmp --destination $out/var/www --minify
        '';
      };
      nginxPort = 8080;
      nginxConf = pkgs.writeText "nginx.conf" ''
        user nobody nobody;
        daemon off;
        error_log /dev/stderr;
        pid /dev/null;

        events {
          worker_connections 1024;
        }

        http {
          access_log /dev/stdout;
          include ${pkgs.nginx}/conf/mime.types;

          gzip on;
          gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
          gzip_min_length 1000;

          open_file_cache max=1000 inactive=600s;
          open_file_cache_valid 60m;
          open_file_cache_errors on;

          server {
            listen ${toString nginxPort};
            root ${hugo-package}/var/www;

            error_page 404 /404.html;

            location ~* \.(css|js|png|jpg|svg|ico|woff2)$ {
              expires 1y;
              add_header Cache-Control "public, max-age=31536000, immutable";
              access_log off;
            }

            location / {
              try_files $uri $uri/ =404;
              expires 1h;
              add_header Cache-Control "public, max-age=3600";
            }
          }
        }
      '';
      containerConfig = {
        name = "hugo-container";
        created = "now";
        contents = with pkgs; [
          nginx
          fakeNss
        ];
        extraCommands = ''
          mkdir -p tmp/nginx_client_body
          mkdir -p var/log/nginx
          mkdir -p var/cache/nginx
        '';
        config = {
          Cmd = ["nginx" "-c" nginxConf];
          ExposedPorts = {"${toString nginxPort}/tcp" = {};};
        };
      };
    in {
      default = hugo-package;
      hugo-container = pkgs.dockerTools.buildLayeredImage containerConfig;
      hugo-container-stream = pkgs.dockerTools.streamLayeredImage containerConfig;
    };
  };
}
