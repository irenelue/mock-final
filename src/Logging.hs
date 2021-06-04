-------------------------------------------------------------------------------
-- DO NOT MODIFY THIS SEGMENT
-------------------------------------------------------------------------------

module Logging where

import Prelude hiding (log)  

type Id = String

-- | Expressions
data Expr = EInt Int          -- Constant
          | EPlus Expr Expr   -- Addition
          | ELog String Expr  -- Log a message

-- | A logging computation contains a log (a list of messages) and a value
data Logging a = Logging [String] a
  deriving Eq

instance Show a => Show (Logging a) where
  show (Logging log a) = unlines (log ++ [show a])

ret3 :: Logging Int
ret3 = return 3

e1 = EPlus (EInt 2) 
           (EInt 3)
e2 = EPlus (ELog "I saw 2" (EInt 2)) 
           (EInt 3)
e3 = EPlus (ELog "I saw 2" (EInt 2)) 
           (ELog "I saw 3" (EInt 3))


-------------------------------------------------------------------------------
-- Task 3.1: Monad Instance for Logging
-------------------------------------------------------------------------------

instance Monad Logging where
  return  = error "TBD"

  (>>=)   = error "TBD"

-------------------------------------------------------------------------------
-- Task 3.2: Adding to log
-------------------------------------------------------------------------------                                

log :: String -> Logging ()
log = error "TBD"

-------------------------------------------------------------------------------
-- Task 3.3: Eval
-------------------------------------------------------------------------------

eval :: Expr -> Logging Int
eval = error "TBD"







-------------------------------------------------------------------------------
-- DO NOT MODIFY THIS SEGMENT
-------------------------------------------------------------------------------

instance Functor Logging where
  fmap f (Logging log x) = Logging log (f x)

instance Applicative Logging where
  pure v = Logging [] v

  (Logging log1 f) <*> (Logging log2 x) = Logging (log1 ++ log2) (f x)


  