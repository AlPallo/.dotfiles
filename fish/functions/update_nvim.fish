function update-nvim
  set NVIM_REPO $HOME/src/neovim

  if not test -d $NVIM_REPO/.git
      echo "Error: No Git repo found at $NVIM_REPO"
      return 1
  end

  cd $NVIM_REPO
  echo "Fetching all tags from origin..."
  git fetch --tags --force
  echo "Checking out stable tag..."

  git checkout -B stable-build tags/stable
  echo "Cleaning old build artifacts..."

  rm -rf build .deps
  echo "Building Neovim..."
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  echo "Installing Neovim..."
  sudo make install
  echo "Neovim update complete!"
  nvim --version
end
