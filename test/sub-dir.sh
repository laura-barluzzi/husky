# shellcheck shell=bash

# shellcheck source=./_functions.sh
. "$(dirname "$0")/_functions.sh"

# Example:
# .git
# sub/package.json
title "sub directory"
tempDir="/tmp/husky-sub-dir-test"
subDir="$tempDir/sub"

rm -rf $tempDir
cd_and_install_tgz $subDir

cd $tempDir
init_git

# Edit package.json in sub directory
cd $subDir
cat > package.json << EOL
{
	"scripts": {
		"prepare": "cd .. && husky install sub/.husky"
	}
}
EOL

# Install
npm run prepare

# Add hook
npx --no-install husky add pre-commit "echo \"msg from pre-commit hook\" && exit 1"

# Test core.hooksPath
test_hooksPath "sub/.husky"

# Test pre-commit
git add package.json
git commit -m "should fail" || ok
