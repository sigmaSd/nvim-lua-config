local db = require('dashboard')

db.custom_header = {
    "",
    " ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄ ▄▄   ▄▄ ",
    "█  █  █ █       █       █  █ █  █   █  █▄█  █",
    "█   █▄█ █    ▄▄▄█   ▄   █  █▄█  █   █       █",
    "█       █   █▄▄▄█  █ █  █       █   █       █",
    "█  ▄    █    ▄▄▄█  █▄█  █       █   █       █",
    "█ █ █   █   █▄▄▄█       ██     ██   █ ██▄██ █",
    "█▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄█▄█   █▄█",
    ""
}
db.preview_file_height = 12
db.preview_file_width = 80
db.custom_center = {
    { icon = '  ',
        desc = 'Recently opened files                   ',
        action = 'Telescope oldfiles',
        shortcut = 'SPC f o' },
    { icon = '  ',
        desc = 'Find  File                              ',
        action = 'Telescope find_files find_command=rg,--files',
        shortcut = 'SPC f f' },
    { icon = '  ',
        desc = 'File Browser                            ',
        action = 'NvimTreeFocus',
        shortcut = 'Leader n' },
    { icon = '  ',
        desc = 'Find  word                              ',
        action = 'Telescope live_grep',
        shortcut = 'SPC f g' },
}
