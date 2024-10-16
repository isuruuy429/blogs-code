import ballerinax/health.fhir.r4.international401;
import ballerinax/health.clients.fhir as fhirClient;
import ballerinax/health.fhirr4;
import ballerinax/health.fhir.r4;

public type Practitioner international401:Practitioner;

// Connection parameters to the  Cerner EMR
configurable string base = ?;
configurable string tokenUrl = ?;
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string[] scopes = ?;

// Create a FHIR client configuration
fhirClient:FHIRConnectorConfig cernerConfig = {
    baseURL: base,
    mimeType: fhirClient:FHIR_JSON,
    authConfig: {
        tokenUrl: tokenUrl,
        clientId: clientId,
        clientSecret: clientSecret,
        scopes: scopes
    }
};

// Create a FHIR client
final fhirClient:FHIRConnector fhirConnectorObj = check new (cernerConfig);


service / on new fhirr4:Listener(7070, practitionerApiConfig){

    isolated resource function get fhir/r4/Practitioner/[string id](r4:FHIRContext fhirContext)returns international401:Practitioner|error{
        fhirClient:FHIRResponse fhirResponse = check fhirConnectorObj->getById("Practitioner", id);
        return fhirResponse.'resource.cloneWithType(Practitioner);
    }
}
