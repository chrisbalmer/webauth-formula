webauth-git:
  pkg.installed:
    - name: git

webauth-repo:
  git.latest:
    - name: https://github.com/chrisbalmer/webauth.git
    - target: /usr/local/src/webauth/
    - require:
      - pkg: webauth-git

webauth-src-permissions:
  file.directory:
    - name: /usr/local/src/webauth/
    - user: root
    - group: root
    - recurse:
      - user
      - group
    - require:
      - git: webauth-repo

webauth-sbin-file:
  file.symlink:
    - name: /usr/local/sbin/webauth
    - target: /usr/local/src/webauth/webauth
    - user: root
    - group: root
    - mode: 444
    - force: true
    - require:
      - git: webauth-repo

webauth-dhcpcd-hook:
  file.symlink:
    - name: /lib/dhcpcd/dhcpcd-hooks/75-webauth
    - target: /usr/local/src/webauth/75-webauth
    - user: root
    - group: root
    - mode: 644
    - require:
      - git: webauth-repo

webauth-etc-file:
  file.managed:
    - name: /etc/webauth/webauth.json
    - source: salt://webauth/webauth.json
    - makedirs: true
    - mode: 600
    - user: root
    - group: root