unit AmazonEmailServiceConfigurationTests;

interface

uses
  DUnitX.TestFramework,
  AmazonEmailServiceConfiguration;

type
  [TestFixture]
  TAmazonEmailServiceConfigurationTests = class
  strict private
    FAmazonEmailServiceConfiguration: TAmazonEmailServiceConfiguration;
  private
    function SetEnvVarValue(const VarName, VarValue: string): Boolean;
    procedure DeleteEnvVarValue(const VarName: string);
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  published
    procedure GetFromEnvironment_WithSetVars_ReturnEnvVars;
    procedure GetFromEnvironment_WithoutSetEndpoint_EArgumentNilException;
    procedure GetFromEnvironment_WithoutSetAccessKey_EArgumentNilException;
    procedure GetFromEnvironment_WithoutSetSecretAccessKey_EArgumentNilException;
  end;

implementation

uses
  SysUtils,
  Windows;

const
  VarEndpoint = 'email.us-east-1.amazonaws.com';
  VarAccessKey = 'QWERTYUIOP1234567890';
  VarSecretAccessKey = 'QWERTYUIOP1234567890/*-+.,asdfghjkl�';

procedure TAmazonEmailServiceConfigurationTests.DeleteEnvVarValue(const VarName: string);
begin
  SetEnvironmentVariable(PChar(VarName), nil);
end;

procedure TAmazonEmailServiceConfigurationTests.GetFromEnvironment_WithoutSetAccessKey_EArgumentNilException;
var
  Endpoint: string;
  AccessKey: string;
  SecretAccessKey: string;
begin
  try
    SetEnvVarValue(AWS_SES_REGION_ENDPOINT, VarEndpoint);
    SetEnvVarValue(AWS_SES_SECRET_ACCESS_KEY, VarSecretAccessKey);

    Assert.WillRaise(
      procedure
      begin
        FAmazonEmailServiceConfiguration.GetFromEnvironment(Endpoint, AccessKey, SecretAccessKey)
      end, EArgumentNilException);

  finally
    DeleteEnvVarValue(AWS_SES_REGION_ENDPOINT);
    DeleteEnvVarValue(AWS_SES_SECRET_ACCESS_KEY);
  end;
end;

procedure TAmazonEmailServiceConfigurationTests.GetFromEnvironment_WithoutSetEndpoint_EArgumentNilException;
var
  Endpoint: string;
  AccessKey: string;
  SecretAccessKey: string;
begin
  Assert.WillRaise(
    procedure
    begin
      FAmazonEmailServiceConfiguration.GetFromEnvironment(Endpoint, AccessKey, SecretAccessKey)
    end, EArgumentNilException);
end;

procedure TAmazonEmailServiceConfigurationTests.GetFromEnvironment_WithoutSetSecretAccessKey_EArgumentNilException;
var
  Endpoint: string;
  AccessKey: string;
  SecretAccessKey: string;
begin
  try
    SetEnvVarValue(AWS_SES_REGION_ENDPOINT, VarEndpoint);
    SetEnvVarValue(AWS_SES_ACCESS_KEY_ID, VarAccessKey);

    Assert.WillRaise(
      procedure
      begin
        FAmazonEmailServiceConfiguration.GetFromEnvironment(Endpoint, AccessKey, SecretAccessKey)
      end, EArgumentNilException);

  finally
    DeleteEnvVarValue(AWS_SES_REGION_ENDPOINT);
    DeleteEnvVarValue(AWS_SES_ACCESS_KEY_ID);
  end;
end;

procedure TAmazonEmailServiceConfigurationTests.GetFromEnvironment_WithSetVars_ReturnEnvVars;
var
  Endpoint: string;
  AccessKey: string;
  SecretAccessKey: string;
begin
  try
    SetEnvVarValue(AWS_SES_REGION_ENDPOINT, VarEndpoint);
    SetEnvVarValue(AWS_SES_ACCESS_KEY_ID, VarAccessKey);
    SetEnvVarValue(AWS_SES_SECRET_ACCESS_KEY, VarSecretAccessKey);

    FAmazonEmailServiceConfiguration.GetFromEnvironment(Endpoint, AccessKey, SecretAccessKey);

    Assert.AreEqual(VarEndpoint, Endpoint);
    Assert.AreEqual(VarAccessKey, AccessKey);
    Assert.AreEqual(VarSecretAccessKey, SecretAccessKey);
  finally
    DeleteEnvVarValue(AWS_SES_REGION_ENDPOINT);
    DeleteEnvVarValue(AWS_SES_ACCESS_KEY_ID);
    DeleteEnvVarValue(AWS_SES_SECRET_ACCESS_KEY);
  end;
end;

function TAmazonEmailServiceConfigurationTests.SetEnvVarValue(const VarName, VarValue: string): Boolean;
begin
  Result := SetEnvironmentVariable(PChar(VarName), PChar(VarValue));
end;

procedure TAmazonEmailServiceConfigurationTests.SetUp;
begin
  FAmazonEmailServiceConfiguration := TAmazonEmailServiceConfiguration.Create;
end;

procedure TAmazonEmailServiceConfigurationTests.TearDown;
begin
  FAmazonEmailServiceConfiguration.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TAmazonEmailServiceConfigurationTests);

end.
