// Copyright 2020-2024 Datum Technology Corporation
// All rights reserved.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import jetbrains.buildServer.configs.kotlin.v2019_2.*

version = "2020.2"

project(Project {
    buildType(Build)
})

object Build : BuildType({
    name = "Build and Test"
    steps {
        script {
            scriptContent = """
                pip install -r requirements.txt
                pip install -r requirements-dev.txt
                make test
                make docs
            """.trimIndent()
        }
    }
})