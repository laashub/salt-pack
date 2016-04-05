{% set os_codename = 'xenial' %}
{% set prefs_text = 'Package: *
        Pin: release a=' ~ os_codename ~ '-backports
        Pin-Priority: 750
        Package: *
        Pin: release a=' ~ os_codename ~ '-security
        Pin-Priority: 740
        Package: *
        Pin: release a=' ~ os_codename ~ '-updates
        Pin-Priority: 730
        Package: *
        Pin: release a=main
        Pin-Priority: 700
        Package: *
        Pin: release a=restricted
        Pin-Priority: 650
        Package: *
        Pin: release a=universe
        Pin-Priority: 600
        Package: *
        Pin: release a=multiverse
        Pin-Priority: 550
' %}


include:
  - setup.ubuntu


build_pbldhooks_rm:
  file.absent:
    - name: /root/.pbuilder-hooks/G05apt-preferences


build_pbldrc_rm:
  file.absent:
    - name: /root/.pbuilderrc


build_prefs_rm:
  file.absent:
    - name: /etc/apt/preferences


build_pbldhooks_file:
  file.append:
    - name: /root/.pbuilder-hooks/G05apt-preferences
    - text: |
        #!/bin/sh
        set -e
        cat > "/etc/apt/preferences" << EOF
        {{prefs_text}}
        EOF
    

build_pbldhooks_perms:
  file.directory:
    - name: /root/.pbuilder-hooks/
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755
    - recurse:
        - user
        - group
        - mode


build_pbldrc:
  file.append:
    - name: /root/.pbuilderrc
    - text: |
        DIST="{{os_codename}}"
        if [ -n "${DIST}" ]; then
          TMPDIR=/tmp
          BASETGZ="`dirname $BASETGZ`/${DIST}-base.tgz"
          DISTRIBUTION=${DIST}
          APTCACHE="/var/cache/pbuilder/${DIST}/aptcache"
        fi
        HOOKDIR="${HOME}/.pbuilder-hooks"
        OTHERMIRROR="deb http://us.archive.ubuntu.com/ubuntu {{os_codename}} main restricted | deb http://us.archive.ubuntu.com/ubuntu {{os_codename}}-updates main restricted | deb http://us.archive.ubuntu.com/ubuntu {{os_codename}} universe | deb http://us.archive.ubuntu.com/ubuntu {{os_codename}}-updates universe | deb http://us.archive.ubuntu.com/ubuntu {{os_codename}} multiverse | deb http://us.archive.ubuntu.com/ubuntu {{os_codename}}-updates multiverse | deb http://us.archive.ubuntu.com/ubuntu {{os_codename}}-backports main restricted universe multiverse | deb http://us.archive.ubuntu.com/ubuntu {{os_codename}}-security main restricted | deb http://us.archive.ubuntu.com/ubuntu {{os_codename}}-security universe | deb http://us.archive.ubuntu.com/ubuntu {{os_codename}}-security multiverse"

build_prefs:
  file.append:
    - name: /etc/apt/preferences
    - text: |
        {{prefs_text}}
