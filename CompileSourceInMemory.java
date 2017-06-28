package com.selenium.util;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.net.URI;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import javax.tools.Diagnostic;
import javax.tools.DiagnosticCollector;
import javax.tools.JavaCompiler;
import javax.tools.JavaCompiler.CompilationTask;
import javax.tools.JavaFileManager;
import javax.tools.JavaFileObject;
import javax.tools.SimpleJavaFileObject;
import javax.tools.ToolProvider;

import org.openqa.selenium.WebDriver;


public class CompileSourceInMemory {
	static String outputFolder = "D:\\eclipseworkspace\\Test";
  public static void executeJavaCode(String javaCode, String className, WebDriver driver) throws IOException {
    JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
    DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<JavaFileObject>();
    JavaFileObject file = new JavaSourceFromString(className, javaCode);
    Iterable<? extends JavaFileObject> compilationUnits = Arrays.asList(file);
 // set the classpath
    List<String> options = new ArrayList<String>();

    options.add("-classpath");
    StringBuilder sb = new StringBuilder();
    URLClassLoader urlClassLoader = (URLClassLoader) Thread.currentThread().getContextClassLoader();
    for (URL url : urlClassLoader.getURLs()) {
        sb.append(url.getFile()).append(File.pathSeparator);            
    }
    options.add(sb.toString());
    Iterable<String> option = Arrays.asList("-g", "-d", outputFolder);
    
    options.addAll((Collection<? extends String>) option);
    CompilationTask task = compiler.getTask(null, null, diagnostics, options, null, compilationUnits);
    boolean success = task.call();
    for (Diagnostic diagnostic : diagnostics.getDiagnostics()) {
      System.out.println(diagnostic.getCode());
      System.out.println(diagnostic.getKind());
      System.out.println(diagnostic.getPosition());
      System.out.println(diagnostic.getStartPosition());
      System.out.println(diagnostic.getEndPosition());
      System.out.println(diagnostic.getSource());
      System.out.println(diagnostic.getMessage(null));

    }
    System.out.println("Success: " + success);
    if (success) {
      try {
    	  URLClassLoader classLoader = URLClassLoader.newInstance(new URL[] { new File(outputFolder).toURI().toURL() }, urlClassLoader);
          Class.forName("BtnClickHandler", true, classLoader).getDeclaredMethod("test", new Class[] { WebDriver.class }).invoke(null, new Object[] { driver });

      } catch (ClassNotFoundException e) {
        System.err.println("Class not found: " + e);
      } catch (NoSuchMethodException e) {
        System.err.println("No such method: " + e);
      } catch (IllegalAccessException e) {
        System.err.println("Illegal access: " + e);
      } catch (InvocationTargetException e) {
        System.err.println("Invocation target: " + e);
      }
      catch(Exception e){
    	  System.err.println("Class not found: " + e);
      }
    }
  }
}

class JavaSourceFromString extends SimpleJavaFileObject {
  final String code;

  JavaSourceFromString(String name, String code) {
    super(URI.create("string:///" + name.replace('.','/') + Kind.SOURCE.extension),Kind.SOURCE);
    this.code = code;
  }

  @Override
  public CharSequence getCharContent(boolean ignoreEncodingErrors) {
    return code;
  }
  public static void main(String a[]){
	  
  }
}