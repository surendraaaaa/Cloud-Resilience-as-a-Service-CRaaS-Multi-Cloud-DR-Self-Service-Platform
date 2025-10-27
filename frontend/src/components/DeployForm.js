import { useState } from 'react';
import { deploy } from '../api/terraform';
import { toast } from 'react-toastify';

export default function DeployForm({ onDeployed }) {
  const [appName, setAppName] = useState('ddr-app');
  const [workspace, setWorkspace] = useState('dev');

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const payload = {
        workspace,
        variables: { app_name: appName },
      };
      toast.info('Starting deployment...');
      const res = await deploy(payload);
      toast.success('Deployment completed successfully!');
      onDeployed();
    } catch (err) {
      console.error(err);
      toast.error('Deployment failed.');
    }
  };

  return (
    <form
      onSubmit={handleSubmit}
      className="bg-white shadow p-6 rounded-md w-full max-w-md"
    >
      <h2 className="text-xl font-semibold mb-4">Deploy Environment</h2>
      <label className="block mb-2 text-sm font-medium">App Name</label>
      <input
        type="text"
        value={appName}
        onChange={(e) => setAppName(e.target.value)}
        className="border p-2 rounded w-full mb-4"
      />

      <label className="block mb-2 text-sm font-medium">Workspace</label>
      <input
        type="text"
        value={workspace}
        onChange={(e) => setWorkspace(e.target.value)}
        className="border p-2 rounded w-full mb-4"
      />

      <button
        type="submit"
        className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
      >
        Deploy
      </button>
    </form>
  );
}
