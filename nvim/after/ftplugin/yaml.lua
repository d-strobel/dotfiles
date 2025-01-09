-- Check if file is an ansible file.
local function is_ansible()
  -- Filenames that indicate an Ansible filetype.
  local ansibleFilenames = {
    "site.ya?ml",
    "playbook.ya?ml",
  }

  -- Filepaths that indicate an Ansible filetype.
  local ansiblePaths = {
    "./tasks/.*%.ya?ml",
  }

  -- Check filenames.
  local filename = vim.fn.expand("%:t")
  for _, name in pairs(ansibleFilenames) do
    if string.match(filename, name) then
      return true
    end
  end

  -- Check Filepaths.
  local filepath = vim.fn.expand("%:p")
  for _, path in pairs(ansiblePaths) do
    if string.match(filepath, path) then
      return true
    end
  end

  return false
end

if is_ansible() then
  vim.bo.filetype = "ansible"
end
