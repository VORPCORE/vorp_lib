fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'vorp library'
author 'VORP @outsider'
description 'A library to use for RedM scripts'

-- base scripts
client_scripts {
    'client/main/*.lua'
}

--base scripts
server_scripts {
    'server/main/*.lua'
}

files {
    'import.lua',
    'client/**/*',
    'server/**/*',
    'shared/**/*',
    'web/**/*',
}

ui_page 'web/index.html'

version '0.1'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_lib'
