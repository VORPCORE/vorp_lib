fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

name 'vorp library'
author 'VORP @outsider'
description 'A library to use for RedM scripts'

lua54 'yes'

files {
    'import.lua',
    'client/modules/*.lua'
}

-- base scripts
client_scripts {
    'client/main/*.lua'
}

--server_scripts {
--   'server/**/*', -- this will be removed as its to use in other scripts
--}

version '0.1'

vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp_lib'
