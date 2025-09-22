# Use an official OpenJDK 21 runtime as a parent image
FROM eclipse-temurin:21-jdk-jammy

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven wrapper and pom.xml to leverage Docker cache
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Download all dependencies
RUN ./mvnw dependency:go-offline

# Copy the rest of the source code
COPY src ./src

# Package the application
RUN ./mvnw package -DskipTests

# Tell Render that the application will listen on port 10000
ENV PORT=10000
EXPOSE 10000

# Command to run the executable
# This command also explicitly sets the server port and database URL from environment variables
CMD ["java", "-jar", \
     "-Dserver.port=${PORT}", \
     "-Dspring.datasource.url=${DATABASE_URL}", \
     "target/FSDproject-0.0.1-SNAPSHOT.jar"]