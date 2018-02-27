# Update Build Number

VSTS Task Group using inline PowerShell scripts.

Used to set the build number based on values found in the project source in conjunction with a user-managed revision number to give greater control over the final build number.

Reads a major/minor version from a csproj file (or other XML file), and a revision number from a build definition variable, updates the build number for the current build with these values and then increments the revision number.

## Installation

Import the json file using the VSTS UI.

## Usage

The task group expects a build definition variable called 'buildRevision'. This should be created with a value of, say, 0. This value will increment by 1 each time the build defintion executes the task group.

The task group has 3 parameters:

- versionProjectPath: The filepath to the csproj (or other XML) file containing a major/minor version for use in the generated build number. E.g. $(System.DefaultWorkingDirectory)/src/Hcc.DevOps.SamplePackage/Hcc.DevOps.SamplePackage.csproj
- versionElement: The path to the xml node whose value contains the major/minor version. Defaults to Project.PropertyGroup.AssemblyVersion
- buildRevision: The build variable used to store the current revision number for the build defintion. Defaults to $(buildRevision). If a different variable is used then additional changes will be required in the inline scripts for the 2 tasks.

Updating the build number requires the build service account to have Edit Build Definition permissions for the current build definition.
