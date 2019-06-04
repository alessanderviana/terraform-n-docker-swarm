America/Sao_Paulo:
  timezone.system

br_locale:
  locale.present:
    - name: pt_BR.UTF-8

default_locale:
  locale.system:
    - name: pt_BR.UTF-8
    - require:
      - locale: br_locale

salt-minion:
  service.dead:
    - enable: False
    - reload: False
