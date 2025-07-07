param (
    [string]$envFilePath = (Join-Path -Path (Get-Location) -ChildPath "output\.env"),
    [string]$templateFilePath = (Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Path) -ChildPath "env.template"),
    [string]$siteName = "",
    [string]$jssEditingSecret = "",
    [string]$sitecoreEdgeContextId = "",
    [string]$graphQlEndpoint = "",
    [string]$defaultLanguage = "",
    [string]$sitecoreSearchEnv = "",
    [string]$sitecoreSearchCustomerKey = "",
    [string]$sitecoreSearchApiKey = "",
    [string]$sitecoreSearchPath = "",
    [string]$locales = "",
    [string]$SitecoreAPIHost = ""
)

# Check if the template file exists
if (-Not (Test-Path -Path $templateFilePath)) {
    Write-Error "The template file 'env.template' does not exist at the specified location: $templateFilePath"
    exit 1
}

# Read the content of the template file
$templateContent = Get-Content -Path $templateFilePath

# Replace placeholders with parameter values
if ($siteName) {
    $templateContent = $templateContent -replace '#SITECORE_SITE_NAME=.*', "SITECORE_SITE_NAME=$siteName"
}
if ($jssEditingSecret) {
    $templateContent = $templateContent -replace '#JSS_EDITING_SECRET=.*', "JSS_EDITING_SECRET=$jssEditingSecret"
}
if ($sitecoreEdgeContextId) {
    $templateContent = $templateContent -replace '#SITECORE_EDGE_CONTEXT_ID=.*', "SITECORE_EDGE_CONTEXT_ID=$sitecoreEdgeContextId"
}
if ($graphQlEndpoint) {
    $templateContent = $templateContent -replace '#GRAPH_QL_ENDPOINT=.*', "GRAPH_QL_ENDPOINT=$graphQlEndpoint"
}
if ($SitecoreAPIHost) {
    $templateContent = $templateContent -replace '#SITECORE_API_HOST=.*', "SITECORE_API_HOST=$SitecoreAPIHost"
}
if ($defaultLanguage) {
    $templateContent = $templateContent -replace '#DEFAULT_LANGUAGE=.*', "DEFAULT_LANGUAGE=$defaultLanguage"
}
if ($sitecoreSearchEnv) {
    $templateContent = $templateContent -replace '#NEXT_PUBLIC_SEARCH_ENV=.*', "NEXT_PUBLIC_SEARCH_ENV=$sitecoreSearchEnv"
}
if ($sitecoreSearchCustomerKey) {
    $templateContent = $templateContent -replace '#NEXT_PUBLIC_SEARCH_CUSTOMER_KEY=.*', "NEXT_PUBLIC_SEARCH_CUSTOMER_KEY=$sitecoreSearchCustomerKey"
}
if ($sitecoreSearchApiKey) {
    $templateContent = $templateContent -replace '#NEXT_PUBLIC_SEARCH_API_KEY=.*', "NEXT_PUBLIC_SEARCH_API_KEY=$sitecoreSearchApiKey"
}
if ($sitecoreSearchPath) {
    $templateContent = $templateContent -replace '#NEXT_PUBLIC_SEARCH_PATH=.*', "NEXT_PUBLIC_SEARCH_PATH=$sitecoreSearchPath"
}
if ($locales) {
    $templateContent = $templateContent -replace '#LOCALES=.*', "LOCALES=$locales"
}

# Ensure the output directory exists
$outputDir = Split-Path -Parent $envFilePath
if (-Not (Test-Path -Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force
}

# Write the modified content to the .env file
try {
    $templateContent | Set-Content -Path $envFilePath -Force
    Write-Output "The .env file has been created at: $envFilePath based on the template: $templateFilePath"
}
catch {
    Write-Error "Failed to write to the .env file at: $envFilePath. Error: $_"
}