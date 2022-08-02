namespace HTTP {
  namespace Routes {

    def getMatches(p: String, arity: Int32, s: String): Option[List[String]] =
      region r {
        import static java.util.regex.Pattern.compile(String): ##java.util.regex.Pattern & r;
        import java.util.regex.Pattern.matcher(##java.lang.CharSequence): ##java.util.regex.Matcher & r;
        import java.util.regex.Matcher.find(): Bool & r;
        import java.util.regex.Matcher.group(Int32): String & r;
        let _ = r; // Defeat unused variable warning
        let regex = String.replace(from = "$", to = "([^/]*)", p);
        let pattern = compile(regex);
        let matches = matcher(pattern, s as ##java.lang.CharSequence);
        if (find(matches))
          Some(List.range(0, arity) |> List.map(i -> group(matches, i + 1)))
        else
          None
      }

    pub def *>(p: String, f: Unit -> String, s: String): Option[String] =
      match getMatches(p, 0, s) {
        case Some(_) => Some(f())
        case None => None
      }

    pub def *$>(p: String, f: a -> String, s: String): Option[String] with FromString[a] =
      match getMatches(p, 1, s) {
        case Some(m1 :: Nil) =>
          match FromString.fromString(m1) {
            case Some(v1) => Some(f(v1))
            case _ => None
          }
        case _ => None
      }

    pub def *$$>(p: String, f: a -> b -> String, s: String): Option[String] with FromString[a], FromString[b] =
      match getMatches(p, 2, s) {
        case Some(m1 :: m2 :: Nil) =>
          match (FromString.fromString(m1), FromString.fromString(m2)) {
            case (Some(v1), Some(v2)) => Some(f(v1, v2))
            case _ => None
          }
        case _ => None
      }

    pub def handleNotFound(s: String): Option[String] = 
      Some("Not found: ${s}")

    pub type alias Route = String -> Option[String]

    pub def defaultRoutes(): List[Route] =
      handleNotFound :: Nil

    pub def handle(routes: List[Route], s: String): String =
      match routes {
        case h :: t => match h(s) {
          case Some(result) => result
          case _ => handle(t, s)
        }
        case _ => "Not found: ${s}"
      }
  }
}