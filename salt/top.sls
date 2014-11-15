base:
  '*':
    - base.repo
    - base.sanity
    - users
    - sudoers
    - ssh
    - unattended-upgrades
    - firewall

  'shitbird.caremad.io':
    - blog
