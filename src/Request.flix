namespace HTTP {

  pub enum Method {
    case GET, HEAD, POST, PUT, DELETE, CONNECT, OPTIONS, TRACE, PATCH
  }

  def mkMethod(s: String): Method =
    let method = Map#{"GET" => GET,
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
    port:: Int32,
    server:: String,
    remoteAddress:: String,
    uri:: String,
    queryString:: String,
    scheme:: String,
    method:: Method,
    protocol:: String,
    headers:: Headers,
    contentType:: String,
    contentLength:: Int32,
    characterEncoding:: String,
    body:: ServletInputStream
  }

  pub def mkRequest(request: HttpServletRequest): Request =
    import jakarta.servlet.ServletRequest.getServerPort(): Int32 & Pure;
    import jakarta.servlet.ServletRequest.getServerName(): String & Pure;
    import jakarta.servlet.ServletRequest.getRemoteAddr(): String & Pure;
    import jakarta.servlet.http.HttpServletRequest.getRequestURI(): String & Pure;
    import jakarta.servlet.http.HttpServletRequest.getQueryString(): String & Pure;
    import jakarta.servlet.ServletRequest.getScheme(): String & Pure;
    import jakarta.servlet.http.HttpServletRequest.getMethod(): String & Pure;
    import jakarta.servlet.ServletRequest.getProtocol(): String & Pure;
    import jakarta.servlet.ServletRequest.getContentType(): String & Pure;
    import jakarta.servlet.ServletRequest.getContentLength(): Int32 & Pure;
    import jakarta.servlet.ServletRequest.getCharacterEncoding(): String & Pure;
    import jakarta.servlet.ServletRequest.getInputStream(): ServletInputStream & Pure;
    {
      port = getServerPort(request as ServletRequest),
      server = getServerName(request as ServletRequest),
      remoteAddress = getRemoteAddr(request as ServletRequest),
      uri = getRequestURI(request),
      queryString = getQueryString(request),
      scheme = getScheme(request as ServletRequest),
      method = mkMethod(getMethod(request)),
      protocol = getProtocol(request as ServletRequest),
      headers = mkHeaders(request),
      contentType = getContentType(request as ServletRequest),
      contentLength = getContentLength(request as ServletRequest),
      characterEncoding = getCharacterEncoding(request as ServletRequest),
      body = getInputStream(request as ServletRequest)
    }
}
