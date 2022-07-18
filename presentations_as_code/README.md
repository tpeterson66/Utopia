# Presentations as Code

This was a fun little project to try and get presentations in a git repository and treat slide decks the same as every other piece of documentation around.

This uses Hugo and Reveal, which I don't know much about, to build slide decks as websites similar to <slides.com>.

## Using GitHub Actions

This is the sample code for using GitHub Actions to deploy to Azure Static Web Apps.

```yaml
jobs:
  deploy:
    runs-on: ubuntu-20.04
    concurrency:
      group: ${{ github.workflow }}-${{ github.ref }}
    steps:
      - uses: actions/checkout@v3
        with:
          submodules: true  # Fetch Hugo themes (true OR recursive)
          fetch-depth: 0    # Fetch all history for .GitInfo and .Lastmod

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
        with:
          hugo-version: '0.91.2'
          # extended: true

      - name: Build
        run: hugo --minify
        working-directory: ./presentations_as_code/slides
        shell: bash

      - name: Deploy
        id: deploy
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
          # repo_token: ${{ secrets.GITHUB_TOKEN }} # Used for GitHub integrations (i.e. PR comments)
          action: "upload"
          ###### Repository/Build Configurations ######
          app_location: "presentations_as_code/slides" # App source code path relative to repository root
          # api_location: "api" # Api source code path relative to repository root - optional
          output_location: "public" # Built app content directory, relative to app_location - optional
          ###### End of Repository/Build Configurations ######
```

## Using Azure DevOps

This is in use in Azure DevOps for build CAF slide decks. The team updates the code and the pipeline runs deploying the latest version to a Azure Static Web App, which the rest of the team can consume.

```yaml
  - stage: cafSlides
    dependsOn: []
    displayName: Presentation as Code
    jobs:
      - job: Build
        displayName: Build and Deploy Slide Deck
        steps:
        - script: |
            brew install hugo
          displayName: "Install Hugo"

        - script: |
            hugo --gc --minify
          displayName: 'Generate CAF Slides'
          workingDirectory: ./slides

        - task: AzureStaticWebApp@0
          condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
          inputs:
            azure_static_web_apps_api_token: $(WEB_APP_TOKEN)
            action: "upload"
            app_location: "/slides" # App source code path
            output_location: "public" # Built app content directory - optional
```
