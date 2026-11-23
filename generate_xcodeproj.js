const fs = require('fs');
const path = require('path');

const iosDir = path.resolve(__dirname);
const partifulAppDir = path.join(iosDir, 'PartifulApp');
const xcodeprojDir = path.join(iosDir, 'PartifulApp.xcodeproj');
const schemesDir = path.join(xcodeprojDir, 'xcshareddata', 'xcschemes');

if (!fs.existsSync(schemesDir)) {
  fs.mkdirSync(schemesDir, { recursive: true });
}

// Find all swift files
function getAllFiles(dir, baseDir = dir) {
  let results = [];
  const list = fs.readdirSync(dir);
  list.forEach(file => {
    const fullPath = path.join(dir, file);
    const stat = fs.statSync(fullPath);
    if (stat && stat.isDirectory()) {
      results = results.concat(getAllFiles(fullPath, baseDir));
    } else if (file.endsWith('.swift')) {
      const relPath = path.relative(baseDir, fullPath).replace(/\\/g, '/');
      results.push({
        fileName: file,
        relPath: 'PartifulApp/' + relPath,
        name: file
      });
    }
  });
  return results;
}

const swiftFiles = getAllFiles(partifulAppDir);
console.log(`Found ${swiftFiles.length} Swift files.`);

function makeId(prefix, index) {
  return prefix + index.toString(16).padStart(8, '0').toUpperCase() + '00000001';
}

let buildFileSection = '';
let fileRefSection = '';
let sourcesSection = '';
let groupChildren = '';

swiftFiles.forEach((file, index) => {
  const fileRefId = makeId('1100', index);
  const buildFileId = makeId('2200', index);

  buildFileSection += `\t\t${buildFileId} /* ${file.fileName} in Sources */ = {isa = PBXBuildFile; fileRef = ${fileRefId} /* ${file.fileName} */; };\n`;
  fileRefSection += `\t\t${fileRefId} /* ${file.fileName} */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "${file.fileName}"; sourceTree = "<group>"; };\n`;
  sourcesSection += `\t\t\t\t${buildFileId} /* ${file.fileName} in Sources */,\n`;
});

// Info.plist reference
const infoPlistRefId = '1100FFFF00000001';
fileRefSection += `\t\t${infoPlistRefId} /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; name = "Info.plist"; path = "PartifulApp/Resources/Info.plist"; sourceTree = "<group>"; };\n`;

// Product reference
const productRefId = '1100000000000002';
fileRefSection += `\t\t${productRefId} /* PartifulApp.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = PartifulApp.app; sourceTree = BUILT_PRODUCTS_DIR; };\n`;

// Build individual groups based on directory structure
// To make it super clean and robust, we can create flat file references using their relative paths
let mainFilesRefs = '';
swiftFiles.forEach((file, index) => {
  const fileRefId = makeId('1100', index);
  mainFilesRefs += `\t\t\t\t${fileRefId} /* ${file.fileName} */,\n`;
});

// Project IDs
const projId = '1A00000100000001';
const targetId = '1A00000200000001';
const mainGroupId = '1A00000300000001';
const appGroupId = '1A00000400000001';
const productsGroupId = '1A00000500000001';
const sourcesBuildPhaseId = '1A00000600000001';
const frameworksBuildPhaseId = '1A00000700000001';
const resourcesBuildPhaseId = '1A00000800000001';
const projConfigListId = '1A00000900000001';
const targetConfigListId = '1A00000A00000001';
const projDebugConfigId = '1A00000B00000001';
const projReleaseConfigId = '1A00000C00000001';
const targetDebugConfigId = '1A00000D00000001';
const targetReleaseConfigId = '1A00000E00000001';

// Group section
let groupSection = `/* Begin PBXGroup section */
\t\t${mainGroupId} = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t${appGroupId} /* PartifulApp */,
\t\t\t\t${productsGroupId} /* Products */,
\t\t\t);
\t\t\tsourceTree = "<group>";
\t\t};
\t\t${productsGroupId} /* Products */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
\t\t\t\t${productRefId} /* PartifulApp.app */,
\t\t\t);
\t\t\tname = Products;
\t\t\tsourceTree = "<group>";
\t\t};
\t\t${appGroupId} /* PartifulApp */ = {
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
${mainFilesRefs}\t\t\t\t${infoPlistRefId} /* Info.plist */,
\t\t\t);
\t\t\tpath = PartifulApp;
\t\t\tsourceTree = "<group>";
\t\t};
/* End PBXGroup section */`;

// Update fileRef paths to be relative to PartifulApp group
fileRefSection = '';
swiftFiles.forEach((file, index) => {
  const fileRefId = makeId('1100', index);
  const relInsidePartiful = file.relPath.replace('PartifulApp/', '');
  fileRefSection += `\t\t${fileRefId} /* ${file.fileName} */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = "${relInsidePartiful}"; sourceTree = "<group>"; };\n`;
});
fileRefSection += `\t\t${infoPlistRefId} /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = "Resources/Info.plist"; sourceTree = "<group>"; };\n`;
fileRefSection += `\t\t${productRefId} /* PartifulApp.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = PartifulApp.app; sourceTree = BUILT_PRODUCTS_DIR; };\n`;

const pbxprojContent = `// !$*UTF8*$!
{
\tarchiveVersion = 1;
\tclasses = {
\t};
\tobjectVersion = 56;
\tobjects = {

/* Begin PBXBuildFile section */
${buildFileSection}/* End PBXBuildFile section */

/* Begin PBXFileReference section */
${fileRefSection}/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
\t\t${frameworksBuildPhaseId} /* Frameworks */ = {
\t\t\tisa = PBXFrameworksBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXFrameworksBuildPhase section */

${groupSection}

/* Begin PBXNativeTarget section */
\t\t${targetId} /* PartifulApp */ = {
\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = ${targetConfigListId} /* Build configuration list for PBXNativeTarget "PartifulApp" */;
\t\t\tbuildPhases = (
\t\t\t\t${sourcesBuildPhaseId} /* Sources */,
\t\t\t\t${frameworksBuildPhaseId} /* Frameworks */,
\t\t\t\t${resourcesBuildPhaseId} /* Resources */,
\t\t\t);
\t\t\tbuildRules = (
\t\t\t);
\t\t\tdependencies = (
\t\t\t);
\t\t\tname = PartifulApp;
\t\t\tproductName = PartifulApp;
\t\t\tproductReference = ${productRefId} /* PartifulApp.app */;
\t\t\tproductType = "com.apple.product-type.application";
\t\t};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
\t\t${projId} /* Project object */ = {
\t\t\tisa = PBXProject;
\t\t\tattributes = {
\t\t\t\tBuildIndependentTargetsInParallel = 1;
\t\t\t\tLastSwiftUpdateCheck = 1540;
\t\t\t\tLastUpgradeCheck = 1540;
\t\t\t\tTargetAttributes = {
\t\t\t\t\t${targetId} = {
\t\t\t\t\t\tCreatedOnToolsVersion = 15.4;
\t\t\t\t\t};
\t\t\t\t};
\t\t\t};
\t\t\tbuildConfigurationList = ${projConfigListId} /* Build configuration list for PBXProject "PartifulApp" */;
\t\t\tcompatibilityVersion = "Xcode 14.0";
\t\t\tdevelopmentRegion = en;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (
\t\t\t\ten,
\t\t\t\tBase,
\t\t\t);
\t\t\tmainGroup = ${mainGroupId};
\t\t\tproductRefGroup = ${productsGroupId} /* Products */;
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t${targetId} /* PartifulApp */,
\t\t\t);
\t\t};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
\t\t${resourcesBuildPhaseId} /* Resources */ = {
\t\t\tisa = PBXResourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
\t\t${sourcesBuildPhaseId} /* Sources */ = {
\t\t\tisa = PBXSourcesBuildPhase;
\t\t\tbuildActionMask = 2147483647;
\t\t\tfiles = (
${sourcesSection}\t\t\t);
\t\t\trunOnlyForDeploymentPostprocessing = 0;
\t\t};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
\t\t${projDebugConfigId} /* Debug */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = dwarf;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tENABLE_TESTABILITY = YES;
\t\t\t\tGCC_DYNAMIC_NO_PIC = NO;
\t\t\t\tGCC_OPTIMIZATION_LEVEL = 0;
\t\t\t\tGCC_PREPROCESSOR_DEFINITIONS = (
\t\t\t\t\t"DEBUG=1",
\t\t\t\t\t"$(inherited)",
\t\t\t\t);
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
\t\t\t\tONLY_ACTIVE_ARCH = YES;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-Onone";
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\t${projReleaseConfigId} /* Release */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tALWAYS_SEARCH_USER_PATHS = NO;
\t\t\t\tCLANG_ANALYZER_NONNULL = YES;
\t\t\t\tCLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
\t\t\t\tCLANG_ENABLE_MODULES = YES;
\t\t\t\tCLANG_ENABLE_OBJC_ARC = YES;
\t\t\t\tCOPY_PHASE_STRIP = NO;
\t\t\t\tDEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
\t\t\t\tENABLE_NS_ASSERTIONS = NO;
\t\t\t\tENABLE_STRICT_OBJC_MSGSEND = YES;
\t\t\t\tGCC_OPTIMIZATION_LEVEL = s;
\t\t\t\tIPHONEOS_DEPLOYMENT_TARGET = 17.0;
\t\t\t\tMTL_ENABLE_DEBUG_INFO = NO;
\t\t\t\tSDKROOT = iphoneos;
\t\t\t\tSWIFT_COMPILATION_MODE = wholemodule;
\t\t\t\tSWIFT_OPTIMIZATION_LEVEL = "-O";
\t\t\t\tVALIDATE_PRODUCT = YES;
\t\t\t};
\t\t\tname = Release;
\t\t};
\t\t${targetDebugConfigId} /* Debug */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tCODE_SIGN_IDENTITY = "";
\t\t\t\tCODE_SIGNING_ALLOWED = NO;
\t\t\t\tCODE_SIGNING_REQUIRED = NO;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = "";
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = PartifulApp/Resources/Info.plist;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.partiful.invitemaker;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t};
\t\t\tname = Debug;
\t\t};
\t\t${targetReleaseConfigId} /* Release */ = {
\t\t\tisa = XCBuildConfiguration;
\t\t\tbuildSettings = {
\t\t\t\tCODE_SIGN_IDENTITY = "";
\t\t\t\tCODE_SIGNING_ALLOWED = NO;
\t\t\t\tCODE_SIGNING_REQUIRED = NO;
\t\t\t\tCODE_SIGN_STYLE = Automatic;
\t\t\t\tCURRENT_PROJECT_VERSION = 1;
\t\t\t\tDEVELOPMENT_TEAM = "";
\t\t\t\tGENERATE_INFOPLIST_FILE = NO;
\t\t\t\tINFOPLIST_FILE = PartifulApp/Resources/Info.plist;
\t\t\t\tLD_RUNPATH_SEARCH_PATHS = (
\t\t\t\t\t"$(inherited)",
\t\t\t\t\t"@executable_path/Frameworks",
\t\t\t\t);
\t\t\t\tMARKETING_VERSION = 1.0.0;
\t\t\t\tPRODUCT_BUNDLE_IDENTIFIER = com.partiful.invitemaker;
\t\t\t\tPRODUCT_NAME = "$(TARGET_NAME)";
\t\t\t\tSWIFT_EMIT_LOC_STRINGS = YES;
\t\t\t\tSWIFT_VERSION = 5.0;
\t\t\t\tTARGETED_DEVICE_FAMILY = "1,2";
\t\t\t};
\t\t\tname = Release;
\t\t};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
\t\t${projConfigListId} /* Build configuration list for PBXProject "PartifulApp" */ = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t${projDebugConfigId} /* Debug */,
\t\t\t\t${projReleaseConfigId} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
\t\t${targetConfigListId} /* Build configuration list for PBXNativeTarget "PartifulApp" */ = {
\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t${targetDebugConfigId} /* Debug */,
\t\t\t\t${targetReleaseConfigId} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;
\t\t};
/* End XCConfigurationList section */

\t};
\trootObject = ${projId} /* Project object */;
}
`;

fs.writeFileSync(path.join(xcodeprojDir, 'project.pbxproj'), pbxprojContent);
console.log('Successfully generated PartifulApp.xcodeproj/project.pbxproj');

// Generate xcscheme
const xcschemeContent = `<?xml version="1.0" encoding="UTF-8"?>
<Scheme
   LastUpgradeVersion = "1540"
   version = "1.7">
   <BuildAction
      parallelizeBuildables = "YES"
      buildImplicitDependencies = "YES">
      <BuildActionEntries>
         <BuildActionEntry
            buildForTesting = "YES"
            buildForRunning = "YES"
            buildForProfiling = "YES"
            buildForArchiving = "YES"
            buildForAnalyzing = "YES">
            <BuildableReference
               BuildableIdentifier = "primary"
               BlueprintIdentifier = "${targetId}"
               BuildableName = "PartifulApp.app"
               BlueprintName = "PartifulApp"
               ReferencedContainer = "container:PartifulApp.xcodeproj">
            </BuildableReference>
         </BuildActionEntry>
      </BuildActionEntries>
   </BuildAction>
   <LaunchAction
      buildConfiguration = "Debug"
      selectedDebuggerIdentifier = "Xcode.DebuggerFoundation.Debugger.LLDB"
      selectedLauncherIdentifier = "Xcode.DebuggerFoundation.Launcher.LLDB"
      launchStyle = "0"
      useCustomWorkingDirectory = "NO"
      ignoresPersistentStateOnLaunch = "NO"
      debugDocumentVersioning = "YES"
      debugServiceExtension = "internal"
      allowLocationSimulation = "YES">
      <BuildableProductRunnable
         runnableDebuggingMode = "0">
         <BuildableReference
            BuildableIdentifier = "primary"
            BlueprintIdentifier = "${targetId}"
            BuildableName = "PartifulApp.app"
            BlueprintName = "PartifulApp"
            ReferencedContainer = "container:PartifulApp.xcodeproj">
         </BuildableReference>
      </BuildableProductRunnable>
   </LaunchAction>
   <ArchiveAction
      buildConfiguration = "Release"
      revealArchiveInOrganizer = "YES">
   </ArchiveAction>
</Scheme>`;

fs.writeFileSync(path.join(schemesDir, 'PartifulApp.xcscheme'), xcschemeContent);
console.log('Successfully generated PartifulApp.xcscheme');
