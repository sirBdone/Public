$word = New-Object -ComObject word.application
$document = $word.documents.add()

$markdown = @"
# Sample Markdown

## Heading 2

This is a paragraph with **bold text** and *italicized text*.

### Heading 3

- This is a bullet point.
- This is another bullet point.
"@

$selection = $word.selection
$selection.typetext($markdown)

$document.saveas("C:\Users\sirbd0ne\Documents\$($prompt.split("\.")[1]).docx")
$document.close()
$word.quit()