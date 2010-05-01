rm -f *.class
CLASSPATH="$CLASSPATH:../jna.jar" javac *.java
jar -cf clp.jar *.class