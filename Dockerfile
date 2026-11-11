FROM linuxserver/firefox:1160.0build1-1xtradeb1.2404.1-ls136

# Upstream starts Xvfb with a 15360x8640 screen, which pins ~600 MB for the
# framebuffer alone and OOM-kills the desktop on Railway's 512 MB Trial plan.
# 4K is plenty; Selkies still resizes the desktop to the browser window.
ENV MAX_RES=3840x2160

# Everything starting at once can get Firefox OOM-killed during boot on a 1 GB plan, leaving an
# empty desktop while Railway says SUCCESS and /healthcheck says 200. A second start fits, so
# let the base image's watchdog bring it back.
ENV RESTART_APP=true

# ponytail: one custom-init script adds an unauthenticated /healthcheck
# location for Railway's healthcheck prober; everything else is stock.
COPY root/ /
RUN chmod +x /railway-gate.sh /custom-cont-init.d/20-healthcheck /custom-services.d/drop-file-cache /usr/local/bin/drop-file-cache

# Free plan (0.5 GB): serve a "needs 1 GB" page instead of starting the desktop (see railway-gate.sh).
ENTRYPOINT ["/railway-gate.sh"]
