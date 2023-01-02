namespace HTTP {

import jakarta.servlet.{ServletInputStream, ServletRequest};
import jakarta.servlet.http.HttpServletRequest;

  pub enum Method {
    case GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH
  }

  def mkMethod(s: String): Method =
    let method = Map#{
      "GET" => GET,
      "HEAD" => HEAD,
      "POST" => POST,
      "PUT" => PUT,
      "DELETE" => DELETE,
      "CONNECT" => CONNECT,
      "OPTIONS" => OPTIONS,
      "TRACE" => TRACE,
      "PATCH" => PATCH};
    match Map.get(s, method) {
      case Some(m) => m
      case None => bug!("Invalid HTTP method")
    }

  pub type alias Headers = Map[String, String]

  /// TODO
  def mkHeaders(_request: HttpServletRequest): Headers =
    Map#{}
    
  pub type alias Request = {
    port = Int32,
    server = String,
    remoteAddress = String,
    uri = String,
    queryString = Option[String],
    scheme = String,
    method = Method,
    protocol = String,
    headers = Headers,
    contentType = Option[String],
    contentLength = Int64,
    characterEncoding = Option[String],
    body = ServletInputStream,

    uriParts = List[String],
    queryMap = Map[String, String]
  }

  /// Todo: handle double slashes etc.
  def mkUriParts(uri: String): List[String] =
    uri |> String.splitOn(substr = "/")

  def mkQueryMap(maybeS: Option[String]): Map[String, String] = match maybeS {
    case None => Map#{}
    case Some(s) =>
      s |> String.splitOn(substr = "&") 
        |> List.map(String.breakOnLeft(substr = "="))
        |> List.map(match (k, v) -> (k, v |> String.dropLeft(1)))
        |> List.toMap
  }
  
  pub def mkRequest(request: HttpServletRequest): Request & Impure =  
    import jakarta.servlet.ServletRequest.getServerPort(): Int32;
    import jakarta.servlet.ServletRequest.getServerName(): String;
    import jakarta.servlet.ServletRequest.getRemoteAddr(): String;
    import jakarta.servlet.http.HttpServletRequest.getRequestURI(): String;
    import jakarta.servlet.http.HttpServletRequest.getQueryString(): String;
    import jakarta.servlet.ServletRequest.getScheme(): String;
    import jakarta.servlet.http.HttpServletRequest.getMethod(): String;
    import jakarta.servlet.ServletRequest.getProtocol(): String;
    import jakarta.servlet.ServletRequest.getContentType(): String;
    import jakarta.servlet.ServletRequest.getContentLengthLong(): Int64;
    import jakarta.servlet.ServletRequest.getCharacterEncoding(): String;
    import jakarta.servlet.ServletRequest.getInputStream(): ServletInputStream;

    let uri = getRequestURI(request);
    let queryString = getQueryString(request) |> Object.toOption;
    {
      port = getServerPort(upcast request),
      server = getServerName(upcast request),
      remoteAddress = getRemoteAddr(upcast request),
      uri = uri,
      queryString = queryString,
      scheme = getScheme(upcast request),
      method = mkMethod(getMethod(request)),
      protocol = getProtocol(upcast request),
      headers = mkHeaders(request),
      contentType = getContentType(upcast request) |> Object.toOption,
      contentLength = getContentLengthLong(upcast request),
      characterEncoding = getCharacterEncoding(upcast request) |> Object.toOption,
      body = getInputStream(upcast request),
      
      uriParts = mkUriParts(uri),
      queryMap = mkQueryMap(queryString)
    }
}
