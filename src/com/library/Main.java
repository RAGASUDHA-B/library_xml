package com.library;

import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

import java.io.File;

public class Main {
    public static void main(String[] args) throws Exception {
        int port = 8081;

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(port);
        tomcat.getConnector(); // required to init connector

        // Resolve WebContent directory (works from project root)
        File webContentDir = new File("WebContent").getAbsoluteFile();
        File classesDir    = new File("target/classes").getAbsoluteFile();

        if (!webContentDir.exists()) {
            System.err.println("ERROR: WebContent folder not found at: " + webContentDir.getAbsolutePath());
            System.exit(1);
        }

        // Register the webapp at root context ""
        Context ctx = tomcat.addWebapp("", webContentDir.getAbsolutePath());
        ctx.setReloadable(false);

        // Make compiled classes visible to the webapp classloader
        StandardRoot resources = new StandardRoot(ctx);
        resources.addPreResources(
            new DirResourceSet(resources, "/WEB-INF/classes",
                               classesDir.getAbsolutePath(), "/")
        );
        ctx.setResources(resources);

        System.out.println();
        System.out.println("╔══════════════════════════════════════════════╗");
        System.out.println("║     Library XML-JSP App is starting...       ║");
        System.out.println("╠══════════════════════════════════════════════╣");
        System.out.println("║  URL : http://localhost:" + port + "/library          ║");
        System.out.println("║  XML : WebContent/books.xml                  ║");
        System.out.println("║  Press Ctrl+C to stop                        ║");
        System.out.println("╚══════════════════════════════════════════════╝");

        tomcat.start();
        tomcat.getServer().await();
    }
}
