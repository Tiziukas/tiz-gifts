fx_version 'cerulean'
games { 'gta5' }

author 'Tizas'

description 'Gifts using ox_lib'

version '1.0.0'

lua54 'yes'


client_scripts {
    'client/client.lua',
    '@mysql-async/lib/MySQL.lua'
}
server_script {
    'server/server.lua',
    '@mysql-async/lib/MySQL.lua'
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'shared/**.lua',
}
