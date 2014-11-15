{% for user_name, user_config in salt["pillar.get"]("users", {}).iteritems() %}

{{ user_name }}-user:
  user.present:
    - name: {{ user_name }}
    - fullname: {{ user_config["fullname"] }}
    - home: /home/{{ user_name }}
    - createhome: True
    - shell: {{ user_config.get("shell", "/bin/bash") }}


{{ user_name }}-ssh_dir:
  file.directory:
    - name: /home/{{ user_name }}/.ssh
    - user: {{ user_name }}
    - mode: 700
    - require:
      - user: {{ user_name }}

{{ user_name }}-ssh_key:
  file.managed:
    - name: /home/{{ user_name }}/.ssh/authorized_keys
    - user: {{ user_name }}
    - mode: 600
    - source: salt://users/config/authorized_keys.jinja
    - template: jinja
    - context:
      ssh_keys: {{ user_config["ssh_keys"] }}
    - require:
      - user: {{ user_name }}

{% endfor %}
