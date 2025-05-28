# Utiliser une image de base Tomcat
FROM tomcat:9.0

# Supprimer les applications par défaut de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copier le fichier WAR de votre application dans le répertoire webapps de Tomcat
COPY target/medical-center-app-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Exposer le port 8080 pour accéder à l'application
EXPOSE 8080

# Démarrer Tomcat
CMD ["catalina.sh", "run"]