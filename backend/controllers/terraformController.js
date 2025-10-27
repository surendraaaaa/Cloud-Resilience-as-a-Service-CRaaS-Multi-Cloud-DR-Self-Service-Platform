const { exec } = require('child_process');
const pool = require('../db/db');

exports.deploy = async (req, res) => {
  const { workspace, variables } = req.body;

  if (!workspace || !variables) {
    return res.status(400).json({ error: 'Workspace and variables are required' });
  }

  const tfCmd = `terraform -chdir=./terraform/environments/example-aws-azure init && terraform -chdir=./terraform/environments/example-aws-azure apply -auto-approve -var="app_name=${variables.app_name}"`;

  const terraformProcess = exec(tfCmd);

  terraformProcess.stdout.on('data', (data) => {
    console.log(data.toString());
  });

  terraformProcess.stderr.on('data', (data) => {
    console.error(data.toString());
  });

  terraformProcess.on('close', async (code) => {
    if (code === 0) {
      // TODO: You can parse terraform output JSON if needed
      const outputs = { message: 'Terraform applied successfully' };
      try {
        await pool.query(
          'INSERT INTO workspaces(workspace, app_name, outputs) VALUES (?, ?, ?)',
          [workspace, variables.app_name, JSON.stringify(outputs)]
        );
        res.json({ success: true, outputs });
      } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database insert failed' });
      }
    } else {
      res.status(500).json({ error: 'Terraform failed' });
    }
  });
};

exports.getHistory = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM workspaces ORDER BY created_at DESC');
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch history' });
  }
};

exports.destroy = async (req, res) => {
  const { workspace } = req.body;

  if (!workspace) {
    return res.status(400).json({ error: 'Workspace is required' });
  }

  const tfCmd = `terraform -chdir=./terraform/environments/example-aws-azure destroy -auto-approve`;

  const terraformProcess = exec(tfCmd);

  terraformProcess.stdout.on('data', (data) => console.log(data.toString()));
  terraformProcess.stderr.on('data', (data) => console.error(data.toString()));

  terraformProcess.on('close', async (code) => {
    if (code === 0) {
      try {
        await pool.query('DELETE FROM workspaces WHERE workspace=?', [workspace]);
        res.json({ success: true, message: 'Workspace destroyed' });
      } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database delete failed' });
      }
    } else {
      res.status(500).json({ error: 'Terraform destroy failed' });
    }
  });
};
