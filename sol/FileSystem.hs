-------------------------------------------------------------------------------
-- DO NOT MODIFY THIS SEGMENT
-------------------------------------------------------------------------------

module FileSystem where

-- | File system entry
data Entry = File String Int      -- File: name and size
           | Dir String [Entry]   -- Directory: name and content
  deriving (Eq, Show)

homedir = Dir "home" 
            [ File "todo" 256
            , Dir  "HW0" 
              [ File "Makefile" 575 ]
            , Dir  "HW1" 
              [ File "Makefile" 845
              , File "HW1.hs"   3007
              ]
            ]

-- | Name of an entry
nameOf :: Entry -> String
nameOf (File name _) = name
nameOf (Dir name _)  = name            

-------------------------------------------------------------------------------
-- Task 2.1: Tail-recursive size
-------------------------------------------------------------------------------

-- | Size of an entry; must be tail-recursive!
size :: Entry -> Int
size e = loop 0 [e]
  where
    loop :: Int -> [Entry] -> Int
    loop acc []     = acc
    loop acc (File _ s : es) = loop (acc + s) es
    loop acc (Dir _ cs : es) = loop acc (cs ++ es)

-------------------------------------------------------------------------------
-- Task 2.2: HOF Remove
-------------------------------------------------------------------------------

-- | Remove all contained entries that satisfy a predicate
remove :: (Entry -> Bool) -> Entry -> Entry
remove f (Dir name cs) = Dir name (map (remove f) (filter (not . f) cs))
remove _ e             = e

-------------------------------------------------------------------------------
-- Task 2.3: Cleanup
-------------------------------------------------------------------------------

-- | Remove empty contained entries
cleanup :: Entry -> Entry
cleanup e = remove isEmpty e
  where
    isEmpty (Dir _ []) = True
    isEmpty _          = False



    
    