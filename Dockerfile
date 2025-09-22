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

# Your app will run on port 10000, which Render provides
EXPOSE 10000

# Command to run the executable
# IMPORTANT: Double-check that your JAR file name in /target matches this!
CMD ["java", "-jar", "target/FSDProjectCompleted-0.0.1-SNAPSHOT.jar"]