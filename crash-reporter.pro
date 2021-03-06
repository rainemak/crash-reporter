#
# This file is part of crash-reporter
#
#  Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
#
#  Contact: Ville Ilvonen <ville.p.ilvonen@nokia.com>
#  Author: Riku Halonen <riku.halonen@nokia.com>
#
#  Copyright (C) 2013 Jolla Ltd.
#  Contact: Jakub Adam <jakub.adam@jollamobile.com>
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public License
#  version 2.1 as published by the Free Software Foundation.
# 
#  This program is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
#  02110-1301 USA
#
#

TEMPLATE = subdirs
CONFIG += ordered recurse

!exists(crash-reporter-conf.pri) {
     error("Project configuration file crash-reporter-conf.pri not found")
}

include(crash-reporter-conf.pri)

SUBDIRS += src translations

# If running in SDK, create fake mount points in user home
contains(DEFINES, CREPORTER_SDK_HOST) {
    system(mkdir -p $HOME/home/user/MyDocs)
}

include(doc/doc.pri)

scripts.path = $${CREPORTER_SYSTEM_SHARE}/crash-reporter
scripts.files = scripts/crash-report-monitoring

notifications.path = $${CREPORTER_SYSTEM_SHARE}/lipstick/notificationcategories/
notifications.files = data/x-nemo.crash-reporter.autouploader.conf \
                      data/x-nemo.crash-reporter.notification.conf

settings.path = $$CREPORTER_SETTINGS_PATH
settings.files += \
	data/crash-reporter-privacy.conf \
	data/crash-reporter.conf \
	data/journalspy-expressions.conf \

dbus_config.path = /etc/dbus-1/system.d
dbus_config.files = data/crash-reporter-dbus.conf

systemd_service.path = $${CREPORTER_SYSTEM_SYSTEMD_USER_SERVICES}
systemd_service.files = data/crash-reporter.service

MULTI_USER_TARGET_WANTS = \
	$(INSTALL_ROOT)/$$CREPORTER_SYSTEM_SYSTEMD_SYSTEM_SERVICES/multi-user.target.wants

systemd_services.path = $${CREPORTER_SYSTEM_SYSTEMD_SYSTEM_SERVICES}
systemd_services.files = \
	data/crash-reporter-endurance.service \
	data/crash-reporter-journalspy.service
systemd_services.commands = \
	mkdir $$MULTI_USER_TARGET_WANTS; \
	ln -s ../crash-reporter-endurance.service \
		$$MULTI_USER_TARGET_WANTS/crash-reporter-endurance.service; \
	ln -s ../crash-reporter-journalspy.service \
		$$MULTI_USER_TARGET_WANTS/crash-reporter-journalspy.service;

endurance_script.path = $${CREPORTER_SYSTEM_LIBEXEC}
endurance_script.files = scripts/endurance-collect

oneshot.path = $${CREPORTER_SYSTEM_ONESHOT}
oneshot.files = scripts/crash-reporter-service-default

INSTALLS += scripts notifications settings dbus_config systemd_service \
	systemd_services endurance_script oneshot
