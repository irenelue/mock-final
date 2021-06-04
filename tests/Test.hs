import           Control.Exception
import           Control.Monad
import           Test.Tasty
import           Common
import           Language.Elsa
import           Data.List (isInfixOf)
import qualified FileSystem            as FS
import qualified Logging               as L
import           System.FilePath

main :: IO ()
main = runTests
  [ fib 
  , filesystem
  , logging
  ]

-------------------------------------------------------------------------------
-- | Problem 1 ----------------------------------------------------------------
-------------------------------------------------------------------------------

fib :: Score -> TestTree
fib sc = testGroup "Problem 1"
  [ mkTest
      (check "Fib.lc")
      "fib0"
      True
      "fib0"
  , mkTest
      (check "Fib.lc")
      "fib1"
      True
      "fib1"   
  , mkTest
      (check "Fib.lc")
      "fib2"
      True
      "fib2"   
  , mkTest
      (check "Fib.lc")
      "fib5"
      True
      "fib5"   
  ]
  where
    mkTest :: (Show b, Eq b) => (a -> IO b) -> a -> b -> String -> TestTree
    mkTest = mkTest' sc

    check :: FilePath -> Id -> IO Bool
    check f x = do
      r <- runElsaId (testDir </> f) x
      return (r == Just (OK (Bind x ())))

    testDir :: FilePath
    testDir = "src"



-------------------------------------------------------------------------------
-- | Problem 2 ----------------------------------------------------------------
-------------------------------------------------------------------------------

filesystem :: Score -> TestTree
filesystem sc = testGroup "Problem 2"
  [ mkTest
      FS.size
      (FS.File "todo" 256)
      256
      "size 1"
  ,  mkTest
      FS.size
      (FS.Dir "haskell-jokes" [])
      0
      "size 2"
  ,  mkTest
      FS.size
      FS.homedir
      4683
      "size 3"
  ,  mkTest
      (uncurry FS.remove)
      (\e -> FS.nameOf e == "Makefile", FS.homedir)
      rm1
      "remove 1"
  ,  mkTest
      (uncurry FS.remove)
      (\e -> FS.nameOf e == "HW1", FS.homedir)
      rm2
      "remove 2"
  ,  mkTest
      (uncurry FS.remove)
      (\e -> FS.nameOf e == "home", FS.homedir)
      FS.homedir
      "remove 3"
  ,  mkTest
      FS.cleanup
      (FS.Dir "temp" [FS.Dir "drafts" [], FS.File "todo" 256])
      (FS.Dir "temp" [FS.File "todo" 256])
      "cleanup 1"
  ,  mkTest
      FS.cleanup
      (FS.File "todo" 256)
      (FS.File "todo" 256)
      "cleanup 2"
  ,  mkTest
      FS.cleanup
      (FS.Dir "drafts" [])
      (FS.Dir "drafts" [])
      "cleanup 3"
  ]
  where
    rm1 = FS.Dir "home"
            [ FS.File "todo" 256
            , FS.Dir  "HW0" []
            , FS.Dir  "HW1" [FS.File "HW1.hs" 3007]
            ]

    rm2 = FS.Dir "home"
            [ FS.File "todo" 256
            , FS.Dir  "HW0" [ FS.File "Makefile" 575 ]
            ]


    mkTest :: (Show b, Eq b) => (a -> b) -> a -> b -> String -> TestTree
    mkTest f = mkTest' sc (return . f)

-------------------------------------------------------------------------------
-- | Problem 3 ----------------------------------------------------------------
-------------------------------------------------------------------------------
logging :: Score -> TestTree
logging sc = testGroup "Problem 3"
  [ mkTest
      (L.ret3 >>=)
      (\x -> return (x + 5))
      (L.Logging [] 8)
      "do x <- return 3 ; return x + 5"
  , mkTest
      (L.Logging ["hello"] 3 >>=)
      (\x -> L.Logging ["goodbye"] (x + 5))
      (L.Logging ["hello", "goodbye"] 8)
      "do x <- Logging \"hello\" 3; Logging \"goodbye\" (x + 5)"
  , mkTest
      (L.log "hello" >> )
      (return 3)
      (L.Logging ["hello"] 3)
      "do log \"hello\"; return 3"
  , mkTest
      (L.log "hello" >> L.log "goodbye" >>)
      (return 3)
      (L.Logging ["hello", "goodbye"] 3)
      "do log \"hello\"; log \"goodbye\"; return 3"
  , mkTest
      L.eval
      L.e1
      (L.Logging [] 5)
      "2 + 3"
  , mkTest
      L.eval
      L.e2
      (L.Logging ["I saw 2"] 5)
      "log (\"I saw 2\") 2 + 3"
  , mkTest
      L.eval
      L.e3
      (L.Logging ["I saw 2", "I saw 3"] 5)
      "log (\"I saw 2\") 2 + log (\"I saw 3\") 3"
  ]
  where
    mkTest :: (Show b, Eq b) => (a -> b) -> a -> b -> String -> TestTree
    mkTest f = mkTest' sc (return . f)
