ssh:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/ssh/sshd_config


/etc/ssh/sshd_config:
  file.managed:
    - source: salt://ssh/configs/sshd_config
    - user: root
    - group: root
    - mode: 644
