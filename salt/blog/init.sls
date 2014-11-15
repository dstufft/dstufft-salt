include:
  - nginx


/srv/blog:
  file.directory:
    - user: www-data
    - group: www-data


/etc/nginx/sites.d/blog.conf:
  file.managed:
    - source: salt://blog/config/nginx.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
        - sls: nginx
        - file: /srv/blog
