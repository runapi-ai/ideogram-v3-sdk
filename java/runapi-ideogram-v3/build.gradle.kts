plugins {
  `java-library`
  `maven-publish`
}

description = "RunAPI Ideogram V3 Java SDK for Ideogram V3 workflows."

java {
  withSourcesJar()
  withJavadocJar()
}

dependencies {
  api("ai.runapi:runapi-core:0.1.5")

  testImplementation(platform("org.junit:junit-bom:5.10.3"))
  testImplementation("org.junit.jupiter:junit-jupiter")
}

publishing {
  publications {
    create<MavenPublication>("mavenJava") {
      from(components["java"])
      artifactId = "runapi-ideogram-v3"
      pom {
        name = "RunAPI Ideogram V3 Java SDK"
        description = "RunAPI Ideogram V3 Java SDK for Ideogram V3 workflows."
        url = "https://runapi.ai/models/ideogram-v3"
        licenses {
          license {
            name = "Apache License, Version 2.0"
            url = "https://www.apache.org/licenses/LICENSE-2.0"
          }
        }
        developers {
          developer {
            id = "runapi"
            name = "RunAPI"
            email = "contact@runapi.ai"
          }
        }
        scm {
          url = "https://github.com/runapi-ai/ideogram-v3-sdk"
          connection = "scm:git:https://github.com/runapi-ai/ideogram-v3-sdk.git"
          developerConnection = "scm:git:ssh://git@github.com/runapi-ai/ideogram-v3-sdk.git"
        }
      }
    }
  }
}
