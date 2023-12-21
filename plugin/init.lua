local current_file = vim.fn.expand("%:t")
local skeleton_php_file = "0r " .. vim.fn.getcwd() .. "/skeleton.php"
local root_namespace = ""
local php_command = ""

local file_exists = function(name)
   local f = io.open(name,"r")
   if f ~= nil then io.close(f) return true else return false end
end

if file_exists("composer.json") then
    -- get namespace from ./vendor/composer/autoload_psr4.php
    root_namespace = "App"
end

if current_file:match("^[A-Z]") then -- file starts with capital thus should be a class
    php_command = table.concat({
        skeleton_php_file,
        "%s/CLASS_NAME/\\=expand('%:t:r')/",
        "%s/NAME_SPACE/\\=expand('%:h')/",
        "g/^namespace/s/\\//\\\\/g",
        "%s/namespace .*\\\\/namespace " .. root_namespace .. "\\\\/",
        "normal! 4j"
    }, " | ")
else
    php_command = table.concat({
        skeleton_php_file,
        "2,$delete"
    }, " | ")
end

local skeleton_options = {
    php = {
        pattern = {"*.php"},
        command = php_command
    },
    sh = {
        pattern = {"*.sh"},
        command = "0r $HOME/.config/nvim/templates/skeleton.sh"
    }
}

for _, v in pairs(skeleton_options) do
    vim.api.nvim_create_autocmd({"BufNewFile"}, v)
end
