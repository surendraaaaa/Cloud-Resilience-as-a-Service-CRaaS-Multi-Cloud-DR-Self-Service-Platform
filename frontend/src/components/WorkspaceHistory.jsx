import { useEffect, useState } from 'react';
import { getHistory, destroy } from '../api/terraform';
import { toast } from 'react-toastify';

export default function WorkspaceHistory() {
  const [history, setHistory] = useState([]);

  const fetchHistory = async () => {
    try {
      const res = await getHistory();
      setHistory(res.data);
    } catch (err) {
      console.error(err);
      toast.error('Failed to load history.');
    }
  };

  const handleDestroy = async (workspace) => {
    if (window.confirm(`Destroy ${workspace}?`)) {
      try {
        await destroy(workspace);
        toast.success(`Workspace ${workspace} destroyed`);
        fetchHistory();
      } catch (err) {
        console.error(err);
        toast.error('Failed to destroy workspace.');
      }
    }
  };

  useEffect(() => {
    fetchHistory();
  }, []);

  return (
    <div className="bg-white p-6 rounded-md shadow mt-6">
      <h2 className="text-lg font-semibold mb-4">Deployment History</h2>
      <table className="w-full text-sm">
        <thead>
          <tr className="border-b">
            <th className="p-2 text-left">Workspace</th>
            <th className="p-2 text-left">App Name</th>
            <th className="p-2">Created</th>
            <th className="p-2">Actions</th>
          </tr>
        </thead>
        <tbody>
          {history.map((item) => (
            <tr key={item.id} className="border-b">
              <td className="p-2">{item.workspace}</td>
              <td className="p-2">{item.app_name}</td>
              <td className="p-2">{new Date(item.created_at).toLocaleString()}</td>
              <td className="p-2 text-center">
                <button
                  onClick={() => handleDestroy(item.workspace)}
                  className="text-red-500 hover:text-red-700"
                >
                  Destroy
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
