const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

// Write variables to a tfvars.json file
function writeTfVars(tfPath, workspace, variables) {
  const tfVarsPath = path.join(tfPath, `${workspace}.tfvars.json`);
  fs.writeFileSync(tfVarsPath, JSON.stringify(variables, null, 2));
  return tfVarsPath;
}

// Execute shell command
function execCommand(cmd, cwd) {
  return new Promise((resolve, reject) => {
    exec(cmd, { cwd }, (error, stdout, stderr) => {
      if (error) return reject(error);
      resolve(stdout || stderr);
    });
  });
}

exports.apply = async (tfPath, workspace, variables) => {
  const tfVarsFile = writeTfVars(tfPath, workspace, variables);

  await execCommand(`terraform init -input=false`, tfPath);
  await execCommand(`terraform workspace new ${workspace} || terraform workspace select ${workspace}`, tfPath);
  await execCommand(`terraform apply -input=false -auto-approve -var-file=${tfVarsFile}`, tfPath);
};

exports.destroy = async (tfPath, workspace, variables) => {
  const tfVarsFile = writeTfVars(tfPath, workspace, variables);

  await execCommand(`terraform workspace select ${workspace}`, tfPath);
  await execCommand(`terraform destroy -auto-approve -var-file=${tfVarsFile}`, tfPath);
};

exports.output = async (tfPath, workspace) => {
  await execCommand(`terraform workspace select ${workspace}`, tfPath);
  const out = await execCommand(`terraform output -json`, tfPath);
  return JSON.parse(out);
};
