import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import org.eclipse.jetty.server.handler.AbstractHandler;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.HandlerWrapper;
import org.eclipse.jetty.util.component.AbstractLifeCycle;

// The main entry point.
def main(): Unit & Impure =
  import jakarta.servlet.ServletResponse.getWriter(): PrintWriter & Impure;
  import jakarta.servlet.ServletResponse.setContentType(String): Unit & Impure;
  import jakarta.servlet.http.HttpServletResponse.setStatus(Int32): Unit & Impure;
  import java.io.PrintWriter.print(String): Unit & Impure;
  import org.eclipse.jetty.server.Request.setHandled(Bool): Unit & Impure;
  import new org.eclipse.jetty.server.Server(Int32): Server & Impure as newServer;
  import org.eclipse.jetty.server.Server.join(): Unit & Impure;
  import org.eclipse.jetty.server.handler.HandlerWrapper.setHandler(Handler): Unit & Impure;
  import org.eclipse.jetty.util.component.AbstractLifeCycle.start(): Unit & Impure;

  let server = newServer(8080);
  let handler = new AbstractHandler {
    def handle(_this: AbstractHandler, 
               _target: String, 
               jettyRequest: Request, 
               request: HttpServletRequest, 
               response: HttpServletResponse): Unit =
      setHandled(jettyRequest, true);
      setStatus(response, 200);
      setContentType(response as ServletResponse, "text/html; charset=UTF-8");
      let writer = getWriter(response as ServletResponse);
      print(writer, handle(HTTP.mkRequest(request)))
  };
  setHandler(server as HandlerWrapper, handler as Handler);
  start(server as AbstractLifeCycle);
  join(server)
