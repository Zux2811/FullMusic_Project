import { useEffect, useState } from "react";
import api from "../api/api.js";
import ReportTable from "../components/ReportTable.jsx";

export default function ReportsPage() {
  const [reports, setReports] = useState([]);

  const fetchReports = async () => {
    // Canonical endpoint moved to /api/reports (admin-authenticated)
    const res = await api.get("/reports");
    setReports(res.data);
  };

  useEffect(() => {
    fetchReports();
  }, []);

  return (
    <>
      <h2>Báo cáo bình luận</h2>
      <ReportTable reports={reports} />
    </>
  );
}
