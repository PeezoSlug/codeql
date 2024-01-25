package project

import (
	"log"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strings"

	"github.com/github/codeql-go/extractor/diagnostics"
	"github.com/github/codeql-go/extractor/util"
	"golang.org/x/mod/modfile"
	"golang.org/x/mod/semver"
)

// Represents information about a `go.mod` file: this is at least the path to the `go.mod` file,
// plus the parsed contents of the file, if available.
type GoModule struct {
	Path   string        // The path to the `go.mod` file
	Module *modfile.File // The parsed contents of the `go.mod` file
}

// Represents information about a Go project workspace: this may either be a folder containing
// a `go.work` file or a collection of `go.mod` files.
type GoWorkspace struct {
	BaseDir       string            // The base directory for this workspace
	UseGoMod      bool              // Whether to use modules or not
	WorkspaceFile *modfile.WorkFile // The `go.work` file for this workspace
	Modules       []*GoModule       // A list of `go.mod` files
}

// Determines whether any of the directory paths in the input are nested.
func checkDirsNested(inputDirs []string) (string, bool) {
	// replace "." with "" so that we can check if all the paths are nested
	dirs := make([]string, len(inputDirs))
	for i, inputDir := range inputDirs {
		if inputDir == "." {
			dirs[i] = ""
		} else {
			dirs[i] = inputDir
		}
	}
	// the paths were generated by a depth-first search so I think they might
	// be sorted, but we sort them just in case
	sort.Strings(dirs)
	for _, dir := range dirs {
		if !strings.HasPrefix(dir, dirs[0]) {
			return "", false
		}
	}
	return dirs[0], true
}

// Find all go.work files in the working directory and its subdirectories
func findGoWorkFiles() []string {
	return util.FindAllFilesWithName(".", "go.work", "vendor")
}

// Find all go.mod files in the specified directory and its subdirectories
func findGoModFiles(root string) []string {
	return util.FindAllFilesWithName(root, "go.mod", "vendor")
}

// Given a list of `go.mod` file paths, try to parse them all. The resulting array of `GoModule` objects
// will be the same length as the input array and the objects will contain at least the `go.mod` path.
// If parsing the corresponding file is successful, then the parsed contents will also be available.
func loadGoModules(goModFilePaths []string) []*GoModule {
	results := make([]*GoModule, len(goModFilePaths))

	for i, goModFilePath := range goModFilePaths {
		results[i] = new(GoModule)
		results[i].Path = goModFilePath

		modFileSrc, err := os.ReadFile(goModFilePath)

		if err != nil {
			log.Printf("Unable to read %s: %s.\n", goModFilePath, err.Error())
			continue
		}

		modFile, err := modfile.ParseLax(goModFilePath, modFileSrc, nil)

		if err != nil {
			log.Printf("Unable to parse %s: %s.\n", goModFilePath, err.Error())
			continue
		}

		results[i].Module = modFile
	}

	return results
}

// Given a path to a `go.work` file, this function attempts to parse the `go.work`. If unsuccessful,
// we attempt to discover `go.mod` files within subdirectories of the directory containing the `go.work`
// file ourselves.
func discoverWorkspace(workFilePath string) GoWorkspace {
	log.Printf("Loading %s...\n", workFilePath)
	baseDir := filepath.Dir(workFilePath)
	workFileSrc, err := os.ReadFile(workFilePath)

	if err != nil {
		// We couldn't read the `go.work` file for some reason; let's try to find `go.mod` files ourselves
		log.Printf("Unable to read %s, falling back to finding `go.mod` files manually:\n%s\n", workFilePath, err.Error())
		return GoWorkspace{
			BaseDir:  baseDir,
			UseGoMod: true,
			Modules:  loadGoModules(findGoModFiles(baseDir)),
		}
	}

	workFile, err := modfile.ParseWork(workFilePath, workFileSrc, nil)

	if err != nil {
		// The `go.work` file couldn't be parsed for some reason; let's try to find `go.mod` files ourselves
		log.Printf("Unable to parse %s, falling back to finding `go.mod` files manually:\n%s\n", workFilePath, err.Error())
		return GoWorkspace{
			BaseDir:  baseDir,
			UseGoMod: true,
			Modules:  loadGoModules(findGoModFiles(baseDir)),
		}
	}

	// Get the paths of all of the `go.mod` files that we read from the `go.work` file.
	goModFilePaths := make([]string, len(workFile.Use))

	for i, use := range workFile.Use {
		if filepath.IsAbs(use.Path) {
			// TODO: This case might be problematic for some other logic (e.g. stray file detection)
			goModFilePaths[i] = filepath.Join(use.Path, "go.mod")
		} else {
			goModFilePaths[i] = filepath.Join(filepath.Dir(workFilePath), use.Path, "go.mod")
		}
	}

	log.Printf("%s uses the following Go modules:\n%s\n", workFilePath, strings.Join(goModFilePaths, "\n"))

	return GoWorkspace{
		BaseDir:       baseDir,
		UseGoMod:      true,
		WorkspaceFile: workFile,
		Modules:       loadGoModules(goModFilePaths),
	}
}

// Analyse the working directory to discover workspaces.
func discoverWorkspaces(emitDiagnostics bool) []GoWorkspace {
	// Try to find any `go.work` files which may exist in the working directory.
	goWorkFiles := findGoWorkFiles()

	if len(goWorkFiles) == 0 {
		// There is no `go.work` file. Find all `go.mod` files in the working directory.
		log.Println("Found no go.work files in the workspace; looking for go.mod files...")

		goModFiles := findGoModFiles(".")

		// Return a separate workspace for each `go.mod` file that we found.
		results := make([]GoWorkspace, len(goModFiles))

		for i, goModFile := range goModFiles {
			results[i] = GoWorkspace{
				BaseDir:  filepath.Dir(goModFile),
				UseGoMod: true,
				Modules:  loadGoModules([]string{goModFile}),
			}
		}

		return results
	} else {
		// We have found `go.work` files, try to load them all.
		log.Printf("Found go.work files in %s.\n", strings.Join(goWorkFiles, ", "))

		if emitDiagnostics {
			diagnostics.EmitGoWorkFound(goWorkFiles)
		}

		results := make([]GoWorkspace, len(goWorkFiles))
		for i, workFilePath := range goWorkFiles {
			results[i] = discoverWorkspace(workFilePath)
		}
		return results
	}
}

// Returns the directory to run the go build in and whether to use a go.mod
// file.
func getBuildRoot(emitDiagnostics bool) (baseDirs []string, useGoMod bool) {
	goModPaths := util.FindAllFilesWithName(".", "go.mod", "vendor")
	if len(goModPaths) == 0 {
		baseDirs = []string{"."}
		useGoMod = false
		return
	}
	goModDirs := util.GetParentDirs(goModPaths)
	if util.AnyGoFilesOutsideDirs(".", goModDirs...) {
		if emitDiagnostics {
			diagnostics.EmitGoFilesOutsideGoModules(goModPaths)
		}
		baseDirs = []string{"."}
		useGoMod = false
		return
	}
	if len(goModPaths) > 1 {
		// currently not supported
		baseDirs = []string{"."}
		commonRoot, nested := checkDirsNested(goModDirs)
		if nested && commonRoot == "" {
			useGoMod = true
		} else {
			useGoMod = false
		}
		if emitDiagnostics {
			if nested {
				diagnostics.EmitMultipleGoModFoundNested(goModPaths)
			} else {
				diagnostics.EmitMultipleGoModFoundNotNested(goModPaths)
			}
	baseDirs = goModDirs
	useGoMod = true
	return
}

// DependencyInstallerMode is an enum describing how dependencies should be installed
type DependencyInstallerMode int

const (
	// GoGetNoModules represents dependency installation using `go get` without modules
	GoGetNoModules DependencyInstallerMode = iota
	// GoGetWithModules represents dependency installation using `go get` with modules
	GoGetWithModules
	// Dep represent dependency installation using `dep ensure`
	Dep
	// Glide represents dependency installation using `glide install`
	Glide
)

// Returns the appropriate DependencyInstallerMode for the current project
func getDepMode(emitDiagnostics bool) (DependencyInstallerMode, []string) {
	bazelPaths := util.FindAllFilesWithName(".", "BUILD", "vendor")
	bazelPaths = append(bazelPaths, util.FindAllFilesWithName(".", "BUILD.bazel", "vendor")...)
	if len(bazelPaths) > 0 {
		// currently not supported
		if emitDiagnostics {
			diagnostics.EmitBazelBuildFilesFound(bazelPaths)
		}
	}

	goWorkPaths := util.FindAllFilesWithName(".", "go.work", "vendor")
	if len(goWorkPaths) > 0 {
		// currently not supported
		if emitDiagnostics {
			diagnostics.EmitGoWorkFound(goWorkPaths)
		}
	}

	baseDirs, useGoMod := getBuildRoot(emitDiagnostics)
	if useGoMod {
		log.Printf("Found go.mod files in %s: enabling go modules.\n", strings.Join(baseDirs, ", "))
		return GoGetWithModules, baseDirs
	}

	if util.FileExists("Gopkg.toml") {
		if emitDiagnostics {
			diagnostics.EmitGopkgTomlFound()
		}
		log.Println("Found Gopkg.toml, using dep instead of go get")
		return Dep, []string{"."}
	}

	if util.FileExists("glide.yaml") {
		if emitDiagnostics {
			diagnostics.EmitGlideYamlFound()
		}
		log.Println("Found glide.yaml, using Glide instead of go get")
		return Glide, []string{"."}
	}
	return GoGetNoModules, []string{"."}
}

// ModMode corresponds to the possible values of the -mod flag for the Go compiler
type ModMode int

const (
	ModUnset ModMode = iota
	ModReadonly
	ModMod
	ModVendor
)

// argsForGoVersion returns the arguments to pass to the Go compiler for the given `ModMode` and
// Go version
func (m ModMode) ArgsForGoVersion(version string) []string {
	switch m {
	case ModUnset:
		return []string{}
	case ModReadonly:
		return []string{"-mod=readonly"}
	case ModMod:
		if !semver.IsValid(version) {
			log.Fatalf("Invalid Go semver: '%s'", version)
		}
		if semver.Compare(version, "v1.14") < 0 {
			return []string{} // -mod=mod is the default behaviour for go <= 1.13, and is not accepted as an argument
		} else {
			return []string{"-mod=mod"}
		}
	case ModVendor:
		return []string{"-mod=vendor"}
	}
	return nil
}

// Returns the appropriate ModMode for the current project
func getModMode(depMode DependencyInstallerMode, baseDir string) ModMode {
	if depMode == GoGetWithModules {
		// if a vendor/modules.txt file exists, we assume that there are vendored Go dependencies, and
		// skip the dependency installation step and run the extractor with `-mod=vendor`
		if util.FileExists(filepath.Join(baseDir, "vendor", "modules.txt")) {
			return ModVendor
		} else if util.DirExists(filepath.Join(baseDir, "vendor")) {
			return ModMod
		}
	}
	return ModUnset
}

type BuildInfo struct {
	DepMode DependencyInstallerMode
	ModMode ModMode
	BaseDir string
}

func GetBuildInfo(emitDiagnostics bool) []BuildInfo {
	depMode, baseDirs := getDepMode(true)
	results := make([]BuildInfo, len(baseDirs))

	for i, baseDir := range baseDirs {
		modMode := getModMode(depMode, baseDir)
		results[i] = BuildInfo{depMode, modMode, baseDir}
	}

	return results
}

type GoVersionInfo struct {
	// The version string, if any
	Version string
	// A value indicating whether a version string was found
	Found bool
}

// Tries to open `go.mod` and read a go directive, returning the version and whether it was found.
func TryReadGoDirective(buildInfo BuildInfo) GoVersionInfo {
	if buildInfo.DepMode == GoGetWithModules {
		versionRe := regexp.MustCompile(`(?m)^go[ \t\r]+([0-9]+\.[0-9]+(\.[0-9]+)?)$`)
		goMod, err := os.ReadFile(filepath.Join(buildInfo.BaseDir, "go.mod"))
		if err != nil {
			log.Println("Failed to read go.mod to check for missing Go version")
		} else {
			matches := versionRe.FindSubmatch(goMod)
			if matches != nil {
				if len(matches) > 1 {
					return GoVersionInfo{string(matches[1]), true}
				}
			}
		}
	}
	return GoVersionInfo{"", false}
}
