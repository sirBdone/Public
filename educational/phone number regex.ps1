$String = "@
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
    Praesent 4444-333-3456 interdum tellus at mi dignissim, eu vehicula4455555-5556-777 massa mollis. 
    In bibendum odio nec tellus imperdiet, id tincidunt tortor aliquam. Vivamus eget porta arcu. 222-333-4567Etiam ut imperdiet arcu. 
    Proin vulputate eget nisi venenatis eleifend. Class aptent 704-456-7890 taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. 
    In mollis enim et libero efficitur sollicitudin. Suspendisse nulla ex, condimentum a mauris eget, consectetur facilisis ex. Duis eget vehicula dui.
@"

#match 3x3x4 number (like a phone number or social security number) and trim, then verify that the first group ($index[0]) isn't 4 numbers (incorrect format).
($string | select-string -pattern '(?=[\S|\D]\d{3})(.*)(?<=\d{3}-\d{3}-\d{4})' -AllMatches).Matches.Value.trim() | ?{($_ -split "-")[0].Length -eq 3}