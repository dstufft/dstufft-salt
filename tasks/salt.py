from __future__ import absolute_import, division, print_function

import invoke
import fabric.api
import fabric.contrib.files

from .utils import ssh_host


def sync_changes(host):
    # Push our changes to GitHub
    invoke.run("git push origin master", echo=True)

    # SSH into the salt master and pull our changes
    with ssh_host(host):
        with fabric.api.cd("/srv/dstufft-salt"):
            fabric.api.sudo("git pull --ff-only origin master")


@invoke.task(default=True)
def highstate(hosts):
    # Until invoke supports *args we need to hack around the lack of support
    # for now.
    hosts = [h.strip() for h in hosts.split(",") if h.strip()]

    # Ensure we have some hosts
    if not hosts:
        raise ValueError("Must specify hosts for highstate")

    # Loop over all the hosts and if they do not have a ., then we'll add
    # .psf.io to them.
    hosts = [h if "." in h else h + ".caremad.io" for h in hosts]

    # Loop over all the hosts and call salt-call state.highstate on them.
    for host in hosts:
        # Sync our changes
        sync_changes(host)

        # Run salt
        with ssh_host(host):
            fabric.api.sudo("salt-call state.highstate")
