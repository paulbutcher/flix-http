use HTTP.Request;
use HTTP/Routes.{defaultRoutes, *>, *$>, *$$>};

def handlePost(date: String, id: Int32): String = "Post: date ${date}, id ${id}"

def handleUser(user: String): String = "User: name ${user}"

def handlePing(): String = "pong"

def handle(req: Request): String = 
  req.uri |> HTTP/Routes.handle(
    ("post/$/$" *$$> handlePost) ::
    ("user/$" *$> handleUser) ::
    ("ping" *> handlePing) ::
    defaultRoutes()
  )
