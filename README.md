# URL Opener

A Neovim plugin that opens a URL after replacing a specific part with the string selected in visual mode.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "yourusername/url-opener.nvim",
    config = function()
        require("url-opener").setup({
            -- Optionally, you can customize the base URL here
            -- base_url = "your custom URL with {REPLACE_THIS_STRING} placeholder"
        })
    end,
}
```

## Usage

1. Select the text you want to replace `{REPLACE_THIS_STRING}` with in visual mode.
2. Run the command `:OpenUrlWithSelection`

## Configuration

You can customize the base URL by passing it to the setup function:

```lua
require("url-opener").setup({
    base_url = "https://your-custom-url.com/{REPLACE_THIS_STRING}"
})
```
