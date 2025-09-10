
pipeline {
  agent any

  triggers {
    pollSCM('* * * * *') // check every minute - for defense demo
  }

  environment {
    TOMCAT_WEBAPPS = 'C:\\Program Files\\Apache Software Foundation\\Tomcat 9.0\\webapps'
    APP_NAME       = 'HIT_GroupApp' // change to include your real names
    APP_SRC        = 'app'
    BASE_URL       = "http://localhost:8080/${APP_NAME}"
    GATLING_HOME   = 'C:\\Gatling' // change if installed elsewhere
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Deploy to Tomcat') {
      steps {
        bat '''
        setlocal EnableDelayedExpansion
        echo Deploying to %TOMCAT_WEBAPPS%\\%APP_NAME%
        if exist "%TOMCAT_WEBAPPS%\\%APP_NAME%" (
          rmdir /S /Q "%TOMCAT_WEBAPPS%\\%APP_NAME%"
        )
        mkdir "%TOMCAT_WEBAPPS%\\%APP_NAME%"
        xcopy "%WORKSPACE%\\%APP_SRC%\\*" "%TOMCAT_WEBAPPS%\\%APP_NAME%\\" /E /I /Y
        '''
      }
    }

    stage('Smoke Check') {
      steps {
        bat 'curl -s -o NUL -w "HTTP:%{http_code}\n" "%BASE_URL%/index.jsp"'
      }
    }

    stage('Selenium IDE (optional)') {
      when {
        expression { return false } // set to true when runner is installed
      }
      steps {
        bat '''
        selenium-side-runner -c "browserName=chrome headless=true" tests\\app.side
        '''
      }
    }

    stage('Gatling - Max Limit (optional)') {
      when { expression { return false } } // enable when Gatling is installed
      steps {
        bat '"%GATLING_HOME%\\bin\\gatling.bat" -s hit.devops.MaxLimitSimulation -rf "%WORKSPACE%\\gatling-results\\max" -rd "Max Limit"'
      }
      post {
        always {
          archiveArtifacts artifacts: 'gatling-results\\max\\**\\*', fingerprint: false
        }
      }
    }

    stage('Gatling - Load 5m (optional)') {
      when { expression { return false } }
      steps {
        bat '"%GATLING_HOME%\\bin\\gatling.bat" -s hit.devops.LoadSimulation -rf "%WORKSPACE%\\gatling-results\\load" -rd "Load 5m"'
      }
      post {
        always {
          archiveArtifacts artifacts: 'gatling-results\\load\\**\\*', fingerprint: false
        }
      }
    }

    stage('Gatling - Stress 3-4m (optional)') {
      when { expression { return false } }
      steps {
        bat '"%GATLING_HOME%\\bin\\gatling.bat" -s hit.devops.StressSimulation -rf "%WORKSPACE%\\gatling-results\\stress" -rd "Stress 3-4m"'
      }
      post {
        always {
          archiveArtifacts artifacts: 'gatling-results\\stress\\**\\*', fingerprint: false
        }
      }
    }
  }

  post {
    success {
      echo "Deployed OK to ${env.BASE_URL}"
    }
  }
}
