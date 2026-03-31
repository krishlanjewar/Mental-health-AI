allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val rootBuildDir = rootProject.layout.projectDirectory.dir("../../build")
rootProject.layout.buildDirectory.set(rootBuildDir)

subprojects {
    val subprojectBuildDir = rootBuildDir.dir(project.name)
    project.layout.buildDirectory.set(subprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

